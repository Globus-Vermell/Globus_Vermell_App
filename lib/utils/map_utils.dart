import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> crearIconoDesdeFlutter(
  IconData icono,
  Color color,
  double pixelRatio,
) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
  textPainter.text = TextSpan(
    text: String.fromCharCode(icono.codePoint),
    style: TextStyle(
      fontSize: 120.0,
      fontFamily: icono.fontFamily,
      package: icono.fontPackage,
      color: color,
    ),
  );
  textPainter.layout();
  textPainter.paint(canvas, const Offset(0.0, 0.0));

  final ui.Image image = await pictureRecorder.endRecording().toImage(
    textPainter.width.toInt(),
    textPainter.height.toInt(),
  );
  final ByteData? byteData = await image.toByteData(
    format: ui.ImageByteFormat.png,
  );
  return BitmapDescriptor.bytes(
    byteData!.buffer.asUint8List(),
    imagePixelRatio: pixelRatio,
  );
}
