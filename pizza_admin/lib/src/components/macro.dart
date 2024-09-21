import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MacroWidget extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final TextEditingController controller;

  const MacroWidget({
    required this.title,
    required this.value,
    required this.icon,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(offset: Offset(2, 2), blurRadius: 5, color: Colors.grey)
          ],
        ),
        child: Column(
          children: [
            FaIcon(
              icon,
              color: Colors.redAccent,
            ),
            const SizedBox(
              height: 4,
            ),
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
              decoration: InputDecoration(
                isDense: true,
                suffixText: title == "Calories" ? '' : 'g',
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
