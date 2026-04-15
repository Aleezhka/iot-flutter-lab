import 'package:flutter/material.dart';

class WorkshopButton extends StatelessWidget {
  const WorkshopButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.color,
  });

  final String label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFFFB347),
          shape: const RoundedRectangleBorder(),
        ),
        onPressed: onPressed,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
