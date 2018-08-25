import 'package:flutter/material.dart';

class AccentRaisedButton extends StatelessWidget {
  const AccentRaisedButton({
    Key key,
    @required this.child,
    this.onPressed,
  })  : assert(child != null),
        super(key: key);

  final Widget child;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.accentColor;

    return RaisedButton(
      child: DefaultTextStyle(
        style: theme.accentTextTheme.button,
        child: child,
      ),
      color: accentColor,
      onPressed: onPressed,
    );
  }
}
