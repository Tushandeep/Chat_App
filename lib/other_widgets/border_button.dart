import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  final String text;
  final double? borderRadius;
  final double? borderWidth;
  final Color? borderColor;
  final Color? textColor;
  final Function() onPress;
  final bool? bold;
  const BorderButton({
    Key? key,
    required this.text,
    required this.onPress,
    this.borderRadius = 1,
    this.borderWidth = 1,
    this.borderColor = Colors.black,
    this.textColor = Colors.white,
    this.bold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor!,
          width: borderWidth!,
        ),
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: TextButton(
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(
            color: textColor!,
            fontWeight: (bold!) ? FontWeight.bold : null,
          ),
        ),
      ),
    );
  }
}
