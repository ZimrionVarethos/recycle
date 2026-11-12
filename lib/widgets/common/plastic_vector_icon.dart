import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../models/plastic_class.dart';

class PlasticVectorIcon extends StatelessWidget {
  final PlasticClass plasticClass;
  final double size;

  const PlasticVectorIcon({
    super.key,
    required this.plasticClass,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _PlasticPainter(plasticClass),
      ),
    );
  }
}

class _PlasticPainter extends CustomPainter {
  final PlasticClass cls;
  _PlasticPainter(this.cls);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 64.0;
    final strokeInk = Paint()
      ..color = AppColors.blackInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    switch (cls) {
      case PlasticClass.pet:
        _drawPet(canvas, s, strokeInk);
        break;
      case PlasticClass.hdpe:
        _drawHdpe(canvas, s, strokeInk);
        break;
      case PlasticClass.pvc:
        _drawPvc(canvas, s, strokeInk);
        break;
      case PlasticClass.ldpe:
        _drawLdpe(canvas, s, strokeInk);
        break;
      case PlasticClass.pp:
        _drawPp(canvas, s, strokeInk);
        break;
      case PlasticClass.ps:
        _drawPs(canvas, s, strokeInk);
        break;
      case PlasticClass.other:
        _drawOther(canvas, s, strokeInk);
        break;
    }
  }

  void _drawPet(Canvas c, double s, Paint stroke) {
    final cap = RRect.fromLTRBR(25 * s, 6 * s, 39 * s, 12 * s, Radius.circular(1.5 * s));
    c.drawRRect(cap, Paint()..color = AppColors.greenMid);
    c.drawRRect(cap, stroke);

    final body = Path()
      ..moveTo(22 * s, 18 * s)
      ..quadraticBezierTo(22 * s, 12 * s, 32 * s, 12 * s)
      ..quadraticBezierTo(42 * s, 12 * s, 42 * s, 18 * s)
      ..lineTo(44 * s, 54 * s)
      ..quadraticBezierTo(44 * s, 58 * s, 39 * s, 58 * s)
      ..lineTo(25 * s, 58 * s)
      ..quadraticBezierTo(20 * s, 58 * s, 20 * s, 54 * s)
      ..close();
    c.drawPath(body, Paint()..color = AppColors.mintPistachio);
    c.drawPath(body, stroke);
    c.drawLine(Offset(22 * s, 28 * s), Offset(42 * s, 28 * s), stroke);
    c.drawLine(Offset(22 * s, 40 * s), Offset(42 * s, 40 * s), stroke);
  }

  void _drawHdpe(Canvas c, double s, Paint stroke) {
    final cap = RRect.fromLTRBR(22 * s, 6 * s, 36 * s, 12 * s, Radius.circular(1.5 * s));
    c.drawRRect(cap, Paint()..color = AppColors.blackInk);

    final jug = Path()
      ..moveTo(16 * s, 22 * s)
      ..quadraticBezierTo(16 * s, 12 * s, 30 * s, 12 * s)
      ..lineTo(38 * s, 12 * s)
      ..quadraticBezierTo(48 * s, 12 * s, 48 * s, 24 * s)
      ..lineTo(48 * s, 54 * s)
      ..quadraticBezierTo(48 * s, 58 * s, 43 * s, 58 * s)
      ..lineTo(20 * s, 58 * s)
      ..quadraticBezierTo(16 * s, 58 * s, 16 * s, 54 * s)
      ..close();
    c.drawPath(jug, Paint()..color = AppColors.whitePure);
    c.drawPath(jug, stroke);

    final handle = RRect.fromLTRBR(36 * s, 22 * s, 43 * s, 38 * s, Radius.circular(3.5 * s));
    c.drawRRect(handle, Paint()..color = AppColors.mintPistachio);
    c.drawRRect(handle, stroke);
  }

  void _drawPvc(Canvas c, double s, Paint stroke) {
    final top = RRect.fromLTRBR(14 * s, 18 * s, 50 * s, 30 * s, Radius.circular(3 * s));
    c.drawRRect(top, Paint()..color = AppColors.greenMid);
    c.drawRRect(top, stroke);

    final pipe = Rect.fromLTWH(20 * s, 30 * s, 24 * s, 26 * s);
    c.drawRect(pipe, Paint()..color = AppColors.bgSurfaceMuted);
    c.drawRect(pipe, stroke);
  }

  void _drawLdpe(Canvas c, double s, Paint stroke) {
    final bag = Path()
      ..moveTo(18 * s, 12 * s)
      ..lineTo(26 * s, 12 * s)
      ..lineTo(26 * s, 22 * s)
      ..lineTo(38 * s, 22 * s)
      ..lineTo(38 * s, 12 * s)
      ..lineTo(46 * s, 12 * s)
      ..lineTo(50 * s, 54 * s)
      ..quadraticBezierTo(50 * s, 58 * s, 45 * s, 58 * s)
      ..lineTo(19 * s, 58 * s)
      ..quadraticBezierTo(14 * s, 58 * s, 14 * s, 54 * s)
      ..close();
    c.drawPath(bag, Paint()..color = AppColors.greenBright);
    c.drawPath(bag, stroke);

    final chevron = Path()
      ..moveTo(24 * s, 34 * s)
      ..lineTo(32 * s, 28 * s)
      ..lineTo(40 * s, 34 * s);
    c.drawPath(
      chevron,
      Paint()
        ..color = AppColors.mintPistachio
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * s
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawPp(Canvas c, double s, Paint stroke) {
    final lid = RRect.fromLTRBR(14 * s, 14 * s, 50 * s, 20 * s, Radius.circular(2 * s));
    c.drawRRect(lid, Paint()..color = AppColors.blackInk);

    final cup = Path()
      ..moveTo(18 * s, 20 * s)
      ..lineTo(46 * s, 20 * s)
      ..lineTo(42 * s, 56 * s)
      ..lineTo(22 * s, 56 * s)
      ..close();
    c.drawPath(cup, Paint()..color = AppColors.whitePure);
    c.drawPath(cup, stroke);
    c.drawLine(
      Offset(20 * s, 32 * s),
      Offset(44 * s, 32 * s),
      Paint()
        ..color = AppColors.greenMid
        ..strokeWidth = 2.2 * s,
    );
  }

  void _drawPs(Canvas c, double s, Paint stroke) {
    final base = Path()
      ..moveTo(10 * s, 28 * s)
      ..lineTo(54 * s, 28 * s)
      ..lineTo(48 * s, 48 * s)
      ..lineTo(16 * s, 48 * s)
      ..close();
    c.drawPath(base, Paint()..color = AppColors.blackInk);
    c.drawPath(base, stroke);

    final top = Path()
      ..moveTo(14 * s, 20 * s)
      ..lineTo(50 * s, 20 * s)
      ..lineTo(54 * s, 28 * s)
      ..lineTo(10 * s, 28 * s)
      ..close();
    c.drawPath(top, Paint()..color = AppColors.mintPistachio);
    c.drawPath(top, stroke);
  }

  void _drawOther(Canvas c, double s, Paint stroke) {
    final tri = Path()
      ..moveTo(32 * s, 10 * s)
      ..lineTo(54 * s, 48 * s)
      ..lineTo(10 * s, 48 * s)
      ..close();
    c.drawPath(tri, Paint()..color = AppColors.mintPistachio);
    c.drawPath(tri, stroke);

    final tp = TextPainter(
      text: TextSpan(
        text: '7',
        style: TextStyle(
          color: AppColors.blackInk,
          fontSize: 16 * s,
          fontWeight: FontWeight.w800,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(32 * s - tp.width / 2, 43 * s - tp.height));
  }

  @override
  bool shouldRepaint(covariant _PlasticPainter oldDelegate) => oldDelegate.cls != cls;
}
