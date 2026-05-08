import 'package:flutter/material.dart';
import 'package:globus_vermell_app/utils/lang_extensions.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/ia_service.dart';
import '../providers/theme_provider.dart';

class Mensaje {
  final String texto;
  final bool esMio;
  Mensaje(this.texto, this.esMio);
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Mensaje> _mensajes = [];
  bool _cargando = false;

  // ── Speech to text ──────────────────────────────────────────────────────────
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _escuchando = false;
  bool _speechDisponible = false;

  @override
  void initState() {
    super.initState();
    _inicializarSpeech();
  }

  Future<void> _inicializarSpeech() async {
    final disponible = await _speech.initialize(
      onError: (error) => setState(() => _escuchando = false),
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _escuchando = false);
        }
      },
    );
    setState(() => _speechDisponible = disponible);
  }

  void _toggleEscuchar() async {
    if (_escuchando) {
      await _speech.stop();
      setState(() => _escuchando = false);
    } else {
      setState(() => _escuchando = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        },
        localeId: 'ca_ES', // catalán; cambia a 'es_ES' si prefieres castellano
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
      );
    }
  }

  void _enviar() async {
    if (_controller.text.trim().isEmpty) return;
    final texto = _controller.text.trim();

    if (_escuchando) {
      await _speech.stop();
      setState(() => _escuchando = false);
    }

    setState(() {
      _mensajes.insert(0, Mensaje(texto, true));
      _cargando = true;
    });
    _controller.clear();

    final resultado = await IaService.enviarMensaje(texto);
    final respuesta = resultado['respuesta'] as String? ?? '...';

    setState(() {
      _mensajes.insert(0, Mensaje(respuesta, false));
      _cargando = false;
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isHighContrast = themeProvider.isHighContrast;
    final isPureHighContrast = isHighContrast && !themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: colores.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Globus Vermell IA",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPureHighContrast
                    ? Colors.black
                    : Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            Text(
              context.loc.virtualassistant,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: (isPureHighContrast
                        ? Colors.black
                        : Theme.of(context).appBarTheme.foregroundColor)
                    ?.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Lista de mensajes ────────────────────────────────────────────────
          Expanded(
            child: _mensajes.isEmpty
                ? _buildEmptyState(context, colores)
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    itemCount: _mensajes.length,
                    itemBuilder: (context, index) {
                      final msg = _mensajes[index];
                      return _buildBubble(
                          context, msg, colores, isHighContrast);
                    },
                  ),
          ),

          // ── Indicador de escritura ───────────────────────────────────────────
          if (_cargando)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isHighContrast
                          ? colores.surface
                          : colores.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: isHighContrast
                          ? Border.all(color: colores.onSurface, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isHighContrast
                                ? colores.onSurface
                                : colores.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          context.loc.writting,
                          style: TextStyle(
                            fontSize: 13,
                            color: isHighContrast
                                ? colores.onSurface
                                : colores.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // ── Indicador de escucha ─────────────────────────────────────────────
          if (_escuchando)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isHighContrast
                          ? colores.surface
                          : colores.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: isHighContrast
                          ? Border.all(color: colores.onSurface, width: 1.5)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.mic_rounded,
                          size: 14,
                          color: isHighContrast
                              ? colores.onSurface
                              : colores.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Escoltant...",
                          style: TextStyle(
                            fontSize: 13,
                            color: isHighContrast
                                ? colores.onSurface
                                : colores.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          Divider(
            height: 1,
            thickness: isHighContrast ? 2 : 1,
            color: isHighContrast
                ? colores.onSurface
                : colores.outline.withValues(alpha: 0.15),
          ),

          // ── Input ────────────────────────────────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  // Botón mic
                  if (_speechDisponible) ...[
                    GestureDetector(
                      onTap: _toggleEscuchar,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: _escuchando
                              ? (isHighContrast
                                  ? colores.onSurface
                                  : colores.primary)
                              : (isHighContrast
                                  ? colores.surface
                                  : colores.primary.withValues(alpha: 0.1)),
                          shape: BoxShape.circle,
                          border: isHighContrast
                              ? Border.all(color: colores.onSurface, width: 2)
                              : null,
                        ),
                        child: Icon(
                          _escuchando
                              ? Icons.mic_rounded
                              : Icons.mic_none_rounded,
                          size: 22,
                          color: _escuchando
                              ? (isHighContrast
                                  ? colores.surface
                                  : colores.onPrimary)
                              : (isHighContrast
                                  ? colores.onSurface
                                  : colores.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Campo de texto
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: isHighContrast
                            ? colores.surface
                            : colores.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isHighContrast
                              ? colores.onSurface
                              : colores.outline.withValues(alpha: 0.25),
                          width: isHighContrast ? 2 : 1,
                        ),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _enviar(),
                        style: TextStyle(
                          fontSize: 15,
                          color: colores.onSurface,
                        ),
                        decoration: InputDecoration(
                          hintText: context.loc.question,
                          hintStyle: TextStyle(
                            color: colores.onSurfaceVariant
                                .withValues(alpha: 0.6),
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Botón enviar
                  GestureDetector(
                    onTap: _enviar,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: isHighContrast
                            ? colores.surface
                            : colores.primary,
                        shape: BoxShape.circle,
                        border: isHighContrast
                            ? Border.all(color: colores.onSurface, width: 2)
                            : null,
                      ),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        color: isHighContrast
                            ? colores.onSurface
                            : colores.onPrimary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ColorScheme colores) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 52,
            color: colores.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            context.loc.help,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: colores.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.loc.askForHelp,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colores.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBubble(
    BuildContext context,
    Mensaje msg,
    ColorScheme colores,
    bool isHighContrast,
  ) {
    final isMe = msg.esMio;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isHighContrast
                ? colores.surface
                : isMe
                    ? colores.primary
                    : colores.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 18 : 4),
              bottomRight: Radius.circular(isMe ? 4 : 18),
            ),
            border: isHighContrast
                ? Border.all(color: colores.onSurface, width: 1.5)
                : null,
            boxShadow: isHighContrast
                ? null
                : [
                    BoxShadow(
                      color: colores.shadow.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Text(
            msg.texto,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: isHighContrast
                  ? colores.onSurface
                  : isMe
                      ? colores.onPrimary
                      : colores.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}