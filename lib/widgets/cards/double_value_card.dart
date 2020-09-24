import 'package:flutter/material.dart';

class DoubleValueCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String label1;
  final String value1;
  final String label2;
  final String value2;
  final VoidCallback onTap;

  DoubleValueCard({
    @required this.title,
    @required this.icon,
    @required this.label1,
    @required this.value1,
    @required this.label2,
    @required this.value2,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: onTap,
          onLongPress: () {
            print('long press');
          },
          onDoubleTap: () {
            print('dtab');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(icon, color: Theme.of(context).primaryColor, size: 16)),
                    Text(title, style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(180))),
                  ],
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(label1, style: TextStyle(fontSize: 10)),
                        Text(value1, style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor))
                      ],
                    )
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(label2, style: TextStyle(fontSize: 10)),
                        Text(value2, style: TextStyle(fontSize: 22, color: Theme.of(context).primaryColor))
                      ],
                    )
                ),
              ],
            ),
          ),
        )
    );
  }
}
