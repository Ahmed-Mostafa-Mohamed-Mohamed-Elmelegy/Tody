import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:tody/core/constants/constants.dart';
import 'package:tody/data/models/todo_model.dart';
import 'package:tody/providers/todo_provider.dart';
import 'package:tody/presentation/widgets/widgets.dart';

/// Screen for adding or editing a todo
class AddEditTodoScreen extends StatefulWidget {
  const AddEditTodoScreen({super.key});

  @override
  State<AddEditTodoScreen> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  Priority _priority = Priority.medium;
  String _category = AppStrings.defaultCategories.first;
  bool _isEditing = false;
  String? _todoId;

  @override
  void initState() {
    super.initState();
    _loadTodoIfEditing();
  }

  void _loadTodoIfEditing() {
    final todoId = Get.arguments as String?;
    if (todoId != null) {
      _isEditing = true;
      _todoId = todoId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final todo = context.read<TodoProvider>().getTodoById(todoId);
        if (todo != null) {
          setState(() {
            _titleController.text = todo.title;
            _descriptionController.text = todo.description ?? '';
            _dueDate = todo.dueDate;
            _priority = todo.priority;
            _category = todo.category;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTodo() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<TodoProvider>();

    if (_isEditing && _todoId != null) {
      final existingTodo = provider.getTodoById(_todoId!);
      if (existingTodo != null) {
        final updatedTodo = existingTodo.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          dueDate: _dueDate,
          priority: _priority,
          category: _category,
        );
        await provider.updateTodo(updatedTodo);
        Get.snackbar(
          'Updated',
          AppStrings.taskUpdated,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.success,
          colorText: Colors.white,
          margin: const EdgeInsets.all(AppSizes.paddingM),
          borderRadius: AppSizes.radiusM,
        );
      }
    } else {
      await provider.addTodo(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        dueDate: _dueDate,
        priority: _priority,
        category: _category,
      );
      Get.snackbar(
        'Created',
        AppStrings.taskAdded,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        margin: const EdgeInsets.all(AppSizes.paddingM),
        borderRadius: AppSizes.radiusM,
      );
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      appBar: _buildAppBar(isDark),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              CustomTextField(
                controller: _titleController,
                label: AppStrings.taskTitle,
                hint: 'Enter task title',
                prefixIcon: Iconsax.task,
                autofocus: !_isEditing,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppStrings.titleRequired;
                  }
                  if (value.trim().length < 3) {
                    return AppStrings.titleTooShort;
                  }
                  return null;
                },
              ),
              AppSizes.verticalSpaceL,

              // Description field
              CustomTextField(
                controller: _descriptionController,
                label: AppStrings.taskDescription,
                hint: 'Enter task description (optional)',
                prefixIcon: Iconsax.note_text,
                maxLines: 3,
              ),
              AppSizes.verticalSpaceL,

              // Due date picker
              DatePickerField(
                label: AppStrings.taskDueDate,
                selectedDate: _dueDate,
                onDateSelected: (date) {
                  setState(() {
                    _dueDate = date;
                  });
                },
              ),
              AppSizes.verticalSpaceL,

              // Priority selector
              PrioritySelector(
                selectedPriority: _priority,
                onPriorityChanged: (priority) {
                  setState(() {
                    _priority = priority;
                  });
                },
              ),
              AppSizes.verticalSpaceL,

              // Category selector
              CategorySelector(
                selectedCategory: _category,
                onCategoryChanged: (category) {
                  setState(() {
                    _category = category;
                  });
                },
              ),
              AppSizes.verticalSpaceXL,

              // Save button
              Consumer<TodoProvider>(
                builder: (context, provider, _) {
                  return PrimaryButton(
                    text: _isEditing ? AppStrings.update : AppStrings.create,
                    isLoading: provider.isLoading,
                    icon: _isEditing ? Iconsax.edit : Iconsax.add,
                    onPressed: _saveTodo,
                  );
                },
              ),

              // Delete button (only for editing)
              if (_isEditing) ...[
                AppSizes.verticalSpaceM,
                PrimaryButton(
                  text: AppStrings.delete,
                  isOutlined: true,
                  icon: Iconsax.trash,
                  backgroundColor: AppColors.error,
                  onPressed: _showDeleteConfirmation,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.background,
      leading: IconButton(
        icon: Icon(
          Iconsax.arrow_left,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
        onPressed: () => Get.back(),
      ),
      title: Text(
        _isEditing ? AppStrings.editTask : AppStrings.addTask,
        style: TextStyle(
          fontSize: AppSizes.fontXL,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
    );
  }

  void _showDeleteConfirmation() {
    Get.defaultDialog(
      title: AppStrings.deleteTask,
      middleText: AppStrings.confirmDelete,
      textCancel: AppStrings.cancel,
      textConfirm: AppStrings.delete,
      confirmTextColor: Colors.white,
      buttonColor: AppColors.error,
      onConfirm: () async {
        if (_todoId != null) {
          await context.read<TodoProvider>().deleteTodo(_todoId!);
          Get.back(); // Close dialog
          Get.back(); // Go back to home
          Get.snackbar(
            'Deleted',
            AppStrings.taskDeleted,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
            margin: const EdgeInsets.all(AppSizes.paddingM),
            borderRadius: AppSizes.radiusM,
          );
        }
      },
    );
  }
}
