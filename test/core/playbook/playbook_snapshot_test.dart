import 'package:flutter_test/flutter_test.dart';
import 'package:tictac/core/playbook/playbook_stories.dart';

/// Component snapshot tests
///
/// To generate snapshots, run:
/// ```bash
/// flutter test test/core/playbook/playbook_snapshot_test.dart
/// ```
///
/// Note: Snapshot generation requires playbook_snapshot package
/// which is currently not included. To enable snapshots:
/// 1. Add `playbook_snapshot: ^1.3.0` to dev_dependencies
/// 2. Uncomment the test below
/// 3. Run the test to generate component snapshots

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // Uncomment when playbook_snapshot is added to dev_dependencies
  /*
  testWidgets('Take snapshots of all components', (tester) async {
    await playbook.run(
      Snapshot(
        devices: [
          SnapshotDevice.iPhoneSE2nd,
          SnapshotDevice.iPhone13Pro,
        ],
      ),
      (widget, device) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            platform: device.platform,
            useMaterial3: true,
          ),
          home: widget,
        );
      },
    );
  });
  */

  // Placeholder test to ensure the file is recognized
  test('Playbook stories are defined', () {
    expect(playbook.stories.isNotEmpty, true);
  });
}
