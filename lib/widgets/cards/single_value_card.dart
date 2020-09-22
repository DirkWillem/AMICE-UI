import 'package:flutter/material.dart';

class SingleValueCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;

  SingleValueCard({
    @required this.title,
    @required this.icon,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(icon, color: Theme.of(context).primaryColor, size: 16)),
                Text(title, style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(180))),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(value, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 32))
              ),
            ),
          ],
        ),
      )
    );
  }
}
