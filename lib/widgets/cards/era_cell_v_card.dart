import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/dialogs/era_cell_voltages_dialog.dart';
import 'package:flutter/material.dart';

import 'double_value_card.dart';

class EraCellVoltagesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: EraBloc.getInstance().bms,
        builder: (BuildContext context, AsyncSnapshot<BMSData> snapshot) {
          if (snapshot.hasData) {
            final vMin = (snapshot.data.cellV.minCellV / 1000.0).toStringAsFixed(3);
            final vMinSat = snapshot.data.cellV.minCellNum ~/ 100 + 1;
            final vMinCell = snapshot.data.cellV.minCellNum % 100 + 1;

            final vMax = (snapshot.data.cellV.maxCellV / 1000.0).toStringAsFixed(3);
            final vMaxSat = snapshot.data.cellV.maxCellNum ~/ 100 + 1;
            final vMaxCell = snapshot.data.cellV.maxCellNum % 100 + 1;

            return DoubleValueCard(
                title: "Cell Voltages",
                icon: Icons.battery_charging_full,
                label1: "Min (Sat $vMinSat, cell $vMinCell)",
                value1: "$vMin V",
                label2: "Max (Sat $vMaxSat, cell $vMaxCell)",
                value2: "$vMax V",
                onTap: () {
                  showDialog(context: context, builder: (BuildContext context) {
                    return EraCellVoltagesDialog();
                  });
                });
          }
          return Container();
        });
  }
}