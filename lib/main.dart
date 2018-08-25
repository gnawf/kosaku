import 'package:app/kosaku.dart';
import 'package:app/injectors/app_injector.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    AppInjector(
      child: Kosaku(),
    ),
  );
}
