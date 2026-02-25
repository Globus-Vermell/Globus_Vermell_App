// ignore_for_file: prefer-single-widget-per-file, avoid-passing-async-when-sync-expected, prefer-extracting-callbacks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../controllers/building_list_controller.dart';
import '../models/publication_model.dart';
import '../utils/get_distancia.dart';
import 'building_detail_screen.dart';
import 'publication_detail_screen.dart';

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final BuildingListController _controller = BuildingListController();
  final ScrollController _scrollController = ScrollController();
  
  final MapController _mapController = MapController();

  final List<Buildings> _edificios = [];
  List<Publication> _publicacionesFiltro = [];

  bool _cargando = false;
  bool _vistaLista = false;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_cargando && _controller.hasMoreData && _vistaLista) {
          _cargarMasEdificios();
        }
      }
    });
  }

  void _mostrarMenuPublicaciones() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Tancar',
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
                )
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5, 
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: _publicacionesFiltro.length,
                  itemBuilder: (context, index) {
                    final pub = _publicacionesFiltro[index];

                    return ListTile(
                      title: Text(
                        pub.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                        tooltip: 'Veure publicació',
                        onPressed: () {
                          Navigator.pop(context); 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PublicationDetailScreen(
                                publication: pub, 
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
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
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
    );
  }

  Future<void> _cargarDatosIniciales() async {
    setState(() => _cargando = true);
    final iniciales = await _controller.getInitialData();
    final publicaciones = await _controller.obtenerPublicacionesParaFiltro();
    if (mounted) {
      setState(() {
        _edificios.addAll(iniciales);
        _publicacionesFiltro = publicaciones;
        _cargando = false;
      });
    }
  }

  Future<void> _filtrarPorPublicacion(int idPublicacion) async {
    setState(() => _cargando = true);

    final filtrados = await _controller.aplicarFiltro(idPublicacion);

    if (mounted) {
      setState(() {
        _edificios.clear();
        _edificios.addAll(filtrados);
        _cargando = false;
      });
    }
  }

  Future<void> _cargarMasEdificios() async {
    setState(() => _cargando = true);
    final nuevos = await _controller.fetchNextPage();

    if (mounted) {
      setState(() {
        _edificios.addAll(nuevos);
        _cargando = false;
      });
    }
  }

  Future<void> _usarGPS() async {
    setState(() => _cargando = true);

    final edificiosCercanos = await _controller.activarGPS();

    if (!mounted) return;

    setState(() {
      _edificios.clear();
      _edificios.addAll(edificiosCercanos);
      _cargando = false;
    });
    if (!_vistaLista && _controller.miUbicacion.latitude != 0) {
      _mapController.move(_controller.miUbicacion, 17.0);
    }
    if (edificiosCercanos.isNotEmpty) {
      final String mensaje = context.loc.locationUpdated;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensaje),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Globus Vermell',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cargando ? null : _usarGPS,
        backgroundColor: const Color(0xFFE41E26),
        child: _cargando
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.my_location, color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: _ToggleButton(
                    icon: Icons.location_on_outlined,
                    text: context.loc.map,
                    isSelected: !_vistaLista,
                    onTap: () => setState(() => _vistaLista = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ToggleButton(
                    icon: Icons.format_list_bulleted,
                    text: context.loc.list,
                    isSelected: _vistaLista,
                    onTap: () => setState(() => _vistaLista = true),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildFiltro(
                    texto: context.loc.all,
                    isSelected: _controller.publicationFiltro == 0,
                    onTap: () => _filtrarPorPublicacion(0),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildFiltro(
                    texto: context.loc.publications,
                    icono: Icons.keyboard_arrow_down_rounded,
                    isSelected: _controller.publicationFiltro != 0,
                    onTap: _mostrarMenuPublicaciones,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: _buildFiltro(
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
                '${_edificios.length} ${context.loc.buildingsByDistance}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _vistaLista ? _construirLista() : _construirMapa()),
        ],
      ),
    );
  }

  Widget _construirLista() {
    if (_edificios.isEmpty && _cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _edificios.length + (_controller.hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _edificios.length) {
          return const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final edificio = _edificios[index];

        return _BuildingCard(
          edificio: edificio,
          miUbicacion: _controller.miUbicacion,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildingDetailScreen(
                  building: edificio,
                  miUbicacion: _controller.miUbicacion,
                ),
              ),
            );

            if (result == 'show_map') {
              setState(() => _vistaLista = false);
              
              // Le damos un poquitito de tiempo al mapa para que cargue en pantalla
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

  Widget _construirMapa() {
    LatLng centro = _controller.miUbicacion;
    if (centro.latitude == 0 && centro.longitude == 0) {
      //El centro del mapa será el edificio más cercano o en su defecto el centro de Barcelona.
      centro = _edificios.isNotEmpty && _edificios.first.latitude != 0
          ? LatLng(_edificios.first.latitude, _edificios.first.longitude)
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
            if (_controller.miUbicacion.latitude != 0)
              Marker(
                point: _controller.miUbicacion,
                width: 60,
                height: 60,
                child: const Column(
                  children: [
                    Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    Text(
                      "Jo",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ..._edificios.map((edificio) {
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
                          miUbicacion: _controller.miUbicacion,
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

  Widget _buildFiltro({
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

class _ToggleButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xFFE41E26) : Colors.white,
      elevation: isSelected ? 0 : 2,
      borderRadius: BorderRadius.circular(8),
      shadowColor: Colors.black.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[700],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildingCard extends StatelessWidget {
  final Buildings edificio;
  final VoidCallback onTap;
  final LatLng? miUbicacion;

  const _BuildingCard({
    required this.edificio,
    required this.onTap,
    required this.miUbicacion,
  });

  @override
  Widget build(BuildContext context) {
    String distancia = getDistancia(miUbicacion, edificio);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: (edificio.images.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl:  edificio.images.first,
                          fit: BoxFit.cover,
                          errorWidget: (context,url, error,) {
                            return Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                            );
                          },
                          placeholder: (context, url) {
                            return const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.image_outlined,
                        color: Colors.grey[400],
                        size: 40,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edificio.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      edificio.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFE41E26),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            (edificio.publications.isNotEmpty)
                                ? edificio.publications.first
                                : context.loc.noPublication,
                            style: TextStyle(
                              fontSize: 13,
                              color: (edificio.publications.isNotEmpty)
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : Colors.grey[700],
                              fontWeight: (edificio.publications.isNotEmpty)
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontStyle: (edificio.publications.isNotEmpty)
                                  ? FontStyle.normal
                                  : FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.navigation,
                          color: Colors.grey[600],
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distancia,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
