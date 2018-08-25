import 'package:app/inject/inject.dart';
import 'package:test/test.dart';

void main() {
  test('singleton factory is only invoked once', () {
    final inject = Inject();

    var invocations = 0;

    inject.register<int>(singleton: true, factory: (x) => invocations++);

    inject.get<int>();
    inject.get<int>();
    inject.get<int>();

    expect(invocations, equals(1));
  });
  test('non-singleton factory is invoked as required', () {
    final inject = Inject();

    var invocations = 0;

    inject.register<int>(singleton: false, factory: (x) => invocations++);

    inject.get<int>();
    inject.get<int>();
    inject.get<int>();

    expect(invocations, equals(3));
  });
  test('child inherits parent dependencies', () {
    final parent = Inject();
    parent.register<int>(value: 1);

    final child = Inject(parent);

    expect(child.get<int>(), equals(1));
  });
  test('child can override parent dependencies', () {
    final parent = Inject();
    parent.register<int>(value: 1);

    final child = Inject(parent);
    child.register<int>(value: 2);

    expect(parent.get<int>(), equals(1));
    expect(child.get<int>(), equals(2));
  });
  test('qualified dependencies', () {
    final inject = Inject();
    inject.register<int>(value: 1);
    inject.register<int>(value: 2, qualifier: 'test');

    expect(inject.get<int>(), equals(1));
    expect(inject.get<int>(qualifier: 'test'), equals(2));
  });
  test('generic dependencies', () {
    final inject = Inject();
    inject.register<List<String>>(value: ['test']);
    inject.register<List<int>>(value: [1]);

    expect(inject.get<List<String>>(), equals(['test']));
    expect(inject.get<List<int>>(), equals([1]));
  });
  test('symbols work as qualifiers', () {
    final inject = Inject();
    inject.register<int>(value: 1);
    inject.register<int>(value: 2, qualifier: #test1);

    expect(inject.get<int>(), equals(1));
    expect(inject.get<int>(qualifier: #test1), equals(2));
    expect(inject.get<int>(qualifier: #test2), isNull);
  });
  test('generic inference works', () {
    final inject = Inject();
    inject.register(value: 1);

    int test(int input) => input;

    expect(test(inject.get()), equals(1));
  });
}
