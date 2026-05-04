import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../entity/publication_entity.dart';
import '../utils/lang_extensions.dart';
import '../widgets/info_chip.dart';
import '../widgets/section_header.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../controller/building_list_controller.dart';
import '../screens/bottom_bar.dart';

class PublicationDetailScreen extends StatelessWidget {
  final Publication publication;

  const PublicationDetailScreen({super.key, required this.publication});

  @override
  Widget build(BuildContext context) {
    final langCode = context
        .watch<LanguageProvider>()
        .currentLocale
        .languageCode;
    final localTitle = publication.getLocalizedTitle(langCode);
    final localDesc = publication.getLocalizedDescription(langCode);

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;
    final colores = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colores.surface,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.read<BuildingListController>().applyFilter(publication.idPublication);
          Navigator.popUntil(context, (route) => route.isFirst);
          bottomBarKey.currentState?.changeTab(0);
        },
        icon: const Icon(Icons.map_rounded),
        label: Text(context.loc.viewInMap),
        backgroundColor: colores.primary,
        foregroundColor: colores.onPrimary,
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            pinned: true,
            backgroundColor: isHighContrast ? colores.surface : colores.primary,
            elevation: isHighContrast ? 0 : 2,
            iconTheme: IconThemeData(
              color: isHighContrast
                  ? colores.onSurface
                  : Theme.of(context).appBarTheme.foregroundColor,
            ),
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colores.surface.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                border: isHighContrast
                    ? Border.all(color: colores.onSurface, width: 2)
                    : null,
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: colores.onSurface),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding:
                  const EdgeInsets.only(left: 20, bottom: 16, right: 20),
              title: Text(
                localTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isHighContrast
                      ? colores.onSurface
                      : Theme.of(context).appBarTheme.foregroundColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: isHighContrast
                      ? []
                      : [
                          const Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                ),
              ),
              background: Container(
                color: isHighContrast ? colores.surface : colores.primary,
                child: Stack(
                  children: [
                    Positioned(
                      right: -30,
                      bottom: -20,
                      child: Icon(
                        Icons.menu_book,
                        size: 150,
                        color: isHighContrast
                            ? colores.onSurface.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    if (isHighContrast)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Divider(
                          color: colores.onSurface,
                          height: 1,
                          thickness: 2,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chips de temes
                  if (publication.themes.isNotEmpty &&
                      publication.themes != '{}' &&
                      publication.themes != '[]') ...[
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
                              color: colores.primary,
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 32),
                  ],

                  Divider(
                    color: isHighContrast
                        ? colores.onSurface
                        : colores.outline.withValues(alpha: 0.2),
                    thickness: isHighContrast ? 2 : 1,
                  ),
                  const SizedBox(height: 24),

                  // Descripció
                  SectionHeader(title: context.loc.description),
                  const SizedBox(height: 16),

                  (localDesc.isNotEmpty)
                      ? Text(
                          localDesc,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 16,
                            color: colores.onSurface,
                            height: 1.6,
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colores.outline.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 40,
                                color: colores.onSurfaceVariant
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                context.loc.noDescription,
                                style: TextStyle(
                                  color: colores.onSurface,
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
          ),
        ],
      ),
    );
  }
}