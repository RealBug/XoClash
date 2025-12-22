import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tictac/core/utils/router_helper.dart';
import 'package:tictac/core/widgets/snackbars/error_snackbar.dart';

class AuthHelper {
  AuthHelper._();

  static Future<void> handleSocialAuth({
    required BuildContext context,
    required Future<void> Function() authMethod,
    required PageRouteInfo destination,
  }) async {
    try {
      await authMethod();
      if (!context.mounted) {
        return;
      }
      RouterHelper.popAllAndPush(context, destination);
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ErrorSnackbar.showFromError(context, e);
    }
  }
}
