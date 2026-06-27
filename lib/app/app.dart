import 'package:flutter/material.dart';
import 'package:syv_ui/syv_ui.dart';

import '../features/home/home_view.dart';

/// The application shell. Holds theme and top-level navigation only; the actual
/// content lives in feature modules under `lib/features/`. The front door is the
/// home screen; the design-system showcase is reachable from there. A future
/// character creator slots in by adding its own feature and routing to it.
class SyvPjApp extends StatelessWidget {
  const SyvPjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SyV PJ',
      debugShowCheckedModeBanner: false,
      theme: syvTheme(),
      home: const HomeView(),
    );
  }
}
