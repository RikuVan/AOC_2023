import 'dart:math';

import 'package:aoc_2023/common/read_lines.dart';

// 25571
class Card {
  Card({required this.cardNumber, required this.winners, required this.picked});

  final int cardNumber;
  final Set<int> winners;
  final Set<int> picked;

  int get numberOfWinnersPicked => winners.intersection(picked).length;

  List<int> toRange() {
    return List.generate(numberOfWinnersPicked, (i) => i + 1);
  }

  @override
  String toString() {
    return 'Card{cardNumber: $cardNumber, winners: ${winners.join(', ')}, picked: ${picked.join(', ')}';
  }
}

class Day4 {
  static List<Card> _linesToCards(List<String> input) {
    return input.map((line) {
      final dayAndLines = line.split(":");
      int cardNumber = int.parse(dayAndLines.first.substring(5));
      final lines = dayAndLines.last.split(' | ').map((cardStrings) {
        return cardStrings
            .split(' ')
            .map((number) => number.trim())
            .where((number) => number.isNotEmpty)
            .toList();
      }).toList();
      return (cardNumber, lines);
    }).map((value) {
      final (cardNumber, sets) = value;
      return Card(
        cardNumber: cardNumber,
        winners: sets.first.map(int.parse).toSet(),
        picked: sets.last.map(int.parse).toSet(),
      );
    }).toList();
  }

  static Future<void> partOne() async {
    final input = await readLines('lib/day_4/input.txt');
    final cards = _linesToCards(input);
    final result = cards
        .map((card) => card.numberOfWinnersPicked == 0
            ? 0
            : pow(2, card.numberOfWinnersPicked - 1))
        .reduce((value, element) => value + element);
    print('Day 4 part 1');
    print(result);
    // 25571
  }

  static Future<void> partTwo() async {
    final input = await readLines('lib/day_4/input.txt');
    final cards = _linesToCards(input);
    final cardCounts = cards.map((card) => 1).toList();
    cards.asMap().entries.forEach((entry) {
      entry.value.toRange().forEach((number) {
        cardCounts[entry.key + number] += cardCounts[entry.key];
      });
    });
    final result = cardCounts.reduce((value, element) => value + element);
    print('Day 4 part 2');
    print(result);
    // 8805731
  }
}
