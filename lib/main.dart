import 'package:amice/pages/page_base.dart';
import 'package:amice/service/bloc/era_bloc.dart';
import 'package:amice/service/models/era/era.dart';
import 'package:amice/widgets/cards/double_value_card.dart';
import 'package:amice/widgets/cards/gauge_card.dart';
import 'package:amice/widgets/cards/single_value_card.dart';
import 'package:amice/widgets/dialogs/cell_voltages_dialog.dart';
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
      ),
//      body: Center(
//        // Center is a layout widget. It takes a single child and positions it
//        // in the middle of the parent.
//        child: Column(
//          // Column is also a layout widget. It takes a list of children and
//          // arranges them vertically. By default, it sizes itself to fit its
//          // children horizontally, and tries to be as tall as its parent.
//          //
//          // Invoke "debug painting" (press "p" in the console, choose the
//          // "Toggle Debug Paint" action from the Flutter Inspector in Android
//          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//          // to see the wireframe for each widget.
//          //
//          // Column has various properties to control how it sizes itself and
//          // how it positions its children. Here we use mainAxisAlignment to
//          // center the children vertically; the main axis here is the vertical
//          // axis because Columns are vertical (the cross axis would be
//          // horizontal).
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Card(
//              child: SizedBox(
//                height: 300,
//                child: charts.PieChart(_createSampleData(context),
//                    animate: false,
//                    // Configure the width of the pie slices to 30px. The remaining space in
//                    // the chart will be left as a hole in the center. Adjust the start
//                    // angle and the arc length of the pie so it resembles a gauge.
//                    defaultRenderer: new charts.ArcRendererConfig(
//                        arcWidth: 30, startAngle: 4 / 5 * 3.14, arcLength: 7 / 5 * 3.14))
//              ),
//            ),
//            Text(
//              'You have pushed the button this many times:',
//            ),
//            Text(
//              '$_counter',
//              style: Theme.of(context).textTheme.headline4,
//            ),
//          ],
//        ),
//      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: 1,
            labelType: NavigationRailLabelType.all,
            selectedLabelTextStyle: TextStyle(color: Colors.white),
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.directions_car_outlined), selectedIcon: Icon(Icons.battery_full, color: Theme.of(context).primaryColor), label: Text('Vehicle')),
              NavigationRailDestination(icon: Icon(Icons.battery_full_outlined), selectedIcon: Icon(Icons.battery_full, color: Theme.of(context).primaryColor), label: Text('Battery')),
              NavigationRailDestination(icon: Icon(Icons.ev_station_outlined), label: Text('Charging')),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: PageBase([
              Tile(
//          builder: (BuildContext context) => SingleValueCard(
//              title: "BMS State", icon: Icons.settings_applications, value: "ESS"),
                builder: (BuildContext context) => StreamBuilder(
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
                    }),
                rowspan: 1,
                colspan: 1,
              ),
              Tile(
                builder: (BuildContext context) => StreamBuilder(
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
                    }),
                rowspan: 1,
                colspan: 1,
              ),
              Tile(
                builder: (BuildContext context) => StreamBuilder(
                    stream: EraBloc.getInstance().bms,
                    builder: (BuildContext context, AsyncSnapshot<BMSData> snapshot) {
                      if (snapshot.hasData) {
                        return DoubleValueCard(
                            title: "Cell Voltages",
                            icon: Icons.battery_charging_full,
                            label1: "Min",
                            value1: "${(snapshot.data.cellV.minCellV / 1000.0).toStringAsFixed(3)} V",
                            label2: "Max",
                            value2: "${(snapshot.data.cellV.maxCellV / 1000.0).toStringAsFixed(3)} V",
                            onTap: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return CellVoltagesDialog();
                              });
                            });
                      }
                      return Container();
                    }),
                rowspan: 1,
                colspan: 1,
              ),
            ]),
          ),
        ],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GaugeSegment, String>> _createSampleData(
      BuildContext context) {
    final data = [
      new GaugeSegment('Low', 75),
      new GaugeSegment('Acceptable', 100),
      new GaugeSegment('High', 50),
      new GaugeSegment('Highly Unusual', 5),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'Segments',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        data: data,
        seriesColor:
            charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        colorFn: (_1, _2) =>
            charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
      )
    ];
  }
}
