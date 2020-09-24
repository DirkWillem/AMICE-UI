import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/cards/single_value_card.dart';
import 'package:amice/widgets/dialogs/era_cell_temperatures_dialog.dart';
import 'package:amice/widgets/dialogs/wiki_dialog.dart';
import 'package:flutter/material.dart';

import 'double_value_card.dart';

class EraCellTempsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: EraBloc.getInstance().bms,
        builder: (BuildContext context, AsyncSnapshot<BMSData> snapshot) {
          if (snapshot.hasData) {
            final tMin = (snapshot.data.cellT.minCellT / 100.0).toString();
            final tMinSat = snapshot.data.cellT.minCellNum ~/ 100 + 1;
            final tMinNTC = snapshot.data.cellT.minCellNum % 100 + 1;

            final tMax = (snapshot.data.cellT.maxCellT / 100.0).toString();
            final tMaxSat = snapshot.data.cellT.maxCellNum ~/ 100 + 1;
            final tMaxNTC = snapshot.data.cellT.maxCellNum % 100 + 1;

            return DoubleValueCard(
                title: "Cell Temperatures",
                icon: Icons.local_fire_department,
                label1: "Min (Sat $tMinSat, NTC $tMinNTC)",
                value1: "$tMin °C",
                label2: "Max (Sat $tMaxSat, NTC $tMaxNTC)",
                value2: "$tMax °C",
                onTap: () {
                  showDialog(context: context, builder: (BuildContext context) {
                    return EraCellTemperaturesDialog();
                  });
                });
          }
          return Container();
        });
  }
}
