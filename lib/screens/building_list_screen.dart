import 'package:flutter/material.dart';
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../controllers/building_list_controller.dart';
import '../models/building/building_entity.dart';
import '../widgets/building_card.dart';
import '../widgets/toggle_button.dart';
import 'building_detail_screen.dart';
import 'publication_detail_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

class BuildingsListScreen extends StatefulWidget {
  const BuildingsListScreen({super.key});

  @override
  State<BuildingsListScreen> createState() => _BuildingsListScreenState();
}

class _BuildingsListScreenState extends State<BuildingsListScreen> {
  final ScrollController _scrollController = ScrollController();
  GoogleMapController? _googleMapController;

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
    final estilo = await rootBundle.loadString('assets/map_styles/dark_mode.json');
    
    if (mounted) {
      setState(() {
        _mapStyleDark = estilo;
      });
      
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      
      if (_googleMapController != null) {
        if (isDarkMode) {
          _googleMapController!.setMapStyle(_mapStyleDark); 
        } else {
          _googleMapController!.setMapStyle(null); 
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cargarIconosPersonalizados();
    if (_mapStyleDark != null) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      try {
        _googleMapController?.setMapStyle(isDarkMode ? _mapStyleDark : null);
      } catch (e) {
        // Si el mapa es un fantasmita (estamos en la vista de lista), lo ignoramos 
      }
    }
  }

  Future<void> _cargarIconosPersonalizados() async {
    final colores = Theme.of(context).colorScheme;
    final iconoEdificio = await _crearIconoDesdeFlutter(Icons.location_on, colores.primary);
    final iconoYo = await _crearIconoDesdeFlutter(Icons.person_pin_circle, colores.primary);

    if (mounted) {
      setState(() {
        _iconoEdificio = iconoEdificio;
        _iconoYo = iconoYo;
      });
    }
  }

  Future<BitmapDescriptor> _crearIconoDesdeFlutter(IconData icono, Color color) async {
    final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    
    final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icono.codePoint),
      style: TextStyle(
        fontSize: 120.0, 
        fontFamily: icono.fontFamily,
        package: icono.fontPackage,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(0.0, 0.0));

    final ui.Image image = await pictureRecorder.endRecording().toImage(
      textPainter.width.toInt(), 
      textPainter.height.toInt()
    );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List(), imagePixelRatio: pixelRatio);
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
            17.0
          )
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

      _googleMapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(controller.location.latitude, controller.location.longitude), 
          17.0
        )
      );
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
    context.read<BuildingListController>().stopTracking();
    _scrollController.dispose();
    _googleMapController?.dispose(); 
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
              17.0
            )
          );
        }
      });
    }
  } 

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;

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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildFilter(
                              texto: context.loc.all,
                              isSelected:
                                  controller.currentMode == SearchMode.all,
                              onTap: () {
                                _filterByPublication(0);
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
                              isSelected:
                                  controller.currentMode ==
                                  SearchMode.publication,
                              onTap: () {
                                _showPublicationsMenu(
                                  controller,
                                  colores,
                                  isHighContrast,
                                );
                              },
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
                              isSelected:
                                  controller.currentMode == SearchMode.nearby,
                              onTap: () {
                                _onNearbyButtonPressed();
                              },
                              colores: colores,
                              isHighContrast: isHighContrast,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${controller.buildings.length} ${context.loc.buildingsByDistance}',
                          style: TextStyle(
                            fontSize: 14,
                            color: colores.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _listView
                          ? _buildList(controller, colores)
                          : _buildMap(controller, colores),
                    ),
                  ],
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
                            pub.title,
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

  Widget _buildList(BuildingListController controller, ColorScheme colores) {
    if (controller.buildings.isEmpty && controller.isLoading) {
      return Center(child: CircularProgressIndicator(color: colores.primary));
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.buildings.length + (controller.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.buildings.length) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: CircularProgressIndicator(color: colores.primary),
            ),
          );
        }
        final edificio = controller.buildings[index];
        return BuildingCard(
          building: edificio,
          location: controller.location,
          onTap: () => _navegarADetalle(edificio, controller),
        );
      },
    );
  }

  Widget _buildMap(BuildingListController controller, ColorScheme colores) {
    LatLng centro = LatLng(
      controller.location.latitude, 
      controller.location.longitude
    );
    
    if (centro.latitude == 0 && centro.longitude == 0) {
      centro = controller.buildings.isNotEmpty &&
               controller.buildings.first.latitude != 0
          ? LatLng(
              controller.buildings.first.latitude,
              controller.buildings.first.longitude,
            )
          : const LatLng(41.3879, 2.16992);
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: centro,
        zoom: 14.0,
      ),
      onMapCreated: (GoogleMapController googleController) {
        _googleMapController = googleController;
        if (isDarkMode && _mapStyleDark != null) {
          _googleMapController!.setMapStyle(_mapStyleDark);
        } else {
          _googleMapController!.setMapStyle(null);
        }
      },
      markers: {
        if (controller.location.latitude != 0)
          Marker(
            markerId: const MarkerId('yo'),
            position: LatLng(controller.location.latitude, controller.location.longitude),
            icon: _iconoYo,
            infoWindow: InfoWindow(title: context.loc.me),
          ),
        ...controller.buildings
            .where((e) => e.latitude != 0 && e.longitude != 0)
            .map((edificio) {
          return Marker(
            markerId: MarkerId(edificio.hashCode.toString()), 
            position: LatLng(edificio.latitude, edificio.longitude),
            icon: _iconoEdificio,
            onTap: () => _navegarADetalle(edificio, controller),
          );
        }),
      },
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