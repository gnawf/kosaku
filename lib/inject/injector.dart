import 'package:app/inject/inject.dart';
import 'package:flutter/material.dart';

typedef void Bootstrap(Inject inject);

class Injector extends StatefulWidget {
  const Injector({
    @required this.bootstrap,
    @required this.child,
    Key key,
  }) : super(key: key);

  final Bootstrap bootstrap;

  final Widget child;

  static Inject of(BuildContext context) {
    const matcher = TypeMatcher<_InjectState>();
    final ancestor = context.ancestorStateOfType(matcher);
    return ancestor is _InjectState ? ancestor.inject : null;
  }

  @override
  State createState() => _InjectState();
}

class _InjectState extends State<Injector> {
  Inject inject;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (inject == null) {
      final parent = Injector.of(context);
      inject = Inject(parent);
      // Setup inject
      widget.bootstrap(inject);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
