import 'package:flutter/material.dart';

class TextButtonWithBorder extends StatelessWidget {
  final String title;
  final Color widgetColor;
  final VoidCallback onPressed;

  const TextButtonWithBorder({
    super.key,
    required this.onPressed,
    required this.title,
    required this.widgetColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: widgetColor),
        ),
      ),
      child: Text(title, style: TextStyle(color: widgetColor)),
    );
  }
}
