import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Create the icon widget
  final widget = SonaAppIcon();
  
  // Generate icon at 1024x1024 resolution
  final image = await _createImageFromWidget(widget, const Size(1024, 1024));
  
  // Save the icon
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  if (bytes != null) {
    final file = File('assets/icons/app_icon.png');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    print('App icon generated at: ${file.path}');
  }
}

Future<ui.Image> _createImageFromWidget(Widget widget, Size size) async {
  final repaintBoundary = RenderRepaintBoundary();
  final renderView = RenderView(
    window: WidgetsBinding.instance.window,
    child: RenderPositionedBox(
      alignment: Alignment.center,
      child: repaintBoundary,
    ),
    configuration: ViewConfiguration(
      size: size,
      devicePixelRatio: 1.0,
    ),
  );

  final pipelineOwner = PipelineOwner()..rootNode = renderView;
  renderView.prepareInitialFrame();

  final buildContext = _FakeBuildContext();
  final child = MaterialApp(
    home: Material(
      color: Colors.transparent,
      child: widget,
    ),
  );

  final renderObject = child.createRenderObject(buildContext);
  repaintBoundary.child = renderObject;

  pipelineOwner
    ..flushLayout()
    ..flushCompositingBits()
    ..flushPaint();

  final image = await repaintBoundary.toImage(
    pixelRatio: 1.0,
  );
  
  return image;
}

class _FakeBuildContext extends BuildContext {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class SonaAppIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1024,
      height: 1024,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(256), // 25% of 1024
      ),
      child: Padding(
        padding: const EdgeInsets.all(128), // Add padding for better visibility
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(192),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFB3C6),
                Color(0xFFFF6B9D),
                Color(0xFFE766AC),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B9D).withOpacity(0.4),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 512,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
              ),
            ),
          ),
        ),
      ),
    );
  }
}