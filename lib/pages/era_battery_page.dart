import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/widgets/cards/era_bms_state_card.dart';
import 'package:amice/widgets/cards/era_cell_t_card.dart';
import 'package:amice/widgets/cards/era_cell_v_card.dart';
import 'package:amice/widgets/cards/era_soc_card.dart';
import 'package:flutter/material.dart';

import 'page_base.dart';

class EraBatteryPage extends StatefulWidget {
  @override
  _EraBatteryPageState createState() => _EraBatteryPageState();
}

class _EraBatteryPageState extends State<EraBatteryPage> {
  @override
  void initState() {
    super.initState();
    EraBloc.getInstance().fetchBatteryInfoPeriodic();
  }

  @override
  void dispose() {
    super.dispose();
    EraBloc.getInstance().cancelPeriodicBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PageBase([
      Tile(
        builder: (BuildContext context) => EraBMSStateCard(),
        rowspan: 1,
        colspan: 1,
      ),
      Tile(
        builder: (BuildContext context) => EraSoCCard(),
        rowspan: 1,
        colspan: 1,
      ),
      Tile(
        builder: (BuildContext context) => EraCellVoltagesCard(),
        rowspan: 1,
        colspan: 1,
      ),
      Tile(
        builder: (BuildContext context) => EraCellTempsCard(),
        rowspan: 1,
        colspan: 1,
      ),
    ]);
  }
}
