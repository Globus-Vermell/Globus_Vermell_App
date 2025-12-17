import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/buildings.dart'; // Tu modelo

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final _supabase = Supabase.instance.client;

  // 1. VARIABLES PARA LA PAGINACIÓN
  final ScrollController _scrollController = ScrollController();
  final List<Buildings> _edificios = []; // Lista donde acumulamos los datos
  bool _cargando = false; // Para saber si estamos bajando datos
  bool _todoCargado = false; // Para saber si ya llegamos al final de la tabla
  final int _cantidadPorPagina = 10; // Traemos de 10 en 10

  @override
  void initState() {
    super.initState();
    _cargarMasEdificios(); // Carga inicial

    // 2. ESCUCHAMOS EL SCROLL
    _scrollController.addListener(() {
      // Si llegamos al fondo (menos 200px)...
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        // ...y no estamos ocupados cargando ni hemos terminado...
        if (!_cargando && !_todoCargado) {
          _cargarMasEdificios();
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpieza al salir
    super.dispose();
  }

  // 3. FUNCIÓN PARA PEDIR DATOS POR TROCITOS
  Future<void> _cargarMasEdificios() async {
    if (_cargando) return; // Si ya está cargando, no hacemos nada
    setState(() => _cargando = true);

    try {
      final inicio = _edificios.length;
      final fin = inicio + _cantidadPorPagina - 1;

      // Pedimos el rango específico a Supabase
      final response = await _supabase
          .from('edificaciones')
          .select()
          .range(inicio, fin)
          .order('id'); // Importante ordenar siempre igual

      // Convertimos a tu modelo Buildings
      final nuevosEdificios = (response as List)
          .map((mapa) => Buildings.fromMap(mapa))
          .toList();

      setState(() {
        _edificios.addAll(nuevosEdificios);
        // Si llegaron menos de los que pedimos, es que se acabó la lista
        if (nuevosEdificios.length < _cantidadPorPagina) {
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
        title: const Text("Mis Edificios 🏗️"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // 4. LISTA INTELIGENTE
      body: _edificios.isEmpty && _cargando
          ? const Center(child: CircularProgressIndicator()) // Loading inicial
          : ListView.builder(
              controller: _scrollController, // Conectamos el "ojo" del scroll
              // Sumamos 1 si aún hay más datos (para el spinner de abajo)
              itemCount: _edificios.length + (_todoCargado ? 0 : 1),
              itemBuilder: (context, index) {
                // Si es el último ítem y aún falta data, mostramos spinner
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
                      edificio.name, // Usando tu modelo
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(edificio.location), // Usando tu modelo
                  ),
                );
              },
            ),
    );
  }
}
