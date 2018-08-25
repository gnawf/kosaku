import 'package:app/config/routes.dart' as routes;
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
  // Router for in-app navigation
  inject.register(factory: _router, singleton: true);
  // Http client
  inject.register(factory: _httpClient, singleton: true);
}

Router _router(Inject inject) {
  final router = Router.appRouter;
  routes.bootstrap(router);
  return router;
}

Client _httpClient(Inject inject) {
  return Client();
}
