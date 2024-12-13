import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';

class RotatingImage extends StatefulWidget {
  const RotatingImage({super.key,required this.image});
  final String image;
  @override
  State<RotatingImage> createState() => _RotatingImageState();
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
        widget.image), // Replace with your image path
      builder: (BuildContext context, Widget? child) {
        return Transform.rotate(
          angle: _controller.value * pi, // Rotates 180 degrees
          child: child,
        );
      },
    );
  }
}
