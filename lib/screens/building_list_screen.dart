import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/building_model.dart';
import '../controllers/building_list_controller.dart';
import 'building_detail_screen.dart';
import 'package:geolocator/geolocator.dart';

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final BuildingListController _controller = BuildingListController();
  final ScrollController _scrollController = ScrollController();
  final List<Buildings> _edificios = [];

  bool _cargando = false;
  bool _vistaLista = true;

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

  Future<void> _cargarDatosIniciales() async {
    setState(() => _cargando = true);
    final iniciales = await _controller.getInitialData();

    if (mounted) {
      setState(() {
        _edificios.addAll(iniciales);
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

    if (mounted) {
      setState(() {
        _edificios.clear();
        _edificios.addAll(edificiosCercanos);
        _cargando = false;
      });

      if (edificiosCercanos.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Localització actualitzada!')),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Globus Vermell',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Barcelona',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
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
                    text: 'Mapa',
                    isSelected: !_vistaLista,
                    onTap: () => setState(() => _vistaLista = false),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ToggleButton(
                    icon: Icons.format_list_bulleted,
                    text: 'Llista',
                    isSelected: _vistaLista,
                    onTap: () => setState(() => _vistaLista = true),
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
                '${_edificios.length} edificacions ordenades per distància',
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuildingDetailScreen(
                  building: edificio,
                  miUbicacion: _controller.miUbicacion,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _construirMapa() {
    final centro = _controller.miUbicacion ?? const LatLng(41.3851, 2.1734);

    return FlutterMap(
      options: MapOptions(initialCenter: centro, initialZoom: 14.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.globus_vermell',
        ),
        MarkerLayer(
          markers: [
            if (_controller.miUbicacion != null)
              Marker(
                point: _controller.miUbicacion!,
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuildingDetailScreen(
                          building: edificio,
                          miUbicacion: _controller.miUbicacion,
                        ),
                      ),
                    );
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
      shadowColor: Colors.black.withOpacity(0.1),
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
    String distancia = '0.6 Km'; // Valor por defecto

    if (miUbicacion != null && edificio.latitude != 0) {
      double distanciaMetros = Geolocator.distanceBetween(
        miUbicacion!.latitude,
        miUbicacion!.longitude,
        edificio.latitude,
        edificio.longitude,
      );
      double distanciaKm = distanciaMetros / 1000;
      distancia = "${distanciaKm.toStringAsFixed(1)} Km";
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
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
                child: (edificio.images != null && edificio.images!.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          edificio.images!.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.broken_image,
                              color: Colors.grey[400],
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
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
                                : "Sense publicació",
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
