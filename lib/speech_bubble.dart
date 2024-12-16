import 'dart:math';

import 'package:flutter/material.dart';

enum NipLocation {
  TOP,
  RIGHT,
  BOTTOM,
  LEFT,
  BOTTOM_RIGHT,
  BOTTOM_LEFT,
  TOP_RIGHT,
  TOP_LEFT,
}

const double defaultNipHeight = 10.0;

class SpeechBubble extends StatelessWidget {
  const SpeechBubble({
    Key? key,
    required this.child,
    this.nipLocation = NipLocation.BOTTOM,
    this.color = Colors.redAccent,
    this.borderRadius = 4.0,
    this.height,
    this.width,
    this.padding,
    this.nipHeight = defaultNipHeight,
    this.offset = Offset.zero,
  }) : super(key: key);

  final Widget child;
  final NipLocation nipLocation;
  final Color color;
  final double borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double nipHeight;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final nipData = _calculateNipOffset();
    return Stack(
      alignment: nipData.alignment,
      children: [
        _buildSpeechBubble(),
        _buildNip(nipData.offset),
      ],
    );
  }

  Widget _buildSpeechBubble() {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      color: color,
      elevation: 1.0,
      child: Container(
        height: height,
        width: width,
        padding: padding ?? const EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }

  Widget _buildNip(Offset nipOffset) {
    return Transform.translate(
      offset: nipOffset,
      child: Transform.rotate(
        angle: pi / 4, // 45 degrees in radians
        child: Material(
          borderRadius: BorderRadius.circular(1.5),
          color: color,
          child: SizedBox(
            height: nipHeight,
            width: nipHeight,
          ),
        ),
      ),
    );
  }

  _NipData _calculateNipOffset() {
    final rotatedNipHalfHeight = nipHeight / sqrt(2); // Pre-compute rotated height
    final baseOffset = nipHeight / 2 + rotatedNipHalfHeight;

    late Offset nipOffset;
    late AlignmentGeometry alignment;

    switch (nipLocation) {
      case NipLocation.TOP:
        nipOffset = Offset(0, -baseOffset);
        alignment = Alignment.topCenter;
        break;
      case NipLocation.RIGHT:
        nipOffset = Offset(baseOffset, 0);
        alignment = Alignment.centerRight;
        break;
      case NipLocation.BOTTOM:
        nipOffset = Offset(0, baseOffset);
        alignment = Alignment.bottomCenter;
        break;
      case NipLocation.LEFT:
        nipOffset = Offset(-baseOffset, 0);
        alignment = Alignment.centerLeft;
        break;
      case NipLocation.BOTTOM_LEFT:
        nipOffset = offset + Offset(baseOffset, baseOffset);
        alignment = Alignment.bottomLeft;
        break;
      case NipLocation.BOTTOM_RIGHT:
        nipOffset = offset + Offset(-baseOffset, baseOffset);
        alignment = Alignment.bottomRight;
        break;
      case NipLocation.TOP_LEFT:
        nipOffset = offset + Offset(baseOffset, -baseOffset);
        alignment = Alignment.topLeft;
        break;
      case NipLocation.TOP_RIGHT:
        nipOffset = offset + Offset(-baseOffset, -baseOffset);
        alignment = Alignment.topRight;
        break;
    }

    return _NipData(offset: nipOffset, alignment: alignment);
  }
}

class _NipData {
  final Offset offset;
  final AlignmentGeometry alignment;

  _NipData({required this.offset, required this.alignment});
}
