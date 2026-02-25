import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
extension LocalizationExtension on BuildContext {
  // Retorna la instancia de traducciones garantizando que no sea nula.
  AppLocalizations get loc => AppLocalizations.of(this)!;
}