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

main(List<String> args) {
  final rootClassName = args.isNotEmpty ? args.first : 'noName';
  final classGenerator = new ModelGenerator(rootClassName);
  final currentDirectory = dirname(_scriptPath());
  final filePath = normalize(join(currentDirectory, 'input.json'));
  final jsonRawData = new File(filePath).readAsStringSync();
  // DartCode dartCode = classGenerator.generateDartClasses(jsonRawData);
  List<DartCode> dartCodeFiles =
      classGenerator.generateDartClassesEach(jsonRawData);
  final genDirectory = dirname(_scriptPath()) + '/gen/';
  final dir = new Directory(genDirectory);
  dir.listSync().forEach((element) {
    element.delete();
  });
  dartCodeFiles.forEach((element) async {
    print(element.code);
    final filePath = normalize(join(
        genDirectory, '${element.className?.snakeCase ?? 'no_name'}.dart'));
    await File(filePath).writeAsString(element.code);
  });
  // print(dartCode.code);
}
