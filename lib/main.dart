import 'package:flutter/material.dart';
import 'dart:isolate';

import 'package:isolatetest/user.dart';

void main() {
  runApp(MyApp());
  _initializeIsolate();
}

User? result;
Isolate? _isolate;
SendPort? isolateSendPort;
final ReceivePort receivePort = ReceivePort();

void _initializeIsolate() async {
  _isolate = await Isolate.spawn(_isolatedFunction, receivePort.sendPort);
  receivePort.listen((data) {
    if (data is SendPort) {
      isolateSendPort = data;
    } else if (data is Map<String,dynamic>) {
      result = User.fromMap(data);
    }
  });
}

void _startCalculation(User user) {
  isolateSendPort?.send(['start', user]);
}

void _isolatedFunction(SendPort sendPort) {
  // 연산 시작을 위한 메시지 수신 대기
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  receivePort.listen((message) {
    if (message[0] == 'start') {
      // 여기서 User 객체를 생성 및 채움
      User user = User('John', 'New York', ['Hello', 'World']);
      sendPort.send(user.toMap());
    }
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Isolate Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Isolate Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Result: ${result?.city ?? "Not calculated yet."}'),
            ElevatedButton(
              onPressed: () {
                _startCalculation(User.empty());
                setState(() {});
              },
              child: Text('Calculate 1 + 1 in Isolate'),
            )
          ],
        ),
      ),
    );
  }
}