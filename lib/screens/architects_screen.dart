import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/architect_list_controller.dart';
import '../providers/theme_provider.dart';
import 'architect_detail_screen.dart';
import '../utils/lang_extensions.dart';

class ArchitectsScreen extends StatelessWidget {
  const ArchitectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isPureHighContrast =
        themeProvider.isHighContrast && !themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.loc.architects,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isPureHighContrast
                ? Colors.black
                : Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<ArchitectListController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if (controller.filteredArchitects.isEmpty) {
            return Center(
              child: Text(
                context.loc.nonArchitects,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              _buildSectionHeader(
                context,
                context.loc.architectList,
                Icons.architecture,
              ),
              const SizedBox(height: 12),
              _buildArchitectList(context, controller),
              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildArchitectList(
    BuildContext context,
    ArchitectListController controller,
  ) {
    final langCode = Localizations.localeOf(context).languageCode;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.filteredArchitects.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final architect = controller.filteredArchitects[index];
        final localNat = architect.getLocalizedNationality(langCode);

        final chips = <String>[];
        if (localNat.isNotEmpty) {
          chips.add(localNat);
        }
        if (architect.birthYear != null) {
          chips.add("${architect.birthYear}");
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .shadow
                    .withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ArchitectDetailScreen(architect: architect),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            architect.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                    if (chips.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        chips.join(' · '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}