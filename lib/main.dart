import 'package:flutter/material.dart';

import 'firebase_CRUD.dart';

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FireBase",
      home: Home(),
    );
  }
}
