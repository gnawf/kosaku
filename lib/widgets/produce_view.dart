import 'package:app/models/produce.dart';
import 'package:flutter/material.dart';

class ProduceView extends StatelessWidget {
  const ProduceView({
    Key key,
    @required this.produce,
    this.onTap,
  })  : assert(produce != null),
        super(key: key);

  final Produce produce;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Container(
            width: 32.0,
            height: 32.0,
            child: Image(
              image: AssetImage(
                'assets/sprites/items/${produce.itemId}.png',
              ),
            ),
          ),
          title: Text(produce.name),
          subtitle: Text('${produce.tickCount}x${produce.tickRate} minutes'),
        ),
      ),
    );
  }
}
