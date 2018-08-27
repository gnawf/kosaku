import 'package:app/injectors/app_injector.dart';
import 'package:app/injectors/database_injector.dart';
import 'package:app/kosaku.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    AppInjector(
      child: DatabaseInjector(
        child: Kosaku(),
      ),
    ),
  );
}
