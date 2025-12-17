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

  @override
  void initState() {
    super.initState();
    _cargarMasEdificios();

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
      appBar: AppBar(
        title: const Text("Mis Edificios "),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _edificios.isEmpty && _cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _edificios.length + (_todoCargado ? 0 : 1),
              itemBuilder: (context, index) {
                if (index == _edificios.length) {
                  return const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final edificio = _edificios[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.apartment,
                      color: Colors.deepPurple,
                    ),
                    title: Text(
                      edificio.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(edificio.location),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BuildingDetailScreen(building: edificio),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
