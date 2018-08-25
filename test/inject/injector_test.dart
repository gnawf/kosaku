import 'package:app/inject/inject.dart';
import 'package:app/inject/injector.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('inheritance', (tester) async {
    var tested = false;

    final asserts = Builder(
      builder: (BuildContext context) {
        final inject = Injector.of(context);

        expect(inject.get<int>(), equals(1));
        expect(inject.get<String>(), equals('child'));

        tested = true;

        return Container();
      },
    );

    await tester.pumpWidget(
      Injector(
        bootstrap: (Inject inject) {
          inject.register<int>(value: 1);
          inject.register<String>(value: 'parent');
        },
        child: Injector(
          bootstrap: (Inject inject) {
            inject.register<String>(value: 'child');
          },
          child: asserts,
        ),
      ),
    );

    expect(tested, isTrue);
  });
}
