import 'package:flutter/material.dart';
import 'package:spider_chart/spider_chart.dart';

void main() {
  runApp(MyApp());
}

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
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('柱状图'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 200,height: 200,
          child: SpiderChart(
              features: [
                [7,6,5,5],
                [2,3,4,2],
              ],
              maxValue: 10,
              levels: [3,6,10],
              featureColors: [Colors.pink,Colors.cyan],
              labels: <String>[
                "label 1",
                "label 2",
                "label 3",
                "label 4",
              ]
          ),
        ),
      ),
    );
  }
}

