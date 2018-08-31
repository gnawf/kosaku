import 'package:app/inject/injector.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Kosaku extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final injector = Injector.of(context);
    final router = injector.get<Router>();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'Kosaku',
      theme: ThemeData(
        primarySwatch: MaterialColor(
          Colors.white.value,
          const <int, Color>{
            50: Color.fromARGB(255, 250, 250, 250),
            100: Color.fromARGB(255, 245, 245, 245),
            200: Color.fromARGB(255, 238, 238, 238),
            300: Color.fromARGB(255, 224, 224, 224),
            350: Color.fromARGB(255, 214, 214, 214),
            400: Color.fromARGB(255, 189, 189, 189),
            500: Color.fromARGB(255, 158, 158, 158),
            600: Color.fromARGB(255, 117, 117, 117),
            700: Color.fromARGB(255, 97, 97, 97),
            800: Color.fromARGB(255, 66, 66, 66),
            850: Color.fromARGB(255, 48, 48, 48),
            900: Color.fromARGB(255, 33, 33, 33),
          },
        ),
        accentColor: Colors.deepPurpleAccent,
        platform: TargetPlatform.iOS,
      ),
      onGenerateRoute: router.generator,
      debugShowCheckedModeBanner: false,
    );
  }
}
