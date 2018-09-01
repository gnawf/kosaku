import 'package:app/pages/patch_tracker_page.dart';
import 'package:app/pages/track_patch_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';

void bootstrap(Router router) {
  router.define('/', handler: Handler(handlerFunc: _home));
  router.define('/track/new', handler: Handler(handlerFunc: _trackNew));
}

Widget _home(BuildContext context, params) {
  return PatchTrackerPage();
}

Widget _trackNew(BuildContext context, params) {
  return TrackPatchPage();
}
