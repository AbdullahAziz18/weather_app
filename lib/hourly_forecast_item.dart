import 'package:flutter/material.dart';

class HourlyforecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final double temperature;
  const HourlyforecastItem({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(68, 28, 70, 206),
      elevation: 6,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            12,
          ),
        ),
        child: Column(
          children: [
            Text(
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              time,
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
              color:
                  icon == Icons.cloud ? Colors.lightBlueAccent : Colors.orange,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              style: const TextStyle(
                fontSize: 12,
              ),
              '${temperature.toStringAsFixed(1)} °C',
            ),
          ],
        ),
      ),
    );
  }
}
