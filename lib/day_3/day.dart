import 'dart:async';

import 'package:aoc_2023/common/read_lines.dart';
import 'package:equatable/equatable.dart';

class Range extends Equatable {
  final int start;
  final int end;

  Range(this.start, this.end);

  List<int> toList() {
    return List.generate(end - start + 1, (i) => start + i);
  }

  @override
  String toString() {
    return 'Range(start: $start, end: $end)';
  }

  @override
  List<Object?> get props => [start, end];
}

extension RangeExtension on Range {
  bool contains(int value) {
    return toList().contains(value);
  }
}

sealed class Element extends Equatable {}

class Number extends Element {
  Number({required this.value, required this.xRange, required this.y});

  final int value;
  final Range xRange;
  final int y;

  Range get expandedColumn => Range(xRange.start - 1, xRange.end + 1);
  Range get expandedRow => Range(y - 1, y + 1);

  @override
  String toString() {
    return 'Number{value: $value, range: ${xRange.toString()}, y: $y}';
  }

  @override
  List<Object?> get props => [value, xRange, y];
}

class Symbol extends Element {
  Symbol({required this.value, required this.x, required this.y});

  final String value;
  final int x;
  final int y;

  @override
  String toString() {
    return 'Symbol{value: $value, x: $x, y: $y}';
  }

  @override
  List<Object?> get props => [value, x, y];
}

class Day3 {
  final schematic = <Element>[];
  static bool _isNotDot(String ch) => ch != '.';
  static bool _isNumber(String ch) => RegExp(r'\d').hasMatch(ch);

  static List<Element> _extractElements(List<String> line, int y) {
    final elements = <Element>[];
    StringBuffer currentNumber = StringBuffer();
    int start = -1;
    int x = 0;
    for (x; x < line.length; x++) {
      final ch = line[x];
      if (_isNumber(ch)) {
        currentNumber.write(ch);
        if (start == -1) start = x;
      } else {
        if (_isNotDot(ch)) {
          elements.add(Symbol(value: ch, x: x, y: y));
        }
        if (currentNumber.isNotEmpty) {
          elements.add(Number(
              value: int.parse(currentNumber.toString()),
              xRange: Range(start, x - 1),
              y: y));
          currentNumber.clear();
          start = -1;
        }
      }
    }

    if (currentNumber.isNotEmpty) {
      elements.add(Number(
          value: int.parse(currentNumber.toString()),
          xRange: Range(start, line.length - 1),
          y: y));
    }

    return elements;
  }

  static List<List<List<Element>>> _windowIntoPairs(List<List<Element>> list) {
    List<List<List<Element>>> windowedPairs = [];

    for (int i = 0; i < list.length - 1; i++) {
      windowedPairs.add([list[i], list[i + 1]]);
    }

    return windowedPairs;
  }

  static List<Element> _flatten(List<List<Element>> nestedList) {
    return nestedList.expand((sublist) => sublist).toList();
  }

  static Set<Number> _findParts(List<List<Element>> schematic) {
    final parts = <Number>{};
    _windowIntoPairs(schematic).forEach((rows) {
      final flattenedRows = _flatten(rows);
      final numbers = flattenedRows.whereType<Number>();
      final symbols = flattenedRows.whereType<Symbol>();
      return numbers
          .where((n) => symbols.any((s) => n.expandedColumn.contains(s.x)))
          .forEach((n) {
        parts.add(n);
      });
    });
    return parts;
  }

  static List<List<int>> findGearParts(List<Element> elements) {
    final numbers = elements.whereType<Number>();
    final potentialGears =
        elements.whereType<Symbol>().where((s) => s.value == '*');
    return potentialGears
        .map((s) {
          return numbers
              .where((n) =>
                  n.expandedColumn.contains(s.x) && n.expandedRow.contains(s.y))
              .toList();
        })
        .where((maybeGear) => maybeGear.length == 2)
        .map((gear) => gear.map((n) => n.value).toList())
        .toList();
  }

  static Future<void> partOne() async {
    final input = await readLines('lib/day_3/input.txt');
    final rows = input.asMap().entries.map((entry) {
      List<String> line = entry.value.split("");
      int index = entry.key;
      return _extractElements(line, index);
    });
    final parts = _findParts(rows.toList());
    final result = parts.map((e) => e.value).reduce((x, y) => x + y);
    print("Day 3 Part 1");
    print(result);
  }

  static Future<void> partTwo() async {
    final input = await readLines('lib/day_3/input.txt');
    final rows = input.asMap().entries.map((entry) {
      List<String> line = entry.value.split("");
      int index = entry.key;
      return _extractElements(line, index);
    });
    final gears = findGearParts(_flatten(rows.toList()));
    final result = gears
        .map((gear) => gear.reduce((x, y) => x * y))
        .reduce((x, y) => x + y);
    print("Day 3 Part 2");
    print(result);
  }
}
