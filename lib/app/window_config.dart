import 'package:flutter/widgets.dart';
import 'package:window_manager/window_manager.dart';

/// Presentation infrastructure: configures the native desktop window so the
/// visualizer behaves like a floating, phone-sized panel.
///
/// Kept separate from the app shell so the windowing concern stays one place
/// when future feature modules (the character creator) are mounted.
class WindowConfig {
  const WindowConfig._();

  /// Phone-like portrait footprint (logical pixels).
  static const Size size = Size(390, 844);

  /// Applies the window setup. Must run after [windowManager] is ensured and
  /// before the first frame is shown to avoid a flash at the default size.
  static Future<void> apply() async {
    const options = WindowOptions(
      size: size,
      minimumSize: size,
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );

    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.setResizable(false);
      await windowManager.show();
      await windowManager.focus();
    });
  }
}
