import 'package:flutter_test/flutter_test.dart';
import 'package:pokemate/app/app.locator.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('TeamBuilderViewModel Tests -', () {
    setUp(() => registerServices());
    tearDown(() => locator.reset());
  });
}
