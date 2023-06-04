import 'package:flutter/material.dart';

Color getColorFromBinType(String binType) {
  switch (binType) {
    case 'Metal':
      return Color.fromARGB(255, 69, 70, 42);
    case 'Garbage':
      return Color.fromARGB(255, 29, 51, 84);
    case 'Plastic':
      return Color.fromARGB(255, 164, 190, 243);
    case 'Paper':
      return Color.fromARGB(200, 240, 206, 160);
    default:
      return Color.fromARGB(185, 0, 0, 0);
  }
}
