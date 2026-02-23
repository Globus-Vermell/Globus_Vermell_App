import 'package:flutter/material.dart';
import '../models/publication_model.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Publication publication;

  const PublicationDetailScreen({super.key, required this.publication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Centra la cabecera
            children: [
              // 1. CABECERA PRINCIPAL (Título Centrado y Más Grande)
              Text(
                publication.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 34, // Tamaño aumentado
                  fontWeight: FontWeight.w900, // Fuente más gruesa
                  height: 1.2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Edición (Icono centrado)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bookmark_outline_rounded,
                    color: Colors.grey,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  // Nota: En tu código anterior quitaste el texto de la edición. 
                  // Si quieres volver a ponerlo, añádelo aquí dentro de un Text().
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.grey[200], thickness: 1),
              const SizedBox(height: 32),

              // Contenedor para volver a alinear el resto de la información a la izquierda
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. TEMAS
                    if (publication.themes.isNotEmpty) ...[
                      _buildSectionHeader("TEMES"),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: publication.themes
                            .split(',')
                            .map((tema) => _buildInfoChip(
                                  Icons.label_important_rounded,
                                  tema.trim(),
                                  const Color(0xFFE41E26), 
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 40),
                    ],

                    // 3. DESCRIPCIÓN
                    _buildSectionHeader("DESCRIPCIÓ"),
                    const SizedBox(height: 16),

                    (publication.description.isNotEmpty)
                        ? Text(
                            publication.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                              height: 1.6,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 40,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Sense descripció disponible",
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    
                    const SizedBox(height: 100), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFFE41E26),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color.withOpacity(0.8)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}