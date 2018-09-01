import 'dart:async';

import 'package:app/database/dao.dart';
import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:app/models/farming_patch.dart';
import 'package:app/models/produce.dart';
import 'package:app/utils/consumer.dart';
import 'package:app/widgets/produce_view.dart';
import 'package:flutter/material.dart';

class TrackPatchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Produce'),
        elevation: 1.0,
      ),
      body: TrackPatchBody(),
    );
  }
}

class TrackPatchBody extends StatefulWidget {
  @override
  State createState() => _TrackPatchBodyState();
}

class _TrackPatchBodyState extends State<TrackPatchBody> {
  Inject _inject;

  Dao<Produce> _produceDao;

  Dao<FarmingPatch> _farmingPatchDao;

  List<Produce> _produce = [];

  Future<Null> _track(Produce produce) async {
    final now = DateTime.now();

    // Generate id based on produce and current time
    final id = hashValues(produce, now);

    final patch = FarmingPatch(
      id: id,
      plantedAt: now,
      produceId: produce.id,
      produce: produce,
    );

    await _farmingPatchDao.upsert(patch);

    Navigator.of(context).pop(patch);
  }

  Future<Null> _load() async {
    final produce = await _produceDao.query();

    setState(() => _produce = produce);
  }

  void _init() {
    _produceDao = _inject.get();
    _farmingPatchDao = _inject.get();

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
  Widget build(BuildContext context) {
    return ProduceList(produce: _produce, track: _track);
  }
}

class ProduceList extends StatelessWidget {
  const ProduceList({
    Key key,
    @required this.produce,
    this.track,
  })  : assert(produce != null),
        super(key: key);

  final List<Produce> produce;

  final Consumer<Produce> track;

  Widget _itemBuilder(BuildContext context, int index) {
    // Default view
    Widget view = ProduceView(
      produce: produce[index],
      onTap: track == null ? null : () => track(produce[index]),
    );

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
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        vertical: 18.0,
        horizontal: 16.0,
      ),
      itemBuilder: _itemBuilder,
      itemCount: produce.length,
    );
  }
}
