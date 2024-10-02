import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final BorderRadius borderRadius;
  final double rotationAngle;

  WavePainter({this.borderRadius = BorderRadius.zero, this.rotationAngle = 0});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    // Xoay canvas tại trung tâm của nó
    canvas.translate(size.width / 2, size.height / 2); // Đặt điểm xoay tại trung tâm
    canvas.rotate(rotationAngle); // Xoay theo radian
    canvas.translate(-size.width / 2, -size.height / 2); //

    var paint = Paint()
      ..color = Color(0xFF00BFE0).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    var path = Path();

    // Vẽ đường cong sóng
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width * 0.25, size.height * 0.7,
        size.width * 0.5, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.75, size.height * 0.9,
        size.width * 1.0, size.height * 0.8);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    // Tạo clipPath để tôn trọng borderRadius
    var clipPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, size.width, size.height),
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      ));

    // Cắt khu vực vẽ theo borderRadius
    canvas.clipPath(clipPath);

    // Vẽ đường sóng biển
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Vẽ lại khi có thay đổi
  }
}
