import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tody/core/constants/constants.dart';
import 'package:tody/core/routes/app_routes.dart';
import 'package:tody/providers/todo_provider.dart';
import 'package:tody/providers/theme_provider.dart';
import 'package:tody/presentation/widgets/widgets.dart';

/// Home screen displaying all todos
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, isDark),
            // Stats
            _buildStats(context),
            // Filter chips
            _buildFilterChips(context),
            // Todo list
            Expanded(child: _buildTodoList(context)),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: TextStyle(
                    fontSize: AppSizes.fontM,
                    color: AppColors.textSecondary,
                  ),
                ),
                AppSizes.verticalSpaceXS,
                Text(
                  AppStrings.homeTitle,
                  style: TextStyle(
                    fontSize: AppSizes.fontHeader,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          // Theme Switcher
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return GestureDetector(
                onTap: () => themeProvider.cycleTheme(),
                child: Container(
                  padding: const EdgeInsets.all(AppSizes.paddingS),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.radiusM),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        themeProvider.themeIcon,
                        color: AppColors.primary,
                        size: AppSizes.iconM,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        themeProvider.themeLabel,
                        style: TextStyle(
                          fontSize: AppSizes.fontS,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStats(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
          child: Row(
            children: [
              Expanded(
                child: StatsCard(
                  title: 'Pending',
                  value: provider.pendingCount.toString(),
                  icon: Iconsax.timer_1,
                  color: AppColors.warning,
                  onTap: () => provider.setFilter(TodoFilter.all),
                ),
              ),
              AppSizes.horizontalSpaceM,
              Expanded(
                child: StatsCard(
                  title: 'Completed',
                  value: provider.completedCount.toString(),
                  icon: Iconsax.tick_circle,
                  color: AppColors.success,
                  onTap: () => provider.setFilter(TodoFilter.completed),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterChipWidget(
                  label: AppStrings.filterAll,
                  isSelected: provider.currentFilter == TodoFilter.all,
                  count: provider.totalCount,
                  onTap: () => provider.setFilter(TodoFilter.all),
                ),
                AppSizes.horizontalSpaceS,
                FilterChipWidget(
                  label: AppStrings.filterToday,
                  isSelected: provider.currentFilter == TodoFilter.today,
                  count: provider.todayCount,
                  selectedColor: AppColors.info,
                  onTap: () => provider.setFilter(TodoFilter.today),
                ),
                AppSizes.horizontalSpaceS,
                FilterChipWidget(
                  label: AppStrings.filterUpcoming,
                  isSelected: provider.currentFilter == TodoFilter.upcoming,
                  selectedColor: AppColors.warning,
                  onTap: () => provider.setFilter(TodoFilter.upcoming),
                ),
                AppSizes.horizontalSpaceS,
                FilterChipWidget(
                  label: AppStrings.filterCompleted,
                  isSelected: provider.currentFilter == TodoFilter.completed,
                  count: provider.completedCount,
                  selectedColor: AppColors.success,
                  onTap: () => provider.setFilter(TodoFilter.completed),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTodoList(BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const LoadingIndicator(message: 'Loading tasks...');
        }

        final todos = provider.todos;

        if (todos.isEmpty) {
          return EmptyState(
            title: provider.currentFilter == TodoFilter.completed
                ? AppStrings.noCompletedTasks
                : AppStrings.noTasks,
            subtitle: provider.currentFilter == TodoFilter.completed
                ? AppStrings.noCompletedTasksSubtitle
                : AppStrings.noTasksSubtitle
          );
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingL),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: TodoCard(
                      todo: todo,
                      animationIndex: index,
                      onTap: () =>
                          Get.toNamed(AppRoutes.editTodo, arguments: todo.id),
                      onToggle: () => provider.toggleTodoCompletion(todo.id),
                      onDelete: () {
                        provider.deleteTodo(todo.id);
                        Get.snackbar(
                          'Deleted',
                          AppStrings.taskDeleted,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.error,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(AppSizes.paddingM),
                          borderRadius: AppSizes.radiusM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => Get.toNamed(AppRoutes.addTodo),
      backgroundColor: AppColors.primary,
      icon: const Icon(Iconsax.add, color: Colors.white),
      label: const Text(
        AppStrings.addTask,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning 👋';
    } else if (hour < 17) {
      return 'Good Afternoon 👋';
    } else {
      return 'Good Evening 👋';
    }
  }
}
