import 'package:aoc_2023/common/day.dart';
import 'package:aoc_2023/common/index.dart';
import 'package:aoc_2023/common/read_lines.dart';

typedef Almanac = Map<String, List<Mapper>>;

List<String> categories = [
  'soil',
  'fertilizer',
  'water',
  'light',
  'temperature',
  'humidity',
  'location'
];

class Day5 with Day {
  @override
  final dayNumber = 5;

  Almanac parseAlmanac(Iterable<String> lines) {
    Almanac almanac = {};
    String currentCategory = '';
    for (final line in lines) {
      if (line.contains("map:")) {
        currentCategory = line.split(' map:').first;
        almanac[currentCategory] = [];
      } else if (line.isNotEmpty) {
        final parts = line.split(" ").map(int.parse).toList();
        final Mapper mapper = Mapper(
          destStart: parts[0],
          sourceStart: parts[1],
          rangeLength: parts[2],
        );
        almanac[currentCategory]!.add(mapper);
      }
    }
    return almanac;
  }

  List<int> parseSeeds(String line) {
    return line
        .split(':')
        .last
        .split(' ')
        .whereNot(isBlank)
        .map(int.parse)
        .toList();
  }

  int findLowestLocation(List<int> seeds, Almanac almanac) {
    int lowestLocation = 0x7FFFFFFFFFFFFFFF;
    for (int seed in seeds) {
      int location = convertThroughCategories(seed, almanac);
      if (location < lowestLocation) {
        lowestLocation = location;
      }
    }
    return lowestLocation;
  }

  int convertThroughCategories(int number, Almanac almanac) {
    String currentCategory = 'seed';

    for (String nextCategory in categories) {
      String mapKey = '$currentCategory-to-$nextCategory';
      number = convertNumber(number, almanac[mapKey]!);
      currentCategory = nextCategory;
    }

    return number;
  }

  int convertNumber(int number, List<Mapper> map) {
    for (Mapper mapper in map) {
      if (mapper.inRange(number)) {
        return mapper.map(number);
      }
    }
    return number;
  }

  Future<void> partOne() async {
    final input = await readLines('lib/day_5/input.txt');
    final seeds = parseSeeds(input.first);
    final almanac = parseAlmanac(input.skip(1));
    final result = findLowestLocation(seeds, almanac);
    printResultForPart(part: 1, result: result);
  }
}

class Mapper {
  Mapper({
    required this.destStart,
    required this.sourceStart,
    required this.rangeLength,
  });
  final int destStart;
  final int sourceStart;
  final int rangeLength;

  bool inRange(int number) {
    return number >= sourceStart && number < sourceStart + rangeLength;
  }

  int map(int number) {
    return destStart + (number - sourceStart);
  }
}
