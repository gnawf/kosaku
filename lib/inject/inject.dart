import 'package:synchronized/synchronized.dart';

typedef T Factory<T>(Inject inject);

class Qualified {
  const Qualified(this.type, this.qualifier)
      : assert(type != null),
        assert(qualifier != null);

  final Type type;

  final Object qualifier;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Qualified &&
            runtimeType == other.runtimeType &&
            type == other.type &&
            qualifier == other.qualifier;
  }

  @override
  int get hashCode => type.hashCode ^ qualifier.hashCode;

  @override
  String toString() => 'Qualified{type: $type, qualifier: $qualifier}';
}

class Inject {
  Inject([this._parent]);

  final Inject _parent;

  final Map<dynamic, dynamic> _dependencies = {};

  void register<T>({
    T value,
    Factory<T> factory,
    Object qualifier,
    bool singleton = false,
  }) {
    // Ensure that only one of value or factory is set
    assert((value != null) != (factory != null));

    final key = _key(T, qualifier);

    _dependencies[key] = value ?? (singleton ? _singleton(factory) : factory);
  }

  T get<T>({Object qualifier}) {
    final key = _key(T, qualifier);

    if (_dependencies.containsKey(key)) {
      final dependency = _dependencies[key];
      if (dependency is Factory) {
        return dependency(this);
      } else {
        return dependency;
      }
    }

    // Delegate lookup to parent if we can't find it
    if (_parent != null) {
      return _parent.get<T>(qualifier: qualifier);
    }

    return null;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Inject &&
            runtimeType == other.runtimeType &&
            _parent == other._parent &&
            _dependencies == other._dependencies;
  }

  @override
  int get hashCode => _parent.hashCode ^ _dependencies.hashCode;

  @override
  String toString() {
    return 'Inject{parent: $_parent, dependencies: $_dependencies}';
  }
}

Factory<T> _singleton<T>(Factory<T> factory) {
  final lock = Lock();

  T value;

  return (Inject inject) {
    if (value == null) {
      lock.synchronized(() {
        if (value == null) {
          value = factory(inject);
        }
      });
    }
    return value;
  };
}

dynamic _key(Type type, [Object qualifier]) {
  return qualifier == null ? type : Qualified(type, qualifier);
}
