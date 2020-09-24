import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/dialogs/wiki_dialog.dart';
import 'package:flutter/material.dart';

import 'single_value_card.dart';
import 'double_value_card.dart';

class EraChCStateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: EraBloc.getInstance().chc,
        builder: (BuildContext context, AsyncSnapshot<ChCData> snapshot) {
          if (snapshot.hasData) {
            var state = snapshot.data.state;
            if (state.error == ChCError.none) {
              return SingleValueCard(
                title: "Charging State",
                icon: Icons.ev_station,
                value: snapshot.data.state.state.name,
              );
            } else {
              return DoubleValueCard(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WikiDialog();
                      });
                },
                title: "Charging State",
                icon: Icons.ev_station,
                label1: "State",
                value1: state.state.name,
                label2: "Error",
                value2: state.error.shortName,
              );
            }
          }
          return Container();
        });
  }
}