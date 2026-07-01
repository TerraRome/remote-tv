import 'package:flutter/material.dart';
import '../../di/injection.dart';
import '../../core/storage/storage_service.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';

final class AppBootstrap extends StatelessWidget {
  const AppBootstrap({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart TV Remote',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  final storage = getIt<StorageService>();
  await storage.init();
  runApp(const AppBootstrap());
}
