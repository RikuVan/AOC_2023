mixin Day {
  int _dayNumber = 0;

  set dayNumber(int value) => _dayNumber = value;
  int get dayNumber => _dayNumber;

  void printResultForPart({required int part, required dynamic result}) {
    if (part == 1) print('************************\n');
    if (part == 1) print('\x1B[36mDAY $dayNumber \n');
    print('\x1B[33mPart $part:\x1B[32m ${result} \x1B[0m');
    if (part == 2) print('\n');
  }
}
