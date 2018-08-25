import 'package:app/inject/injector.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Kosaku extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final injector = Injector.of(context);
    final router = injector.get<Router>();

    return MaterialApp(
      title: 'Kosaku',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      onGenerateRoute: router.generator,
      debugShowCheckedModeBanner: false,
    );
  }
}
