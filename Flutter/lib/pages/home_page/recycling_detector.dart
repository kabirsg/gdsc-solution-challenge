import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;

class RecyclingDetector {
  Interpreter? _interpreter;
  List<String>? _classLabels;
  late int _imageSize;

  RecyclingDetector() {
    loadModel();
    _classLabels = loadLabels('labels.txt');
    _imageSize = 224; // Modify this if your model expects a different image size
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset('model_unquant.tflite');
  }

  List<String> loadLabels(String path) {
    final fileData = rootBundle.loadString(path);
    return fileData.toString().trim().split('\n');
  }

  Uint8List preprocessImage(CameraImage image) {
    final input = img.Image(image.width, image.height);
    for (int x = 0; x < image.width; x++) {
      for (int y = 0; y < image.height; y++) {
        final pixel = image.planes[0].bytes[y * image.width + x];
        input.setPixelRgba(x, y, pixel, pixel, pixel, 255);
      }
    }

    final resized = img.copyResize(input, width: _imageSize, height: _imageSize);
    final byteData = resized.getBytes();
    return byteData.buffer.asUint8List();
  }

  Future<String> predict(CameraImage image) async {
    final input = preprocessImage(image);
    final inputBuffer = input.buffer.asUint8List();
    final outputBuffer = Float32List(_classLabels!.length).buffer;

    _interpreter!.run(inputBuffer, outputBuffer);

    final output = Float32List.view(outputBuffer);
    final maxIndex = output.indexOf(output.reduce((a, b) => a > b ? a : b));
    return _classLabels![maxIndex];
  }

  void dispose() {
    _interpreter?.close();
  }
}
