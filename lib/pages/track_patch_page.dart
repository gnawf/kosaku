import 'dart:async';

import 'package:app/database/dao.dart';
import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:app/models/farming_patch.dart';
import 'package:app/models/produce.dart';
import 'package:app/utils/consumer.dart';
import 'package:app/widgets/produce_view.dart';
import 'package:flutter/material.dart';

typedef String TabValueToString(dynamic value);

class TrackPatchPage extends StatelessWidget {
  TrackPatchPage({
    this.tabValues = ProduceType.values,
    this.tabValueToString = _toString,
  });

  final List<dynamic> tabValues;

  final TabValueToString tabValueToString;

  List<Tab> get tabs {
    return tabValues.map((value) {
      String text = tabValueToString(value);
      return Tab(text: text);
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabValues.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select Produce'),
          elevation: 1.0,
          bottom: TabBar(
            tabs: tabs,
            isScrollable: true,
          ),
        ),
        body: TabBarView(
          children: tabValues.map<Widget>((value) {
            if (value is ProduceType) {
              return ProduceList(filter: value);
            } else {
              throw "Unknown tab value: $value";
            }
          }).toList(growable: false),
        ),
      ),
    );
  }
}

class ProduceList extends StatefulWidget {
  const ProduceList({Key key, this.filter}) : super(key: key);

  final ProduceType filter;

  @override
  State createState() => _ProduceListState();
}

class _ProduceListState extends State<ProduceList> {
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
    if (!mounted) {
      return;
    }

    final typeOrdinal = widget.filter?.index;
    final typeFilter = typeOrdinal == null ? null : {'type': typeOrdinal};
    final produce = await _produceDao.query(where: typeFilter);

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
    return ProduceListView(produce: _produce, track: _track);
  }
}

class ProduceListView extends StatelessWidget {
  const ProduceListView({
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

String _toString(dynamic value) {
  if (value is ProduceType) {
    return produceTypeToString(value);
  } else {
    return "$value";
  }
}
