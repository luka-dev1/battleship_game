import 'package:flutter/material.dart';

class CustomFABExtended extends StatefulWidget {
  final Function onTap;
  final EdgeInsets padding;
  final double height;
  final Color color;
  final Widget label;

  const CustomFABExtended({
    Key? key,
    required this.onTap,
    required this.padding,
    required this.height,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  State<CustomFABExtended> createState() => _CustomFABExtendedState();
}

class _CustomFABExtendedState extends State<CustomFABExtended> {
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
      child: Container(
        padding: widget.padding,
        height: _isPressed ? widget.height * 0.9 : widget.height,
        width: _isPressed ? (widget.height * 2.5) * 0.9 : (widget.height * 2.5),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 0.5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.contain,
          child: widget.label,
        ),
      ),
    );
  }
}
