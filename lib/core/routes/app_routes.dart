import 'package:get/get.dart';
import 'package:tody/presentation/screens/screens.dart';

/// App routes configuration using GetX
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String splash = '/splash';
  static const String home = '/home';
  static const String addTodo = '/add-todo';
  static const String editTodo = '/edit-todo';
  static const String todoDetail = '/todo-detail';

  // Initial route
  static const String initial = splash;

  // Route pages
  static List<GetPage> get pages => [
        GetPage(
          name: splash,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: home,
          page: () => const HomeScreen(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: addTodo,
          page: () => const AddEditTodoScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        ),
        GetPage(
          name: editTodo,
          page: () => const AddEditTodoScreen(),
          transition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        ),
      ];
}
