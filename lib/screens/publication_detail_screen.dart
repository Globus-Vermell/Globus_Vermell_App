import 'package:flutter/material.dart';
import '../models/publication_model.dart';
import '../utils/lang_extensions.dart';
import '../widgets/info_chip.dart';
import '../widgets/section_header.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Publication publication;

  const PublicationDetailScreen({super.key, required this.publication});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                publication.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_outline_rounded,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                ],
              ),
              const SizedBox(height: 24),
              Divider(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.2),
                thickness: 1,
              ),
              const SizedBox(height: 32),

              // Contenedor para volver a alinear el resto de la información a la izquierda
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. TEMAS
                    if (publication.themes.isNotEmpty) ...[
                      SectionHeader(title: context.loc.themesTitle),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: publication.themes
                            .split(',')
                            .map(
                              (tema) => InfoChip(
                                icon: Icons.label_important_rounded,
                                label: tema.trim(),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 40),
                    ],

                    // 3. DESCRIPCIÓN
                    SectionHeader(title: context.loc.description),
                    const SizedBox(height: 16),

                    (publication.description.isNotEmpty)
                        ? Text(
                            publication.description,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                              height: 1.6,
                            ),
                          )
                        : Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.outline.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.description_outlined,
                                  size: 40,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant
                                      .withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  context.loc.noDescription,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
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
}
