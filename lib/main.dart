import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tody/core/constants/constants.dart';
import 'package:tody/core/routes/app_routes.dart';
import 'package:tody/core/theme/app_theme.dart';
import 'package:tody/data/services/hive_service.dart';
import 'package:tody/providers/todo_provider.dart';
import 'package:tody/providers/theme_provider.dart';

void main() async {
  // Preserve native splash screen until app is ready
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive
  await HiveService.init();

  // Initialize theme provider
  final themeProvider = ThemeProvider();
  await themeProvider.init();

  runApp(TodyApp(themeProvider: themeProvider));
}

class TodyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const TodyApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return GetMaterialApp(
            title: AppStrings.appName,
            debugShowCheckedModeBanner: false,

            // Theme
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Routes
            initialRoute: AppRoutes.initial,
            getPages: AppRoutes.pages,

            // Default transition
            defaultTransition: Transition.fadeIn,
            transitionDuration: const Duration(milliseconds: 300),
          );
        },
      ),
    );
  }
}
