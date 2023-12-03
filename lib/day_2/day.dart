import 'package:aoc_2023/common/read_lines.dart';

class Reveal {
  Reveal({this.red = 0, this.blue = 0, this.green = 0});

  final int red;
  final int blue;
  final int green;

  factory Reveal.fromString(String str) {
    Map<String, int> map = {};
    str.split(', ').forEach((colorSection) {
      final color =
          colorSection.split(' ').where((value) => value.isNotEmpty).toList();
      map[color[1]] = int.parse(color[0]);
    });

    return Reveal(
      red: map['red'] ?? 0,
      blue: map['blue'] ?? 0,
      green: map['green'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'Reveal{red: $red, blue: $blue, green: $green}';
  }
}

class Game {
  Game({required this.id, required this.reveals});
  final int id;
  List<Reveal> reveals = [];

  Reveal get maxReveal {
    int maxRed = 0, maxBlue = 0, maxGreen = 0;

    for (Reveal reveal in reveals) {
      if (reveal.red > maxRed) maxRed = reveal.red;
      if (reveal.blue > maxBlue) maxBlue = reveal.blue;
      if (reveal.green > maxGreen) maxGreen = reveal.green;
    }
    return Reveal(red: maxRed, blue: maxBlue, green: maxGreen);
  }

  bool isPossible(Reveal reveal) {
    return reveal.red >= maxReveal.red &&
        reveal.blue >= maxReveal.blue &&
        reveal.green >= maxReveal.green;
  }

  factory Game.fromString(String line) {
    final parts = line.split(':');
    final id = int.parse(parts[0].substring(5));
    final reveals = parts[1]
        .split('; ')
        .map((reveal) => Reveal.fromString(reveal))
        .toList();
    return Game(id: id, reveals: reveals);
  }

  @override
  String toString() {
    return 'Game{id: $id, reveals: $reveals}';
  }
}

class Day2 {
  static Future<void> partOne() async {
    final testGame = Reveal(blue: 14, green: 13, red: 12);
    final input = await readLines('lib/day_2/input.txt');
    final games = input.map((line) => Game.fromString(line)).toList();
    final possibleGames = games.where((game) => game.isPossible(testGame));
    print("Day 2 Part 1");
    print(possibleGames
        .map((game) => game.id)
        .reduce((value, element) => value + element));
  }
}
