import 'dart:io';

void main() {
  final File lcovFile = File('coverage/lcov.info');

  if (!lcovFile.existsSync()) {
    stderr.writeln('Error: coverage/lcov.info not found');
    stderr.writeln('Run: fvm flutter test --coverage (or flutter test --coverage)');
    exit(1);
  }

  final String content = lcovFile.readAsStringSync();

  int totalLines = 0;
  int coveredLines = 0;

  for (final String line in content.split('\n')) {
    if (line.startsWith('LF:')) {
      totalLines += int.parse(line.substring(3).trim());
    } else if (line.startsWith('LH:')) {
      coveredLines += int.parse(line.substring(3).trim());
    }
  }

  if (totalLines == 0) {
    stdout.writeln('0');
    exit(0);
  }

  final double percentage = coveredLines / totalLines * 100;
  stdout.writeln(percentage.toStringAsFixed(0));
}
