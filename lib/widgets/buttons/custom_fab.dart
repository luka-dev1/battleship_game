import 'package:flutter/material.dart';

class CustomFAB extends StatefulWidget {
  final Function onTap;
  final EdgeInsets padding;
  final BoxShape shape;
  final double size;
  final Widget label;
  final Color color;

  const CustomFAB({
    Key? key,
    required this.onTap,
    required this.padding,
    required this.shape,
    required this.size,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  State<CustomFAB> createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  var _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) async {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        Future.delayed(
          const Duration(milliseconds: 50),
          () {
            setState(() {
              _isPressed = false;
            });
            widget.onTap();
          },
        );
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        padding: widget.padding,
        height: _isPressed ? widget.size * 0.8 : widget.size,
        width: _isPressed ? widget.size * 0.8 : widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: widget.shape,
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.5,
              offset: Offset(0, 1),
              color: Colors.blueGrey, //Colors.black.withOpacity(0.3),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn,
        child: FittedBox(
          fit: BoxFit.contain,
          child: widget.label,
        ),
      ),
    );
  }
}
