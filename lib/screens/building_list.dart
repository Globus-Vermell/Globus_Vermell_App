import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/buildings.dart'; // Importamos nuestro modelo

class ListaEdificacionesScreen extends StatefulWidget {
  const ListaEdificacionesScreen({super.key});

  @override
  State<ListaEdificacionesScreen> createState() =>
      _ListaEdificacionesScreenState();
}

class _ListaEdificacionesScreenState extends State<ListaEdificacionesScreen> {
  final _supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Edificios 🏗️"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        // ⚠️ CAMBIAR 'edificaciones' POR EL NOMBRE REAL DE TU TABLA
        stream: _supabase
            .from('edificaciones')
            .stream(primaryKey: ['id'])
            .order('id'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final listaMapas = snapshot.data!;

          if (listaMapas.isEmpty) {
            return const Center(child: Text("¡No hay edificios aún! 🏘️"));
          }

          return ListView.builder(
            itemCount: listaMapas.length,
            itemBuilder: (context, index) {
              // Convertimos el mapa feo de Supabase en nuestro objeto bonito
              final edificio = Buildings.fromMap(listaMapas[index]);

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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
