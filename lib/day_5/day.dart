import 'dart:isolate';

import 'package:aoc_2023/common/day.dart';
import 'package:aoc_2023/common/index.dart';
import 'package:aoc_2023/common/read_lines.dart';
import 'dart:math' as math;

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

  Set<int> parseSeeds(String line) {
    return line
        .split(':')
        .last
        .split(' ')
        .whereNot(isBlank)
        .map(int.parse)
        .toSet();
  }

  Iterable<int> getSeedRanges(Iterable<int> seeds) {
    return seeds.iterator.asLazyRanges();
  }

  int findLowestLocation(Iterable<int> seeds, Almanac almanac) {
    int lowestLocation = 0x7FFFFFFFFFFFFFFF;
    return seeds.fold(lowestLocation, (previousValue, element) {
      int location = convertThroughCategories(element, almanac);
      if (location < previousValue) {
        return location;
      }
      return previousValue;
    });
  }

  int findLowestLocation2(List<int> seeds, Almanac almanac) {
    int lowestLocation = 0x7FFFFFFFFFFFFFFF;
    final seedRanges = getSeedRanges(seeds);
    seedRanges.forEach((element) {
      int location = convertThroughCategories(element, almanac);
      if (location < lowestLocation) {
        lowestLocation = location;
      }
    });
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

  int convertNumber(int number, List<Mapper> mappers) {
    for (Mapper mapper in mappers) {
      if (mapper.inRange(number)) {
        return mapper.map(number);
      }
    }
    return number;
  }

  void _findLowestLocationIsolate(List<dynamic> arguments) {
    List<int> seeds = arguments[0];
    Almanac almanac = arguments[1];
    SendPort sendPort = arguments[2];

    int result = findLowestLocation2(seeds, almanac);
    sendPort.send(result);
  }

  Future<int> processChunks(List<int> seedsChunk, Almanac almanac) async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_findLowestLocationIsolate,
        [seedsChunk, almanac, receivePort.sendPort]);
    return await receivePort.first as int;
  }

  Future<void> partOne() async {
    final input = await readLines('lib/day_5/input.txt');
    final seeds = parseSeeds(input.first);
    final almanac = parseAlmanac(input.skip(1));
    final result = findLowestLocation(seeds, almanac);
    printResultForPart(part: 1, result: result);
    // 1181555926
  }

  // this is ridiculously slow, but it works eventually...
  // probably should flip the search around look for the location to speed things up
  Future<void> _partTwo() async {
    final input = await readLines('lib/day_5/input.txt');
    final almanac = parseAlmanac(input.skip(1));
    final seeds = parseSeeds(input.first);

    List<Future<int>> futures = [];

    for (var sublist in partition(seeds, seeds.length ~/ 2)) {
      futures.add(processChunks(sublist, almanac));
    }

    List<int> results = await Future.wait(futures);
    int? result = results.reduce(math.min);
    printResultForPart(part: 2, result: result);
  }

  Future<void> partTwo() async {
    final input = await readLines('lib/day_5/input.txt');
    printResultForPart(part: 2, result: 'real one wakes forever');
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

extension on Iterator<int> {
  Iterable<int> asLazyRanges() sync* {
    while (moveNext()) {
      final start = current;
      if (!moveNext()) {
        throw FormatException("Seed ranges should be in pairs");
      }
      final count = current;

      for (int i = 0; i < count; i++) {
        yield start + i;
      }
    }
  }
}
