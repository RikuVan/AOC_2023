import 'package:aoc_2023/common/day.dart';
import 'package:aoc_2023/common/read_lines.dart';

const numberNameMap = {
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9
};

class Day1 with Day {
  Day1();

  @override
  final dayNumber = 1;

  bool isNumber(String char) => char.contains(RegExp(r'\d'));

  int sumFromCombinedFirstAndLastDigits(List<String> lines) {
    int total = 0;
    for (final line in lines) {
      var digits = line.split('').where(isNumber).toList();

      if (digits.isEmpty) {
        throw Exception('No digits found in line');
      }

      String first = digits.first;
      String last = digits.length > 1 ? digits.last : first;

      total += int.parse(first + last);
    }

    return total;
  }

  List<String> replacesNamesWithDigits(List<String> lines) {
    List<String> newLines = [];
    for (final line in lines) {
      StringBuffer newLine = StringBuffer();
      for (int i = 0; i < line.length; i++) {
        String character = line[i];
        if (isNumber(character)) {
          newLine.write(character);
        } else {
          String restOfLine = line.substring(i);
          for (final name in numberNameMap.keys) {
            if (restOfLine.startsWith(name)) {
              newLine.write(numberNameMap[name].toString());
              break;
            }
          }
        }
      }
      newLines.add(newLine.toString());
    }
    return newLines;
  }

  Future<void> partOne() async {
    final lines = await readLines('lib/day_1/input.txt');
    final total = sumFromCombinedFirstAndLastDigits(lines);

    printResultForPart(part: 1, result: total);
  }

  Future<void> partTwo() async {
    final lines = await readLines('lib/day_1/input.txt');
    final linesWithReplacedNames = replacesNamesWithDigits(lines);
    final total = sumFromCombinedFirstAndLastDigits(linesWithReplacedNames);

    printResultForPart(part: 2, result: total);
  }
}
