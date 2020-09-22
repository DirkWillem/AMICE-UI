import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/bms.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class CellVoltagesDialog extends StatefulWidget {
  @override
  _CellVoltagesDialogState createState() => _CellVoltagesDialogState();
}

class _CellVoltagesDialogState extends State<CellVoltagesDialog> {
  @override
  void initState() {
    super.initState();
    EraBloc.getInstance().fetchBatteryCellDataPeriodic();
  }

  @override
  void dispose() {
    super.dispose();
    EraBloc.getInstance().cancelPeriodicCellData();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: StreamBuilder(
        stream: EraBloc.getInstance().bms,
        builder: (BuildContext context, AsyncSnapshot<BMSData> snapshot) {
          if (!snapshot.hasData || snapshot.data.cellData == null) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            );
          }

          final data = snapshot.data.cellData;

          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
            child: DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: "Sat 1"),
                      Tab(text: "Sat 2"),
                      Tab(text: "Sat 3"),
                    ],
                    labelColor: Colors.white,
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
                        child: charts.BarChart(
                          _createData(data.sat1V), animate: false,
                          barRendererDecorator: charts.BarLabelDecorator<String>(
                            insideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.black),
                            outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.white),
                          ),
                          vertical: false,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
                        child: charts.BarChart(
                          _createData(data.sat2V), animate: false,
                          barRendererDecorator: charts.BarLabelDecorator<String>(
                          ),
                          vertical: false,
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 600, maxHeight: 400),
                        child: charts.BarChart(
                          _createData(data.sat3V), animate: false,
                          barRendererDecorator: charts.BarLabelDecorator<String>(
                          ),
                          vertical: false,
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  List<charts.Series<_CellVoltage, String>> _createData(List<int> data) {
    return [
      charts.Series(
        id: 'Satellite 1',
        domainFn: (data, _) => data.index.toString(),
        measureFn: (data, _) => data.voltage,
        data: List.generate(data.length, (int i) => _CellVoltage(i+1, data[i]/1000)),
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).primaryColor),
        labelAccessorFn: (data, _) => '${data.voltage.toString()} V',
      ),
    ];
  }
}

class _CellVoltage {
  final int index;
  final double voltage;

  _CellVoltage(this.index, this.voltage);
}
