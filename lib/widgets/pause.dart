import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isRunning;

  const PauseButton({
    super.key,
    required this.onPressed,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
        decoration: BoxDecoration(
          color: isRunning ? const Color(0xFFEB5757) : const Color(0xFF5DADE2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isRunning ? Colors.red.shade100 : Colors.blue.shade100,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          isRunning ? 'Pause' : 'Start',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
