import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

typedef String ValueFormatter(double value);

class GaugeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final double value;
  final double maxValue;
  final ValueFormatter formatter;

  final List<_GaugeSegment> _segments;

  GaugeCard({
    @required this.title,
    @required this.icon,
    @required this.value,
    @required this.maxValue,
    @required this.formatter,
  }) : _segments = [
          _GaugeSegment("Value", value, true),
          _GaugeSegment("Rest", maxValue - value, false),
        ];

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 6,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(icon,
                      color: Theme.of(context).primaryColor, size: 16)),
              Text(title, style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(180))),
            ],
          ),
          Expanded(
              child: Stack(
            children: [
              Center(
                  child: charts.PieChart([
                charts.Series<_GaugeSegment, String>(
                  id: title,
                  domainFn: (_GaugeSegment s, _) => s.segment,
                  measureFn: (_GaugeSegment s, _) => s.size,
                  colorFn: (_GaugeSegment s, _) => s.filled
                      ? charts.ColorUtil.fromDartColor(
                          Theme.of(context).primaryColor)
                      : charts.Color.transparent,
                  data: _segments,
                )
              ],
                      animate: false,
                      defaultRenderer: new charts.ArcRendererConfig(
                        arcWidth: 15,
                        //startAngle: 3.14,
                        /*arcLength: 3.14*/
                      ))),
              Center(
                  child: Text(formatter(value), style: TextStyle(fontSize: 20)))
            ],
          )),
        ],
      ),
    ));
  }
}

class _GaugeSegment {
  final String segment;
  final double size;
  final bool filled;

  _GaugeSegment(this.segment, this.size, this.filled);
}
