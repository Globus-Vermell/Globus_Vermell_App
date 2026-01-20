import 'package:flutter/material.dart';
import '../models/buildings.dart';
import '../services/building_services.dart';
import 'building_detail.dart';

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final BuildingService _buildingService = BuildingService();
  final ScrollController _scrollController = ScrollController();
  final List<Buildings> _edificios = [];
  bool _cargando = false;
  bool _todoCargado = false;
  int _paginaActual = 1;
  bool _vistaLista = true;

  @override
  void initState() {
    super.initState();

    if (_buildingService.primeraPaginaCargada) {
      // Si SÍ tiene datos, los copiamos a nuestra lista local
      _edificios.addAll(_buildingService.cacheEdificios);

      // Ajustamos la página para que la próxima carga sea la página 2
      _paginaActual = 2;

      if (_buildingService.cacheEdificios.isEmpty) {
        _todoCargado = true;
      }
    } else {
      // Si NO hay datos (porque el usuario entró súper rápido), cargamos normal
      _cargarMasEdificios();
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_cargando && !_todoCargado) {
          _cargarMasEdificios();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _cargarMasEdificios() async {
    if (_cargando) return;
    setState(() => _cargando = true);

    try {
      final nuevosEdificios = await _buildingService.getBuildings(
        page: _paginaActual,
      );

      setState(() {
        _edificios.addAll(nuevosEdificios);
        _paginaActual++;
        if (nuevosEdificios.isEmpty) {
          _todoCargado = true;
        }
      });
    } catch (e) {
      debugPrint("Error cargando: $e");
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
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
      body: Column(
        children: [
          // Botones Mapa / Llista
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

          // Contador de edificaciones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_edificios.length} monuments ordenats per distància',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Lista de edificios
          Expanded(
            child: _edificios.isEmpty && _cargando
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _edificios.length + (_todoCargado ? 0 : 1),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BuildingDetailScreen(building: edificio),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget para los botones Mapa/Llista
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
      color: isSelected ? Color(0xFFE41E26) : Colors.white,
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

// Widget para cada tarjeta de edificio
class _BuildingCard extends StatelessWidget {
  final Buildings edificio;
  final VoidCallback onTap;

  const _BuildingCard({required this.edificio, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
              // Imagen placeholder
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
                          edificio
                              .images!
                              .first, // Usamos la primera imagen (index 0)
                          fit: BoxFit.cover,
                          // Si la imagen falla al cargar, mostramos el icono roto
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
                        // Si la lista está vacía o es null
                        Icons.image_outlined,
                        color: Colors.grey[400],
                        size: 40,
                      ),
              ),
              const SizedBox(width: 12),

              // Contenido
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      edificio.name,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Descripción
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

                    // Categoría y distancia
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Arquitectura Modernista',
                            style: TextStyle(fontSize: 13, color: Colors.blue),
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
                          '0.6 km',
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
