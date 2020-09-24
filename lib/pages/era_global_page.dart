import 'package:amice/pages/page_base.dart';
import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/widgets/cards/era_bms_state_card.dart';
import 'package:amice/widgets/cards/era_cell_t_card.dart';
import 'package:amice/widgets/cards/era_cell_v_card.dart';
import 'package:amice/widgets/cards/era_chc_state_card.dart';
import 'package:amice/widgets/cards/era_digital_twin_card.dart';
import 'package:amice/widgets/cards/era_soc_card.dart';
import 'package:amice/widgets/cards/era_state_card.dart';
import 'package:flutter/material.dart';

class EraGlobalPage extends StatefulWidget {
  @override
  _EraGlobalPageState createState() => _EraGlobalPageState();
}

class _EraGlobalPageState extends State<EraGlobalPage> {
  @override
  void initState() {
    super.initState();
    EraBloc.getInstance().fetchGlobalInfoPeriodic();
  }

  @override
  void dispose() {
    super.dispose();
    EraBloc.getInstance().cancelPeriodicGlobalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return PageBase([
      Tile(
        builder: (BuildContext context) => EraDigitalTwinCard(),
        rowspan: 3,
        colspan: 2,
      ),
      Tile(
        builder: (BuildContext context) => EraSoCCard(),
        rowspan: 1,
        colspan: 1,
      ),
      Tile(
        builder: (BuildContext context) => EraStateCard(),
        rowspan: 1,
        colspan: 1,
      ),
      Tile(
        builder: (BuildContext context) => EraChCStateCard(),
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
