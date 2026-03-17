import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import '../providers/language_provider.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;

  const TranslatedText({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final languageCode = context
        .watch<LanguageProvider>()
        .currentLocale
        .languageCode;

    final translator = GoogleTranslator();

    if (text.isEmpty)
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );

    return FutureBuilder<Translation>(
      // Le decimos: "Traduce este texto al idioma de la app (languageCode)"
      future: translator.translate(text, to: languageCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mientras piensa, mostramos el texto original un poco transparente
          return Text(
            text,
            style: style?.copyWith(color: style?.color?.withValues(alpha: 0.5)),
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
        } else if (snapshot.hasData) {
          return Text(
            snapshot.data!.text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
        } else {
          // Si falla el internet, mostramos el original para que no se rompa nada
          return Text(
            text,
            style: style,
            maxLines: maxLines,
            overflow: overflow,
            textAlign: textAlign,
          );
        }
      },
    );
  }
}
