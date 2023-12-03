import 'dart:io';

import 'package:path/path.dart';

Future<List<String>> readLines(String relativePath) async {
  final filePath = join(Directory.current.path, relativePath);
  final file = File(filePath);
  return file.readAsString().then((String contents) {
    return contents.split("\n").where((line) => line.isNotEmpty).toList();
  });
}
