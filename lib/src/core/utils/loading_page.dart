import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

Align loadingPage(BuildContext context) {
  return Align(
    alignment: Alignment.center,
    child: Container(
      width: context.screenWidth,
      height: context.screenHeight,
      color: AppTheme.lightAppColors.background,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: context.screenWidth * .3,
              height: context.screenHeight * .3,
              child: Image.asset("assets/image/logo_main.png"),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: context.screenWidth * .08,
              height: context.screenHeight * .08,
              child: const RotatingImageLoading(
                image: 'assets/image/logo_center.png',
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class RotatingImageLoading extends StatefulWidget {
  const RotatingImageLoading({super.key, required this.image});
  final String image;
  @override
  State<RotatingImageLoading> createState() => _RotatingImageLoadingState();
}

class _RotatingImageLoadingState extends State<RotatingImageLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _rotated = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _startRotationCycle();
  }

  void _startRotationCycle() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
          width: context.screenWidth * .2,
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
