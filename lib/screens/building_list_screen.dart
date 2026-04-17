import 'package:flutter/material.dart';
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../controller/building_list_controller.dart';
import '../entity/building_entity.dart';
import '../utils/app_constants.dart';
import '../utils/map_utils.dart';
import '../widgets/building_list_view.dart';
import '../widgets/building_map_view.dart';
import '../widgets/toggle_button.dart';
import 'building_detail_screen.dart';
import 'publication_detail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../providers/language_provider.dart';
import 'dart:async';

class BuildingsListScreen extends StatefulWidget {
  const BuildingsListScreen({super.key});

  @override
  State<BuildingsListScreen> createState() => _BuildingsListScreenState();
}

class _BuildingsListScreenState extends State<BuildingsListScreen> {
  final ScrollController _scrollController = ScrollController();
  GoogleMapController? _googleMapController;

  bool _isFiltersExpanded = false;
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounceSearch;

  bool _listView = false;
  BitmapDescriptor _iconoEdificio = BitmapDescriptor.defaultMarker;
  BitmapDescriptor _iconoYo = BitmapDescriptor.defaultMarker;
  // Mapa en modo oscuro
  String? _mapStyleDark;

  @override
  void initState() {
    super.initState();

    _cargarEstiloMapa();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialData();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final controller = context.read<BuildingListController>();
        if (!controller.isLoading && controller.hasMoreData && _listView) {
          _moreBuildings();
        }
      }
    });
  }

  Future<void> _cargarEstiloMapa() async {
    final estilo = await rootBundle.loadString(AppConstants.mapStyleDarkPath);

    if (mounted) {
      setState(() {
        _mapStyleDark = estilo;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarIconosPersonalizados();
  }

  Future<void> _cargarIconosPersonalizados() async {
    final colores = Theme.of(context).colorScheme;
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final iconoEdificio = await crearIconoDesdeFlutter(
      Icons.location_on,
      colores.primary,
      pixelRatio,
    );
    final iconoYo = await crearIconoDesdeFlutter(
      Icons.person_pin_circle,
      colores.primary,
      pixelRatio,
    );

    if (mounted) {
      setState(() {
        _iconoEdificio = iconoEdificio;
        _iconoYo = iconoYo;
      });
    }
  }

  Future<void> _initialData() async {
    try {
      await context.read<BuildingListController>().initialData();
    } catch (e) {
      if (mounted) _errorNetwork();
    }
  }

  Future<void> _filterByPublication(int idPublicacion) async {
    try {
      if (idPublicacion == 0) {
        await context.read<BuildingListController>().clearFilter();
      } else {
        await context.read<BuildingListController>().applyFilter(idPublicacion);
      }
    } catch (e) {
      if (mounted) _errorNetwork();
    }
  }

  Future<void> _moreBuildings() async {
    try {
      await context.read<BuildingListController>().fetchNextPage();
    } catch (e) {
      if (mounted) _errorNetwork();
    }
  }

  Future<void> _useGPS() async {
    final controller = context.read<BuildingListController>();
    try {
      await controller.activateGPS();
      if (!mounted) return;

      if (!_listView && controller.location.latitude != 0) {
        _googleMapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(controller.location.latitude, controller.location.longitude),
            AppConstants.detailMapZoom,
          ),
        );
      }
    } catch (e) {
      if (mounted) _errorNetwork();
    }
  }

  Future<void> _onNearbyButtonPressed() async {
    try {
      final controller = context.read<BuildingListController>();
      await controller.nearbyBuildings();

      if (!_listView && controller.location.latitude != 0) {
        _googleMapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(controller.location.latitude, controller.location.longitude),
            AppConstants.detailMapZoom,
          ),
        );
      }
    } catch (e) {
      if (mounted) _errorNetwork();
    }
  }

  void _errorNetwork() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.connectionError),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _debounceSearch?.cancel();
    context.read<BuildingListController>().stopTracking();
    _scrollController.dispose();
    _googleMapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _navegarADetalle(
    Building edificio,
    BuildingListController controller,
  ) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuildingDetailScreen(
          building: edificio,
          location: controller.location,
        ),
      ),
    );

    if (!mounted) return;
    if (result == 'show_map') {
      setState(() => _listView = false);
      Future.delayed(const Duration(milliseconds: 300), () {
        if (edificio.latitude != 0 && edificio.longitude != 0) {
          _googleMapController?.animateCamera(
            CameraUpdate.newLatLngZoom(
              LatLng(edificio.latitude, edificio.longitude),
              AppConstants.detailMapZoom,
            ),
          );
        }
      });
    }
  }

  // Función para la barra de búsqueda para acercar a la edifiación deseada
  void _ajustarMapaBusqueda(List<Building> edificios, LatLng userLocation, {bool isClear = false}) {
    if (_googleMapController == null || _listView) return;

    if (isClear || edificios.isEmpty) {
      if (userLocation.latitude != 0 && userLocation.longitude != 0) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(userLocation, AppConstants.detailMapZoom),
        );
      } else {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(const LatLng(41.3851, 2.1734), 13.0),
        );
      }
      return;
    }

    // ✨ Filtramos a los edificios rebeldes sin coordenadas UwU ✨
    final validBuildings = edificios.where((b) => b.latitude != 0 && b.longitude != 0).toList();
    if (validBuildings.isEmpty) return;

    if (validBuildings.length == 1) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(validBuildings.first.latitude, validBuildings.first.longitude),
          AppConstants.detailMapZoom,
        ),
      );
    } else {
      double minLat = validBuildings.first.latitude;
      double maxLat = validBuildings.first.latitude;
      double minLng = validBuildings.first.longitude;
      double maxLng = validBuildings.first.longitude;

      for (var b in validBuildings) {
        if (b.latitude < minLat) minLat = b.latitude;
        if (b.latitude > maxLat) maxLat = b.latitude;
        if (b.longitude < minLng) minLng = b.longitude;
        if (b.longitude > maxLng) maxLng = b.longitude;
      }

      if (minLat == maxLat && minLng == maxLng) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(minLat, minLng),
            AppConstants.detailMapZoom,
          ),
        );
        return;
      }

      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      _googleMapController!.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 50.0), 
      );
    }
  }

  Widget _buildFloatingUI(
    ColorScheme colores, 
    bool isHighContrast, 
    String langCode, 
    BuildingListController controller,
    LatLng userPos // <--- ¡AQUÍ ESTÁ!
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    controller.setSearchQuery(value);
                    setState(() {}); 
                    
                    if (_debounceSearch?.isActive ?? false) {
                      _debounceSearch!.cancel();
                    }
                    
                    _debounceSearch = Timer(const Duration(milliseconds: 600), () {
                      if (mounted && !_listView) {
                        _ajustarMapaBusqueda(controller.filteredBuildings, userPos);
                      }
                    });
                  },
                  onSubmitted: (value) {
                    if (_debounceSearch?.isActive ?? false) _debounceSearch!.cancel();
                    if (mounted && !_listView) {
                      _ajustarMapaBusqueda(controller.filteredBuildings, userPos);
                    }
                  },
                  style: TextStyle(
                    color: isHighContrast ? colores.onSurface : colores.onSurface,
                    fontWeight: isHighContrast ? FontWeight.bold : FontWeight.normal,
                  ),
                  cursorColor: isHighContrast ? colores.onSurface : colores.primary,
                  decoration: InputDecoration(
                    hintText: '${context.loc.searchBuilding}...',
                    hintStyle: TextStyle(
                      color: isHighContrast ? colores.onSurface.withValues(alpha: 0.6) : colores.onSurfaceVariant,
                      fontWeight: isHighContrast ? FontWeight.w600 : FontWeight.normal,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isHighContrast ? colores.onSurface : colores.primary,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty 
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, color: isHighContrast ? colores.onSurface : colores.onSurfaceVariant),
                          onPressed: () {
                            _searchController.clear();
                            controller.setSearchQuery('');
                            FocusScope.of(context).unfocus();
                            setState(() {});

                            if (_debounceSearch?.isActive ?? false) _debounceSearch!.cancel();
                            if (mounted && !_listView) {
                              // ✨ Al borrar, le decimos que vuelva al usuario UwU ✨
                              _ajustarMapaBusqueda(controller.filteredBuildings, userPos, isClear: true);
                            }
                          },
                        ) 
                      : null,
                    filled: true,
                    fillColor: isHighContrast
                        ? colores.surface
                        : colores.surfaceContainerHighest.withValues(alpha: 1),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: isHighContrast
                          ? BorderSide(color: colores.onSurface, width: 2.0)
                          : const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: isHighContrast
                          ? BorderSide(color: colores.onSurface, width: 3.0)
                          : BorderSide(color: colores.primary, width: 2.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildFilterToggle(colores, isHighContrast),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          child: _isFiltersExpanded
              ? Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildFilter(
                          texto: context.loc.all,
                          isSelected: controller.currentMode == SearchMode.all,
                          onTap: () {
                            _filterByPublication(0);
                            Future.delayed(const Duration(milliseconds: 300), () {
                              // ✨ Al quitar filtros, vuelve al usuario si no hay búsqueda ✨
                              if (mounted && !_listView) {
                                _ajustarMapaBusqueda(controller.filteredBuildings, userPos, isClear: _searchController.text.isEmpty);
                              }
                            });
                          },
                          colores: colores,
                          isHighContrast: isHighContrast,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildFilter(
                          texto: context.loc.publications,
                          icono: Icons.keyboard_arrow_down_rounded,
                          isSelected: controller.currentMode == SearchMode.publication,
                          // ✨ Pasamos userPos también aquí UwU ✨
                          onTap: () => _showPublicationsMenu(controller, colores, isHighContrast, langCode, userPos),
                          colores: colores,
                          isHighContrast: isHighContrast,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildFilter(
                          texto: context.loc.nearby,
                          icono: Icons.location_on_outlined,
                          isSelected: controller.currentMode == SearchMode.nearby,
                          onTap: () => _onNearbyButtonPressed(),
                          colores: colores,
                          isHighContrast: isHighContrast,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: isHighContrast ? colores.surface : colores.surface.withValues(alpha: 1),
                borderRadius: BorderRadius.circular(20),
                border: isHighContrast ? Border.all(color: colores.onSurface, width: 2) : null,
              ),
              child: Text(
                '${controller.filteredBuildings.length} ${context.loc.buildingsByDistance}',
                style: TextStyle(
                  fontSize: 13,
                  color: isHighContrast ? colores.onSurface : colores.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8), 
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;
    final langCode = context.watch<LanguageProvider>().currentLocale.languageCode;

    return Scaffold(
      backgroundColor: colores.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Globus Vermell',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isHighContrast
                    ? colores.onSurface
                    : Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<BuildingListController>(
        builder: (context, controller, child) {
          return FloatingActionButton(
            onPressed: () => controller.isLoading ? null : _useGPS(),
            backgroundColor: isHighContrast ? colores.surface : colores.primary,
            shape: isHighContrast
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: colores.onSurface, width: 2.0),
                  )
                : null,
            child: controller.isLoading
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      color: isHighContrast
                          ? colores.onSurface
                          : colores.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : Icon(
                    Icons.my_location,
                    color: isHighContrast
                        ? colores.onSurface
                        : colores.onPrimary,
                  ),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ToggleButton(
                    icon: Icons.location_on_outlined,
                    text: context.loc.map,
                    isSelected: !_listView,
                    onTap: () => setState(() => _listView = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ToggleButton(
                    icon: Icons.format_list_bulleted,
                    text: context.loc.list,
                    isSelected: _listView,
                    onTap: () => setState(() => _listView = true),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<BuildingListController>(
              builder: (context, controller, child) {
                final userPos = LatLng(controller.location.latitude, controller.location.longitude);

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: _listView
                      ? Column(
                          key: const ValueKey('ListaLayout'),
                          children: [
                            // ✨ AJUSTE 3: Pasamos userPos a la UI ✨
                            _buildFloatingUI(colores, isHighContrast, langCode, controller, userPos),
                            Expanded(
                              child: BuildingListView(
                                controller: controller,
                                scrollController: _scrollController,
                                onNavigateToDetail: _navegarADetalle,
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          key: const ValueKey('MapaLayout'),
                          children: [
                            Positioned.fill(
                              child: BuildingMapView(
                                controller: controller,
                                mapStyleDark: _mapStyleDark,
                                iconoYo: _iconoYo,
                                iconoEdificio: _iconoEdificio,
                                onMapCreated: (GoogleMapController googleController) {
                                  _googleMapController = googleController;
                                },
                                onNavigateToDetail: _navegarADetalle,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: _buildFloatingUI(colores, isHighContrast, langCode, controller, userPos),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPublicationsMenu(
    BuildingListController controller,
    ColorScheme colores,
    bool isHighContrast,
    String langCode,
    LatLng userPos,
  ) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: context.loc.close,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 275, left: 16, right: 16),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighContrast ? colores.surface : colores.surface,
              borderRadius: BorderRadius.circular(12),
              border: isHighContrast
                  ? Border.all(color: colores.onSurface, width: 2.0)
                  : null,
              boxShadow: isHighContrast
                  ? null
                  : [
                      BoxShadow(
                        color: colores.shadow.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.45,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.publicationsFilter.length,
                      itemBuilder: (context, index) {
                        final pub = controller.publicationsFilter[index];
                        return ListTile(
                          title: Text(
                            pub.getLocalizedTitle(langCode),
                            style: TextStyle(
                              fontSize: 14,
                              color: isHighContrast
                                  ? colores.onSurface
                                  : colores.onSurface,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _filterByPublication(pub.idPublication);
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if (mounted && !_listView) _ajustarMapaBusqueda(controller.filteredBuildings, userPos);
                            });
                          },
                          trailing: IconButton(
                            icon: Icon(
                              Icons.info_outline,
                              color: isHighContrast
                                  ? colores.onSurface
                                  : colores.primary,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PublicationDetailScreen(publication: pub),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 4.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: isHighContrast
                              ? colores.surface
                              : colores.primary,
                          foregroundColor: isHighContrast
                              ? colores.onSurface
                              : colores.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: isHighContrast
                                ? BorderSide(
                                    color: colores.onSurface,
                                    width: 2.0,
                                  )
                                : BorderSide.none,
                          ),
                        ),
                        child: Text(
                          context.loc.close,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.1),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOut)),
          child: FadeTransition(opacity: anim1, child: child),
        );
      },
    );
  }

  // Botón de Filtro con icono de embudo
  Widget _buildFilterToggle(ColorScheme colores, bool isHighContrast) {
    final isSelected = _isFiltersExpanded;
    final bgColor = isHighContrast
        ? colores.surface
        : (isSelected
              ? colores.primary
              : colores.surfaceContainerHighest.withValues(alpha: 1));
    final textColor = isHighContrast
        ? colores.onSurface
        : (isSelected ? colores.onPrimary : colores.primary);

    final borderSide = isHighContrast && isSelected
        ? BorderSide(color: colores.onSurface, width: 3.0)
        : isHighContrast
        ? BorderSide(color: colores.onSurface, width: 2.0)
        : BorderSide.none;

    return InkWell(
      onTap: () {
        setState(() {
          _isFiltersExpanded = !_isFiltersExpanded;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
            16,
          ), // Cuadradito redondeado bonito
          border: Border.fromBorderSide(borderSide),
        ),
        child: Icon(
          isSelected
              ? Icons.tune_rounded
              : Icons.tune_outlined, // Icono de ajustes/filtros
          size: 24,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildFilter({
    required String texto,
    IconData? icono,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colores,
    required bool isHighContrast,
  }) {
    final bgColor = isHighContrast
        ? colores.surface
        : (isSelected ? colores.primary : colores.surface);
    final textColor = isHighContrast
        ? colores.onSurface
        : (isSelected ? colores.onPrimary : colores.onSurface);

    final borderSide = isHighContrast && isSelected
        ? BorderSide(color: colores.onSurface, width: 3.0)
        : isHighContrast
        ? BorderSide(color: colores.onSurface, width: 1.0)
        : BorderSide(
            color: isSelected
                ? colores.primary
                : colores.outline.withValues(alpha: 0.3),
            width: 1.0,
          );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.fromBorderSide(borderSide),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icono != null) ...[
              Icon(icono, size: 16, color: textColor),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                texto,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
