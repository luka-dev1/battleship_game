import 'package:flutter/material.dart';

class BigButton extends StatefulWidget {
  final Function onTap;
  final EdgeInsets padding;
  final double height;
  final double width;
  final Color color;
  final Widget label;

  BigButton({
    required this.onTap,
    required this.padding,
    required this.height,
    required this.width,
    required this.color,
    required this.label,
  });

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {
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
        widget.onTap();
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        padding: widget.padding,
        height: _isPressed ? widget.height * 0.9 : widget.height,
        width: _isPressed ? widget.width * 0.9 : widget.width,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.5,
              offset: Offset(0.0, 0.5),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn,
        child: FittedBox(fit: BoxFit.contain, child: widget.label),
      ),
    );
  }
}
