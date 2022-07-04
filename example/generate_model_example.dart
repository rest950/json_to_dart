import 'dart:io';
import "package:path/path.dart" show dirname, join, normalize;
import 'package:recase/recase.dart';
import '../lib/json_to_dart.dart';

String _scriptPath() {
  var script = Platform.script.toString();
  if (script.startsWith("file://")) {
    script = script.substring(7);
  } else {
    final idx = script.indexOf("file:/");
    script = script.substring(idx + 5);
  }
  return script;
}

main() {
  final classGenerator = new ModelGenerator('Sample');
  final currentDirectory = dirname(_scriptPath());
  final filePath = normalize(join(currentDirectory, 'sample.json'));
  final jsonRawData = new File(filePath).readAsStringSync();
  // DartCode dartCode = classGenerator.generateDartClasses(jsonRawData);
  List<DartCode> dartCodeFiles =
      classGenerator.generateDartClassesEach(jsonRawData);
  dartCodeFiles.forEach((element) async {
    print(element.code);
    final currentDirectory = dirname(_scriptPath()) + '/gen/';
    final filePath = normalize(join(
        currentDirectory, '${element.className?.snakeCase ?? 'no_name'}.dart'));
    await File(filePath).writeAsString(element.code);
  });
  // print(dartCode.code);
}
