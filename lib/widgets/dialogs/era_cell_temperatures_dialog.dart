import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/bms.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class EraCellTemperaturesDialog extends StatefulWidget {
  @override
  _EraCellTemperaturesDialogState createState() => _EraCellTemperaturesDialogState();
}

class _EraCellTemperaturesDialogState extends State<EraCellTemperaturesDialog> {
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

            var bars = [data.sat1T, data.sat2T, data.sat3T].map(
                    (data) => charts.BarChart(
                  _createData(data), animate: false,
                  barRendererDecorator: charts.BarLabelDecorator<String>(
                    insideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.black),
                    outsideLabelStyleSpec: charts.TextStyleSpec(color: charts.Color.white),
                  ),
                  vertical: false,
                  domainAxis: charts.OrdinalAxisSpec(),
                )
            ).toList();

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
                      labelColor: Theme.of(context).primaryColor,
                      indicatorColor: Theme.of(context).primaryColor,
                    ),
                    Expanded(
                      child: TabBarView(children: bars),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  List<charts.Series<_CellTemperature, String>> _createData(List<int> data) {
    return [
      charts.Series(
        id: 'Satellite 1',
        domainFn: (data, _) => data.index.toString(),
        measureFn: (data, _) => data.temperature,
        data: List.generate(data.length, (int i) => _CellTemperature(i+1, data[i])),
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            Theme.of(context).primaryColor),
        labelAccessorFn: (data, _) => '${data.temperature.toString()} °C',
      ),
    ];
  }
}

class _CellTemperature {
  final int index;
  final int temperature;

  _CellTemperature(this.index, this.temperature);
}
