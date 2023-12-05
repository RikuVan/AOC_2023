import 'dart:math';

import 'package:aoc_2023/common/read_lines.dart';

class Card {
  Card({required this.winners, required this.picked});

  final Set<int> winners;
  final Set<int> picked;

  int get numberOfWinnersPicked => winners.intersection(picked).length;

  @override
  String toString() {
    return 'Card{winners: ${winners.join(', ')}, picked: ${picked.join(', ')}';
  }
}

class Day4 {
  static Future<void> partOne() async {
    final input = await readLines('lib/day_4/input.txt');
    final cards = input.map((line) {
      return line.split(':').last.split(' | ').map((cardStrings) {
        return cardStrings
            .split(' ')
            .map((number) => number.trim())
            .where((number) => number.isNotEmpty)
            .toList();
      }).toList();
    }).map((sets) => Card(
          winners: sets.first.map(int.parse).toSet(),
          picked: sets.last.map(int.parse).toSet(),
        ));
    print('Day 4 part 1');
    print(cards
        .map((c) => c.numberOfWinnersPicked)
        .map((number) => number == 0 ? 0 : pow(2, number - 1))
        .reduce((x, y) => x + y));
  }
}
