import 'package:package_info_plus/package_info_plus.dart';
import 'package:tictac/core/services/app_info_service.dart';
import 'package:tictac/core/services/logger_service.dart';

class AppInfoServiceImpl implements AppInfoService {
  AppInfoServiceImpl(this._logger);
  final LoggerService _logger;

  @override
  Future<String> getVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return 'v${packageInfo.version}';
    } catch (e, stackTrace) {
      _logger.error('Failed to get app version', e, stackTrace);
      return '';
    }
  }
}
