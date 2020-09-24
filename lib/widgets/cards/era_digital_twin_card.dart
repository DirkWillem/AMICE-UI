import 'dart:async';

import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/dialogs/wiki_dialog.dart';
import 'package:flutter/material.dart';

import 'single_value_card.dart';

class EraDigitalTwinCard extends StatefulWidget {
  @override
  _EraDigitalTwinCardState createState() => _EraDigitalTwinCardState();
}

class _EraDigitalTwinCardState extends State<EraDigitalTwinCard> with TickerProviderStateMixin {
  AnimationController _lbAnimationController;
  AnimationController _hbAnimationController;

  Animation<double> _lbAnimation;
  Animation<double> _hbAnimation;

  StreamSubscription _ssbSubscription;

  bool lb = false;
  bool hb = false;

  @override
  void initState() {
    super.initState();

    _lbAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _hbAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    Tween<double> tween = Tween(begin: 0, end: 1);
    _lbAnimation = tween.animate(_lbAnimationController);
    _hbAnimation = tween.animate(_hbAnimationController);

    _lbAnimation.addListener(() { setState((){}); });
    _hbAnimation.addListener(() { setState((){}); });

    _ssbSubscription = EraBloc.getInstance().ssb.listen((ssbData) {
      final lights = ssbData.lightingState.state;
      final newLb = lights == MainLightingState.lb || lights == MainLightingState.hb;
      final newHb = lights == MainLightingState.hb;

      if (newLb != lb || newHb != hb) {
        setState(() {
          if (newLb != lb) {
            if (lb) {
              _lbAnimationController.reverse();
            } else {
              _lbAnimationController.forward();
            }
          }

          if (newHb != hb) {
            if (hb) {
              _hbAnimationController.reverse();
            } else {
              _hbAnimationController.forward();
            }
          }

          lb = newLb;
          hb = newHb;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _lbAnimationController.dispose();
    _hbAnimationController.dispose();

    _ssbSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.lightbulb_outline, color: Theme.of(context).primaryColor, size: 16)),
                  Text("Digital Twin 4.0", style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(180))),
                ],
              ),
              Expanded(
                child: CustomPaint(painter: _DigitalTwinPainter(lb, hb, _lbAnimation.value, _hbAnimation.value),
                  child:                           Padding(
                    padding: const EdgeInsets.only(top: 100, bottom: 80, left: 60, right: 60),
                    child: Image(
                      image: AssetImage('assets/images/era_topview.png'),
                    ),
                  ),),
              ),
            ],
          ),
        )
    );
  }
}

class _DigitalTwinPainter extends CustomPainter {
  final bool lb;
  final bool hb;
  final double lbAnim;
  final double hbAnim;

  _DigitalTwinPainter(this.lb, this.hb, this.lbAnim, this.hbAnim);

  @override
  void paint(Canvas canvas, Size size) {
    // Low beam
    var drlGradient = RadialGradient(
      center:  const Alignment(0, 1),
      radius: 1,
      colors: [Color.fromARGB((lbAnim * 255).round(), 255, 255, 255), const Color.fromARGB(0, 255, 255, 255)],
      stops: [0.0, 1.0],
    );
    var drlRect = Offset(0, 50) & Size(size.width, 140);
    var drlPath = Path()
      ..moveTo(0.35 * size.width, 140)
      ..lineTo(0.2 * size.width, 50)
      ..lineTo(0.8 * size.width, 50)
      ..lineTo(0.65 * size.width, 140)
      ..close();
    var drlPaint = Paint()..shader = drlGradient.createShader(drlRect);

    // High beam
    var hbGradient = RadialGradient(
      center:  const Alignment(0, 1),
      radius: 1,
      colors: [Color.fromARGB((hbAnim * 255).round(), 255, 255, 255), const Color.fromARGB(0, 255, 255, 255)],
      stops: [0.0, 1.0],
    );
    var hbRect = Offset(0, 20) & Size(size.width, 140);
    var hbPath = Path()
      ..moveTo(0.4 * size.width, 140)
      ..lineTo(0.3 * size.width, 20)
      ..lineTo(0.7 * size.width, 20)
      ..lineTo(0.6 * size.width, 140)
      ..close();
    var hbPaint = Paint()..shader = hbGradient.createShader(hbRect);

    // Rear lights
    var rlGradient = RadialGradient(
      center:  const Alignment(0, -1),
      radius: 0.3,
      colors: [Color.fromARGB((lbAnim * 255).round(), 255, 0, 0), const Color.fromARGB(0, 255, 0, 0)],
      stops: [0.0, 1.0],
    );
    var rlRect = Offset(0, size.height - 100) & Size(size.width, size.height - 20);
    var rlPath = Path()
      ..moveTo(0.4 * size.width, size.height - 100)
      ..lineTo(0.2 * size.width, size.height - 20)
      ..lineTo(0.8 * size.width, size.height - 20)
      ..lineTo(0.6 * size.width, size.height - 100)
      ..close();
    var rlPaint = Paint()..shader = rlGradient.createShader(rlRect);

    if (lb) {
      canvas.drawPath(drlPath, drlPaint);
      canvas.drawPath(rlPath, rlPaint);
    }

    if (hb) {
      canvas.drawPath(hbPath, hbPaint);
    }
  }

  @override
  bool shouldRepaint(_DigitalTwinPainter old) =>
    old.lb != lb || old.hb != hb || old.lbAnim != lbAnim || old.hbAnim != hbAnim;
  @override
  bool shouldRebuildSemantics(_DigitalTwinPainter oldDelegate) => false;
}