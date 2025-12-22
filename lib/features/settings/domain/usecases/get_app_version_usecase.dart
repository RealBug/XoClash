import 'package:tictac/core/services/app_info_service.dart';

class GetAppVersionUseCase {

  GetAppVersionUseCase(this._appInfoService);
  final AppInfoService _appInfoService;

  Future<String> execute() async {
    return await _appInfoService.getVersion();
  }
}
