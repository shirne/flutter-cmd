import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  Process process;
  TextEditingController cmdController =
  TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    Process.start('cmd.exe', []).then((value) {
      process = value;
      process.stdout.listen(onMessage);
      setState(() {
        messages.add('cmd ok');
      });
    });
  }

  @override
  dispose(){
    process.kill();
    process = null;
    super.dispose();
  }

  setCmd(String cmd){
    if(cmd == 'clear'){
      messages.clear();
    }
    if(process != null){
      process.stdin.writeln(cmd);
    }
  }

  onMessage(List<int> event){
    String lines = String.fromCharCodes(event).trim();
    setState(() {
      messages+= lines.split('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WillPopScope(
        onWillPop: (){
          if(process!=null)process.kill();
          return Future.value(true);
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Cmd:',
                  ),
                  SizedBox(width: 150,
                    child:TextField(
                      controller: cmdController,
                    ),
                  ),

                  ElevatedButton(onPressed: (){
                    setCmd(cmdController.text);
                    cmdController.text = '';
                  }, child: Text('Send')),
                  SizedBox(width: 10,),
                  ElevatedButton(onPressed: (){
                    setCmd('clear');
                  }, child: Text('Clear')),
                ],
              ),
              Expanded(
                child: ListView(
                  children: messages.map<Widget>((item)=>Text(item)).toList(),
                ),
              ),

            ],
          ),
        ),
      ) ,
    );
  }
}
