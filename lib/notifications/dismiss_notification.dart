import 'package:flutter/material.dart';

class DismissNotification<T> extends Notification {
  DismissNotification({this.what});

  final T what;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DismissNotification &&
          runtimeType == other.runtimeType &&
          what == other.what;

  @override
  int get hashCode => what.hashCode;

  @override
  String toString() {
    return 'DismissNotification{what: $what}';
  }
}
