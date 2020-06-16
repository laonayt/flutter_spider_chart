library spider_chart;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin;

class SpiderChart extends StatelessWidget {
  final List<List<double>> features;
  final List<Color> featureColors;
  final List<int> levels;
  final double maxValue;
  final List<String> labels;
  final decimalPrecision;
  final Size size;
  final double fallbackHeight;
  final double fallbackWidth;

  SpiderChart({
    Key key,
    @required this.features,
    @required this.featureColors,
    @required this.levels,
    @required this.maxValue,
    this.labels,
    this.size = Size.infinite,
    this.decimalPrecision = 0,
    this.fallbackHeight = 200,
    this.fallbackWidth = 200,
  });

  @override
  Widget build(BuildContext context) {
    return LimitedBox(
      maxWidth: fallbackWidth,
      maxHeight: fallbackHeight,
      child: CustomPaint(
        size: size,
        painter: SpiderChartPainter(
            features, maxValue, featureColors, levels, labels, decimalPrecision),
      ),
    );
  }
}

class SpiderChartPainter extends CustomPainter {
  final List<List<double>> features;
  final List<Color> featureColors;
  final List<int> levels;
  final double maxNumber;
  final List<String> labels;
  final decimalPrecision;

  final Paint spokes = Paint()..color = Colors.grey;

  SpiderChartPainter(this.features, this.maxNumber, this.featureColors, this.levels, this.labels,
      this.decimalPrecision);

  @override
  void paint(Canvas canvas, Size size) {

    levels.forEach((level){
      paintOutLine(canvas, size, level);
    });

    for(int i = 0; i < features.length; i++){
      paintOneLine(canvas, size, i);
    }
//    paintText(canvas, center, dataPoints, data);
  }

  void paintOutLine(Canvas canvas, Size size, int level) {
    var count = features[0].length;
    Offset center = size.center(Offset.zero);
    double angle = (2 * pi) / count;

    var outerPoints = List<Offset>();
    for (var i = 0; i < count; i++) {
      var x = center.dy * cos(angle * i - pi / 2)*level/maxNumber;
      var y = center.dy * sin(angle * i - pi / 2)*level/maxNumber;
      outerPoints.add(Offset(x, y) + center);
    }

    if(level == maxNumber){
      paintLabels(canvas, center, outerPoints, this.labels);
    } else {
//      paintNums(canvas, center, outerPoints, level);
    }

    paintGraphOutline(canvas, center, outerPoints);
  }

  void paintOneLine(Canvas canvas, Size size,int index) {
    var data = features[index];
    Paint fill = Paint()
      ..color = featureColors[index].withOpacity(0.4)
      ..style = PaintingStyle.fill;

    Offset center = size.center(Offset.zero);
    double angle = (2 * pi) / data.length;
    var dataPoints = List<Offset>();
    for (var i = 0; i < data.length; i++) {
      var scaledRadius = (data[i] / maxNumber) * center.dy;
      var x = scaledRadius * cos(angle * i - pi / 2);
      var y = scaledRadius * sin(angle * i - pi / 2);

      dataPoints.add(Offset(x, y) + center);
    }

    Path path = Path()..addPolygon(dataPoints, true);
    canvas.drawPath(path, fill,);

    //point
//    for (var i = 0; i < dataPoints.length; i++) {
//      canvas.drawCircle(dataPoints[i], 4.0, Paint()..color = featureColors[i]);
//    }
  }

  void paintText(
      Canvas canvas, Offset center, List<Offset> points, List<double> data) {
    var textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (var i = 0; i < points.length; i++) {
      String s = data[i].toStringAsFixed(decimalPrecision);
      textPainter.text =
          TextSpan(text: s, style: TextStyle(color: Colors.black));
      textPainter.layout();
      if (points[i].dx < center.dx) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width + 5.0), 0));
      } else if (points[i].dx > center.dx) {
        textPainter.paint(canvas, points[i].translate(5.0, 0));
      } else if (points[i].dy < center.dy) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), -20));
      } else {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), 4));
      }
    }
  }

  void paintGraphOutline(Canvas canvas, Offset center, List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      canvas.drawLine(center, points[i], spokes);
    }

    //TODO: this could cause a rendering issue later if the rendering order is ever changed
    //        using the spread operator in 'drawPoints' would fix this, but would require a
    //        dart version bump.
    points.add(points[0]);

    canvas.drawPoints(PointMode.polygon, points, spokes);
    canvas.drawCircle(center, 2, spokes);
  }

  void paintLabels(
      Canvas canvas, Offset center, List<Offset> points, List<String> labels) {
    var textPainter = TextPainter(textDirection: TextDirection.ltr);
    var textStyle =
    TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold);

    for (var i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(text: labels[i], style: textStyle);
      textPainter.layout();
      if (points[i].dx < center.dx) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width + 5.0), -15));
      } else if (points[i].dx > center.dx) {
        textPainter.paint(canvas, points[i].translate(5.0, -15));
      } else if (points[i].dy < center.dy) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), -35));
      } else {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), 20));
      }
    }
  }

  void paintNums(
      Canvas canvas, Offset center, List<Offset> points, num) {
    var textPainter = TextPainter(textDirection: TextDirection.rtl);
    var textStyle = TextStyle(color: Colors.grey.shade600,fontSize: 11);

    for (var i = 0; i < points.length; i++) {
      textPainter.text = TextSpan(text: num.toString(), style: textStyle);
      textPainter.layout();
      if (points[i].dx < center.dx) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width + 5.0), -8));
      } else if (points[i].dx > center.dx) {
        textPainter.paint(canvas, points[i].translate(5.0, -8));
      } else if (points[i].dy < center.dy) {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), -5));
      } else {
        textPainter.paint(
            canvas, points[i].translate(-(textPainter.size.width / 2), -5));
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
