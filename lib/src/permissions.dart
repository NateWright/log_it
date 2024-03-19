import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> getStorage() async {
    return await Permission.manageExternalStorage.request() ==
        PermissionStatus.granted;
  }
}
