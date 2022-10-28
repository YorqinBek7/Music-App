import 'package:permission_handler/permission_handler.dart';

void getPemission() async {
  var permission = await Permission.storage.request();
  if (permission == PermissionStatus.denied) {
    await Permission.storage.request();
  }
}
