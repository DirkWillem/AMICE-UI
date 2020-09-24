import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:flutter/material.dart';

import 'gauge_card.dart';

class EraSoCCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: EraBloc.getInstance().bms,
        builder: (BuildContext context, AsyncSnapshot<BMSData> snapshot) {
          if (snapshot.hasData) {
            return GaugeCard(
              title: "State of Charge",
              icon: Icons.battery_std,
              value: snapshot.data.condition.soc,
              maxValue: 100,
              formatter: (v) => '${v.toStringAsFixed(1)}%',
            );
          } else {
            return Container();
          }
        });
  }
}
