import 'dart:async';

import 'package:app/farming/growth_calculator.dart';
import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:app/models/farming_patch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatchTrackerView extends StatefulWidget {
  const PatchTrackerView({
    Key key,
    @required this.patch,
  })  : assert(patch != null),
        super(key: key);

  final FarmingPatch patch;

  @override
  PatchTrackerViewState createState() => new PatchTrackerViewState();
}

class PatchTrackerViewState extends State<PatchTrackerView> {
  Inject _inject;

  GrowthCalculator _growthCalculator;

  Future<Null> _tick() async {
    if (!mounted) {
      return;
    }

    // Invalidate the view to redraw the progress bar
    setState(() {});

    // Schedule the next tick
    final tickLength = Duration(seconds: 1);
    await Future.delayed(tickLength, _tick);
  }

  void _init() {
    _growthCalculator = _inject.get();

    _tick();
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
    final now = DateTime.now();
    final patch = widget.patch;

    // Calculate progress bar value
    final finishAt = _growthCalculator.estimate(patch);
    final duration = finishAt.difference(patch.plantedAt);
    final elapsed = now.difference(patch.plantedAt);
    final progress = elapsed.inSeconds / duration.inSeconds;

    // Generate finish time to display - include day of week if necessary
    final sameDay = finishAt.day == patch.plantedAt.day;
    final dateFormat = sameDay ? 'h:mm a' : 'EEEE h:mm a';
    final finishAtText = DateFormat(dateFormat).format(finishAt);

    return Card(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              bottom: 4.0,
            ),
            child: ListTile(
              leading: Container(
                width: 32.0,
                height: 32.0,
                child: Image(
                  image: AssetImage(
                    'assets/sprites/items/${patch.produce.itemId}.png',
                  ),
                ),
              ),
              title: Text(patch.produce.name),
              subtitle: Text('Done at $finishAtText'),
            ),
          ),
          LinearProgressIndicator(
            value: progress,
          ),
        ],
      ),
    );
  }
}
