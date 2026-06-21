import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

import 'app/app.dart';
import 'app/window_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await WindowConfig.apply();
  runApp(const SyvPjApp());
}
