import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/dialogs/wiki_dialog.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'single_value_card.dart';
import 'double_value_card.dart';

class EraStateCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: CombineLatestStream.combine2(
          EraBloc.getInstance().bms,
          EraBloc.getInstance().lvc,
            (BMSData bms, LVCData lvc) => _VehicleStateData(bms?.state?.state, bms?.state?.error, lvc?.state?.vehicleState)
        ),
        builder: (BuildContext context, AsyncSnapshot<_VehicleStateData> snapshot) {
          if (snapshot.hasData && snapshot.data.bmsState != null && snapshot.data.vehicleState != null) {
            final bmsState = snapshot.data.bmsState;
            final lvc = snapshot.data.vehicleState;

            if (bmsState == BMSState.ess) {
              return DoubleValueCard(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return WikiDialog();
                      });
                },
                title: "Vehicle State",
                icon: Icons.settings_applications,
                label1: "State",
                value1: "ESS",
                label2: "BMS Error",
                value2: snapshot.data.bmsError.shortName,
              );
            } else {
              return SingleValueCard(
                title: "Vehicle State",
                icon: Icons.settings_applications,
                value: lvc.shortName,
              );
            }
          }
          return Container();
        });
  }
}

class _VehicleStateData {
  final BMSState bmsState;
  final BMSError bmsError;
  final VehicleState vehicleState;
  
  _VehicleStateData(this.bmsState, this.bmsError, this.vehicleState);
}