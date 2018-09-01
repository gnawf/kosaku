import 'dart:async';

import 'package:app/database/dao.dart';
import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:app/models/farming_patch.dart';
import 'package:app/widgets/patch_tracker_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class PatchTrackerPage extends StatelessWidget {
  const PatchTrackerPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farming Tracker'),
        elevation: 1.0,
      ),
      body: PackTrackerBody(),
      floatingActionButton: TrackPatchFab(),
    );
  }
}

class PackTrackerBody extends StatefulWidget {
  const PackTrackerBody({Key key}) : super(key: key);

  @override
  State createState() => _PackTrackerBodyState();
}

class _PackTrackerBodyState extends State<PackTrackerBody> {
  Inject _inject;

  Dao<FarmingPatch> _farmingPatchDao;

  var _patches = <FarmingPatch>[];

  Future<Null> _load() async {
    final patches = await _farmingPatchDao.query(orderBy: 'plantedAt');

    setState(() => _patches = patches);
  }

  void _init() {
    _farmingPatchDao = _inject.get();

    _farmingPatchDao.addListener(_load);

    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inject == null) {
      _inject = Injector.of(context);
      _init();
    }
  }

  @override
  void dispose() {
    super.dispose();

    _farmingPatchDao.removeListener(_load);
  }

  @override
  Widget build(BuildContext context) {
    return PatchTrackers(
      patches: _patches,
    );
  }
}

class PatchTrackers extends StatelessWidget {
  const PatchTrackers({
    Key key,
    @required this.patches,
  })  : assert(patches != null),
        super(key: key);

  final List<FarmingPatch> patches;

  Widget _itemBuilder(BuildContext context, int index) {
    // Default view
    Widget view = PatchTrackerView(patch: patches[index]);

    // Add top padding to separate children
    if (index != 0) {
      view = Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
        ),
        child: view,
      );
    }

    return view;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 256.0 + 128.0 + 64.0,
        ),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(
            vertical: 18.0,
            horizontal: 16.0,
          ),
          itemBuilder: _itemBuilder,
          itemCount: patches.length,
        ),
      ),
    );
  }
}

class TrackPatchFab extends StatefulWidget {
  @override
  State createState() => _TrackPatchFabState();
}

class _TrackPatchFabState extends State<TrackPatchFab> {
  Inject _inject;

  Router _router;

  void _track() {
    _router.navigateTo(context, 'track/new');
  }

  void _init() {
    _router = _inject.get();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_inject == null) {
      _inject = Injector.of(context);
      _init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: _track,
      label: Text('Track Patch'),
      icon: Icon(Icons.timer),
      elevation: 3.0,
      highlightElevation: 6.0,
    );
  }
}
