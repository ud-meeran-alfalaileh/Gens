import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rotate and Pause Image'),
        ),
        body: Center(
          child: RotatingImage(),
        ),
      ),
    );
  }
}

class RotatingImage extends StatefulWidget {
  @override
  _RotatingImageState createState() => _RotatingImageState();
}

class _RotatingImageState extends State<RotatingImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _rotated = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _startRotationCycle();
  }

  void _startRotationCycle() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_rotated) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _rotated = !_rotated;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Image.asset(
          width: context.screenWidth * .5,
          'assets/image/hourglass.png'), // Replace with your image path
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * pi, // Rotates 180 degrees
          child: child,
        );
      },
    );
  }
}
