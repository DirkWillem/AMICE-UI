import 'package:amice/pages/era_battery_page.dart';
import 'package:amice/pages/era_global_page.dart';
import 'package:amice/pages/page_base.dart';
import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/cards/double_value_card.dart';
import 'package:amice/widgets/cards/gauge_card.dart';
import 'package:amice/widgets/cards/single_value_card.dart';
import 'package:amice/widgets/dialogs/amice_status_dialog.dart';
import 'package:amice/widgets/dialogs/era_cell_temperatures_dialog.dart';
import 'package:amice/widgets/dialogs/era_cell_voltages_dialog.dart';
import 'package:amice/widgets/dialogs/wiki_dialog.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MyApp());
}

// ffdf00

Map<int, Color> color = {
  50: Color.fromRGBO(255, 223, 0, .1),
  100: Color.fromRGBO(255, 223, 0, .2),
  200: Color.fromRGBO(255, 223, 0, .3),
  300: Color.fromRGBO(255, 223, 0, .4),
  400: Color.fromRGBO(255, 223, 0, .5),
  500: Color.fromRGBO(255, 223, 0, .6),
  600: Color.fromRGBO(255, 223, 0, .7),
  700: Color.fromRGBO(255, 223, 0, .8),
  800: Color.fromRGBO(255, 223, 0, .9),
  900: Color.fromRGBO(255, 223, 0, 1),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: MaterialColor(0xffffdf00, color),
        accentColor: MaterialColor(0xffffdf00, color),
        brightness: Brightness.dark,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class GaugeSegment {
  final String segment;
  final int size;

  GaugeSegment(this.segment, this.size);
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int pageIndex = 1;
  Widget page = EraBatteryPage();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

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

  void navigate(int index) {
    setState(() {
      pageIndex = index;

      switch (index) {
        case 0: page = EraGlobalPage(); break;
        case 1: page = EraBatteryPage(); break;
        default: page = EraGlobalPage(); break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Stella Era'),
        actions: [
          IconButton(icon: Icon(Icons.settings_ethernet), onPressed: () {
            showDialog(context: context, builder: (BuildContext context) {
              return AmiceStatusDialog();
            });
          })
        ]
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: pageIndex,
            labelType: NavigationRailLabelType.all,
            selectedLabelTextStyle: TextStyle(color: Colors.white),
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.directions_car_outlined), selectedIcon: Icon(Icons.directions_car, color: Theme.of(context).primaryColor), label: Text('Vehicle')),
              NavigationRailDestination(icon: Icon(Icons.battery_std_outlined), selectedIcon: Icon(Icons.battery_full), label: Text('Battery')),
              NavigationRailDestination(icon: Icon(Icons.ev_station_outlined), label: Text('Charging')),
              NavigationRailDestination(icon: Icon(Icons.speed), label: Text('DT')),
              NavigationRailDestination(icon: Icon(Icons.book), label: Text('Wiki')),
            ],
            onDestinationSelected: navigate,
            selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: page,
          ),
        ],
      ),
    );
  }
}
