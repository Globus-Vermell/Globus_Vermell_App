import 'package:flutter/material.dart';
import '../models/buildings.dart';
import '../controllers/BuildingListController.dart';
import 'BuildingDetail.dart';

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final BuildingListController _controller = BuildingListController();

  final ScrollController _scrollController = ScrollController();
  final List<Buildings> _edificios =
      []; // Solo guardamos la lista para pintarla

  // Variables visuales
  bool _cargando = false;
  bool _vistaLista = true;

  @override
  void initState() {
    super.initState();
    _cargarDatosIniciales();

    // Listener del Scroll para cargar más
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (!_cargando && _controller.hasMoreData) {
          _cargarMasEdificios();
        }
      }
    });
  }

  Future<void> _cargarDatosIniciales() async {
    setState(() => _cargando = true);
    // El controller decide si saca datos de caché o de internet
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
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

          // Contador
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
                    // Si el controller dice que hay más, sumamos 1 para el loading spinner
                    itemCount:
                        _edificios.length + (_controller.hasMoreData ? 1 : 0),
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
              // Contenido
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
                    // Categoría y distancia (Provisional)
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Expanded(
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
