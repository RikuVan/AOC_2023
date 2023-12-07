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

(List<int>, List<int>) parseInput(List<String> lines) {
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

class Day6 with Day {
  @override
  final dayNumber = 6;

  Future<void> partOne() async {
    final lines = await readLines('lib/day_6/input.txt');
    final (times, distances) = parseInput(lines);
    final result = zip([times, distances]).fold(1, (total, element) {
      total *= findTotalPossibleWins(element.first, element.last);
      return total;
    });
    printResultForPart(part: 1, result: result);
  }
}
