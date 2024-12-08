import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  double getWidth(double percentage) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * percentage;
  }

  double getHeight(double percentage) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * percentage;
  }
}
