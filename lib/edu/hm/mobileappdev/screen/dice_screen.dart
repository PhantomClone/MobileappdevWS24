import 'dart:math';

import 'package:flutter/material.dart';

class DiceScreen extends StatefulWidget {
  final int value;
  final Duration duration;
  final bool isSelected;
  final bool update;
  final int rerolls;
  final bool allowUpdates;
  final double fontSize;
  final double boxSize;
  final Color selectedColor;

  const DiceScreen({
    required this.value,
    this.duration = const Duration(seconds: 1),
    this.isSelected = false,
    this.update = false,
    this.rerolls = -1,
    this.allowUpdates = true,
    this.fontSize = 24,
    this.boxSize = 60,
    this.selectedColor = Colors.amber,
    super.key,
  });

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();

    _currentValue = widget.value;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    IntTween(begin: 1, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    ).addListener(() {
      setState(() {
        _currentValue = Random().nextInt(6) + 1;
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentValue = widget.value;
        });
      }
    });

    _rollDice();
  }

  @override
  void didUpdateWidget(covariant DiceScreen oldScreen) {
    super.didUpdateWidget(oldScreen);

    if (widget.update) {
      _rollDice();
    } else if (oldScreen.isSelected && !widget.isSelected) {
      if (oldScreen.rerolls != widget.rerolls || widget.rerolls == -1 || oldScreen.rerolls == -1) {
        _rollDice();
      }
    }
  }

  void _rollDice() {
    if (widget.allowUpdates) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.boxSize,
      height: widget.boxSize,
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.amber[100] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 5),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '$_currentValue',
        style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
