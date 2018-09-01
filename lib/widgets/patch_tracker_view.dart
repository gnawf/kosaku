import 'package:app/farming/growth_calculator.dart';
import 'package:app/inject/injector.dart';
import 'package:app/models/farming_patch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PatchTrackerView extends StatelessWidget {
  const PatchTrackerView({
    Key key,
    @required this.patch,
  })  : assert(patch != null),
        super(key: key);

  final FarmingPatch patch;

  @override
  Widget build(BuildContext context) {
    final growthCalculator = Injector.of(context).get<GrowthCalculator>();

    final now = DateTime.now();
    final finishAt = growthCalculator.estimate(patch);
    final duration = finishAt.difference(patch.plantedAt);
    final elapsed = now.difference(patch.plantedAt);
    final progress = elapsed.inSeconds / duration.inSeconds;
    final finishAtText = DateFormat('h:mm a').format(finishAt);

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
