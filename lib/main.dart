import 'package:flutter/material.dart';
import 'package:on_audio_room/on_audio_room.dart';

import 'package:project/Screens/homescreen.dart';

void main(List<String> args) async {
  await OnAudioRoom().initRoom(); //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
