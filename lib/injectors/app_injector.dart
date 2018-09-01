import 'package:app/config/routes.dart' as routes;
import 'package:app/farming/growth_calculator.dart';
import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AppInjector extends Injector {
  AppInjector({
    @required Widget child,
  }) : super(child: child, bootstrap: bootstrap);
}

void bootstrap(Inject inject) {
  inject.register(factory: _router, singleton: true);
  inject.register(factory: _httpClient, singleton: true);
  inject.register(factory: _growthCalculator, singleton: true);
}

Router _router(Inject inject) {
  final router = Router.appRouter;
  routes.bootstrap(router);
  return router;
}

Client _httpClient(Inject inject) {
  return Client();
}

GrowthCalculator _growthCalculator(Inject inject) {
  return GrowthCalculator();
}
