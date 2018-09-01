import 'package:app/pages/patch_tracker_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

void bootstrap(Router router) {
  router.define('/', handler: Handler(handlerFunc: _home));
}

Widget _home(BuildContext context, params) {
  return PatchTrackerPage();
}
