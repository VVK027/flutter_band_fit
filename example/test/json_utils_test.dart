import 'package:flutter_band_fit_app/core/utils/json_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('JsonUtils', () {
    test('asMap normalizes Map and Map<String, dynamic>', () {
      expect(JsonUtils.asMap(<String, dynamic>{'a': 1}), {'a': 1});
      expect(
        JsonUtils.asMap(<String, Object?>{'b': 2}),
        <String, dynamic>{'b': 2},
      );
      expect(JsonUtils.asMap(null), isEmpty);
      expect(JsonUtils.asMap('text'), isEmpty);
    });

    test('asList copies list or returns empty', () {
      expect(JsonUtils.asList([1, 2]), [1, 2]);
      expect(JsonUtils.asList('nope'), isEmpty);
    });

    test('asBool handles bool, num, and string forms', () {
      expect(JsonUtils.asBool(true), isTrue);
      expect(JsonUtils.asBool(1), isTrue);
      expect(JsonUtils.asBool(0), isFalse);
      expect(JsonUtils.asBool('true'), isTrue);
      expect(JsonUtils.asBool('0'), isFalse);
      expect(JsonUtils.asBool(null), isFalse);
    });

    test('asString and numeric parsers use fallbacks', () {
      expect(JsonUtils.asString(null), '');
      expect(JsonUtils.asString(42), '42');
      expect(JsonUtils.asInt('7'), 7);
      expect(JsonUtils.asInt('bad', 3), 3);
      expect(JsonUtils.asDouble('1.5'), 1.5);
      expect(JsonUtils.asDouble('bad', 2.5), 2.5);
    });
  });
}
