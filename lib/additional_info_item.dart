import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const AdditionalInfo({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          Container(
            height: 10,
          ),
          Text(
              style: const TextStyle(
                fontSize: 14,
              ),
              label),
          Container(
            height: 8,
          ),
          Text(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              value),
        ],
      ),
    );
  }
}
