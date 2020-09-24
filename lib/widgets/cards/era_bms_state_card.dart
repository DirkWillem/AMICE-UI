import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/cards/single_value_card.dart';
import 'package:amice/widgets/dialogs/wiki_dialog.dart';
import 'package:flutter/material.dart';

import 'double_value_card.dart';

class EraBMSStateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: EraBloc.getInstance().bms,
        builder: (BuildContext context, AsyncSnapshot<BMSData> snapshot) {
          if (snapshot.hasData) {
            var state = snapshot.data.state;
            if (state.error == BMSError.none) {
              return SingleValueCard(
                title: "BMS State",
                icon: Icons.settings_applications,
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
                title: "BMS State",
                icon: Icons.settings_applications,
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