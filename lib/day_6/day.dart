import 'package:aoc_2023/common/day.dart';
import 'package:aoc_2023/common/read_lines.dart';
import 'package:quiver/iterables.dart';

int findTotalPossibleWins(int time, int distance) {
  int wins = 0;
  for (int chargeTime = 1; chargeTime < time; chargeTime++) {
    final travelTime = time - chargeTime;
    final travelDistance = chargeTime * travelTime;
    if (travelDistance > distance) {
      wins++;
    }
  }
  return wins;
}

(List<int>, List<int>) parseInputForOne(List<String> lines) {
  final times = lines.first
      .replaceAll('Time:', '')
      .split(' ')
      .where((i) => i.isNotEmpty)
      .map((i) => i.trim())
      .map(int.parse)
      .toList();
  final distances = lines.last
      .replaceAll('Distance:', '')
      .split(' ')
      .where((i) => i.isNotEmpty)
      .map((i) => i.trim())
      .map(int.parse)
      .toList();
  return (times, distances);
}

(int, int) parseInputForTwo(List<String> lines) {
  final time = lines.first
      .replaceAll('Time:', '')
      .split(' ')
      .where((i) => i.isNotEmpty)
      .map((i) => i.trim())
      .join('');
  final distance = lines.last
      .replaceAll('Distance:', '')
      .split(' ')
      .where((i) => i.isNotEmpty)
      .map((i) => i.trim())
      .join('');
  return (int.parse(time), int.parse(distance));
}

class Day6 with Day {
  @override
  final dayNumber = 6;

  Future<void> partOne() async {
    final lines = await readLines('lib/day_6/input.txt');
    final (times, distances) = parseInputForOne(lines);
    final result = zip([times, distances]).fold(1, (total, element) {
      total *= findTotalPossibleWins(element.first, element.last);
      return total;
    });
    printResultForPart(part: 1, result: result);
  }

  Future<void> partTwo() async {
    final lines = await readLines('lib/day_6/input.txt');
    final (time, distance) = parseInputForTwo(lines);
    final result = findTotalPossibleWins(time, distance);
    printResultForPart(part: 2, result: result);
  }
}
