import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../controllers/building_list_controller.dart';
import '../widgets/building_card.dart';
import '../widgets/toggle_button.dart';
import 'building_detail_screen.dart';
import 'publication_detail_screen.dart';

class BuildingsListScreen extends StatefulWidget {
  const BuildingsListScreen({super.key});

  @override
  State<BuildingsListScreen> createState() => _BuildingsListScreenState();
}

class _BuildingsListScreenState extends State<BuildingsListScreen> {
  final ScrollController _scrollController = ScrollController();
  final MapController _mapController = MapController();

  bool _vistaLista = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosIniciales();
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final controller = context.read<BuildingListController>();
        if (!controller.isLoading && controller.hasMoreData && _vistaLista) {
          _cargarMasEdificios();
        }
      }
    });
  }

  Future<void> _cargarDatosIniciales() async {
    try {
      await context.read<BuildingListController>().cargarDatosIniciales();
    } catch (e) {
      if (mounted) _mostrarErrorRed();
    }
  }

  Future<void> _filtrarPorPublicacion(int idPublicacion) async {
    try {
      await context.read<BuildingListController>().aplicarFiltro(idPublicacion);
    } catch (e) {
      if (mounted) _mostrarErrorRed();
    }
  }

  Future<void> _cargarMasEdificios() async {
    try {
      await context.read<BuildingListController>().fetchNextPage();
    } catch (e) {
      if (mounted) _mostrarErrorRed();
    }
  }

  Future<void> _usarGPS() async {
    final controller = context.read<BuildingListController>();
    try {
      await controller.activarGPS();
      if (!mounted) return;

      if (!_vistaLista && controller.location.latitude != 0) {
        _mapController.move(controller.location, 17.0);
      }

      if (controller.buildings.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.loc.locationUpdated),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) _mostrarErrorRed();
    }
  }

  void _mostrarErrorRed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.loc.connectionError),
        backgroundColor: const Color(0xFFE41E26),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    context.read<BuildingListController>().detenerSeguimiento();
    _scrollController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Globus Vermell',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<BuildingListController>(
        builder: (context, controller, child) {
          return FloatingActionButton(
            onPressed: controller.isLoading ? null : _usarGPS,
            backgroundColor: const Color(0xFFE41E26),
            child: controller.isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.my_location, color: Colors.white),
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
                    isSelected: !_vistaLista,
                    onTap: () => setState(() => _vistaLista = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ToggleButton(
                    icon: Icons.format_list_bulleted,
                    text: context.loc.list,
                    isSelected: _vistaLista,
                    onTap: () => setState(() => _vistaLista = true),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildFilter(
                              texto: context.loc.all,
                              isSelected: controller.publicationFilter == 0,
                              onTap: () => _filtrarPorPublicacion(0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: _buildFilter(
                              texto: context.loc.publications,
                              icono: Icons.keyboard_arrow_down_rounded,
                              isSelected: controller.publicationFilter != 0,
                              onTap: () => _showPublicationsMenu(controller),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: _buildFilter(
                              texto: context.loc.nearby,
                              icono: Icons.location_on_outlined,
                              isSelected: false,
                              onTap: _usarGPS,
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
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _vistaLista
                          ? _buildList(controller)
                          : _buildMap(controller),
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

  void _showPublicationsMenu(BuildingListController controller) {
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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
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
                            style: const TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            _filtrarPorPublicacion(pub.idPublication);
                          },
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              color: Color(0xFFE41E26),
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
                          backgroundColor: const Color(0xFFE41E26),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
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

  Widget _buildList(BuildingListController controller) {
    if (controller.buildings.isEmpty && controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.buildings.length + (controller.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.buildings.length) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final edificio = controller.buildings[index];

        return BuildingCard(
          building: edificio,
          location: controller.location,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildingDetailScreen(
                  building: edificio,
                  miUbicacion: controller.location,
                ),
              ),
            );

            if (result == 'show_map') {
              setState(() => _vistaLista = false);
              Future.delayed(const Duration(milliseconds: 300), () {
                if (edificio.latitude != 0 && edificio.longitude != 0) {
                  _mapController.move(
                    LatLng(edificio.latitude, edificio.longitude),
                    17.0,
                  );
                }
              });
            }
          },
        );
      },
    );
  }

  Widget _buildMap(BuildingListController controller) {
    LatLng centro = controller.location;
    if (centro.latitude == 0 && centro.longitude == 0) {
      centro =
          controller.buildings.isNotEmpty &&
              controller.buildings.first.latitude != 0
          ? LatLng(
              controller.buildings.first.latitude,
              controller.buildings.first.longitude,
            )
          : const LatLng(41.3879, 2.16992);
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: centro, initialZoom: 14.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.globus_vermell',
        ),
        MarkerLayer(
          markers: [
            if (controller.location.latitude != 0)
              Marker(
                point: controller.location,
                width: 60,
                height: 60,
                child: Column(
                  children: [
                    const Icon(
                      Icons.person_pin_circle,
                      color: Colors.blue,
                      size: 40,
                    ),
                    Text(
                      context.loc.me,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ...controller.buildings.map((edificio) {
              if (edificio.latitude == 0 && edificio.longitude == 0) {
                return const Marker(point: LatLng(0, 0), child: SizedBox());
              }

              return Marker(
                point: LatLng(edificio.latitude, edificio.longitude),
                width: 50,
                height: 50,
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuildingDetailScreen(
                          building: edificio,
                          miUbicacion: controller.location,
                        ),
                      ),
                    );

                    if (result == 'show_map') {
                      setState(() => _vistaLista = false);
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _mapController.move(
                          LatLng(edificio.latitude, edificio.longitude),
                          17.0,
                        );
                      });
                    }
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFFE41E26),
                    size: 40,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildFilter({
    required String texto,
    IconData? icono,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.primaries[0] : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected
                ? Colors.primaries[0]
                : Colors.grey.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icono != null) ...[
              Icon(
                icono,
                size: 16,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              texto,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
