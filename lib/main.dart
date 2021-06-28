import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:spinningwheel/SpinningWheel.dart';
import 'dart:math';
import 'WedgeData.dart';

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
      ),
      home: MyHomePage(title: 'Spinning Wheel'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WedgeData> wedgeData = [];
  final StreamController winnerController = StreamController<int>.broadcast();
  dispose() {
    super.dispose();
    winnerController.close();
  }

  Random random = Random();
  final nameCon = new TextEditingController();
  final entriesCon = new TextEditingController();
  void addData(){
    if(nameCon.text.isEmpty){
      return;

    }
    int entries = 1;
    if(entriesCon.text.isNotEmpty){
      entries = int.parse(entriesCon.text);

    }
    setState(() {
      for(int i = 0;i<entries;i++){
        wedgeData.add(WedgeData(name: nameCon.text,color: Colors.primaries[random.nextInt(Colors.primaries.length)]));


      }
      nameCon.clear();
      entriesCon.clear();
      wedgeData.shuffle(random);



    });
    wedgeData.shuffle(random);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0,40,0,0),
              child: StreamBuilder(
                stream: winnerController.stream,
                builder: (context, snapshot) {
                  if(snapshot.hasData&&snapshot.data<=wedgeData.length){
                    return Text("${wedgeData[snapshot.data-1].name}",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 24.0));
                  }


                  return Container();

                },
              ),
            ),
            Padding(

              padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
              child: SizedBox(

                width: 500,
                height: 300,

                child: SpinningWheel(

                  PieChart(
                    PieChartData(

                      sections: wedgeData.isEmpty?
                      [PieChartSectionData(
                          color: Color.fromARGB(255, 255,0,0),
                          value: 1,
                          title: "Empty",
                          radius: 120,
                          titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xffffffff)
                      ))]:

                        wedgeData.asMap().map<int,PieChartSectionData>((key, data){
                        final value = PieChartSectionData(
                          color: data.color,
                          value: 1,
                          title: data.name,
                          radius: 120,

                          titleStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffffffff)
                          )
                        );
                        return MapEntry(key,value);
                        }).values.toList(),
                      centerSpaceRadius: 20,
                      sectionsSpace: 0

                    ),

                  ),
                  dividers: wedgeData.isEmpty?5:wedgeData.length,
                  spinResistance: 0.4,
                  onUpdate: winnerController.add,
                  onEnd: winnerController.add,

                  width: 300,
                  height: 300,
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 0),
              child: Row(

                children: [

                  Flexible(
                    child: TextField(

                      decoration:InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 5.0
                          )


                        ),
                        hintText: 'Enter your name'
                      ),
                      controller: nameCon,
                    ),

                  ),
                  Flexible(
                    child: TextField(

                      decoration:InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black,
                                width: 5.0
                            )


                        ),
                        hintText: '# of entries',

                      ),
                      keyboardType:TextInputType.number,
                      controller: entriesCon,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(

              onPressed: addData,
              child: Text("Add Entries"),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(

                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black),

                      )
                  )
              ),
            ),


          ],
        ),
      ),

    );
  }
}
