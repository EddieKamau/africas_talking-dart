import 'package:africas_talking/africas_talking.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {

    setUp(() {
      // Additional setup goes here.
    });

    test('url encode', () {
      expect(encodeUrl('url', {'name': 'Me', 'age': 3}), 'url?name=Me&age=3');
    });
  });
}
