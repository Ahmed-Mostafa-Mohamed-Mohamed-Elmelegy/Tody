/// App string constants
class AppStrings {
  AppStrings._();

  // App Info
  static const String appName = 'Tody';
  static const String appTagline = 'Organize your life';

  // Splash Screen
  static const String splashTitle = 'Tody';
  static const String splashSubtitle = 'Your Smart Todo Companion';

  // Home Screen
  static const String homeTitle = 'My Tasks';
  static const String todayTasks = 'Today\'s Tasks';
  static const String allTasks = 'All Tasks';
  static const String completedTasks = 'Completed';
  static const String pendingTasks = 'Pending';

  // Task Actions
  static const String addTask = 'Add Task';
  static const String editTask = 'Edit Task';
  static const String deleteTask = 'Delete Task';
  static const String taskTitle = 'Task Title';
  static const String taskDescription = 'Description';
  static const String taskDueDate = 'Due Date';
  static const String taskPriority = 'Priority';
  static const String taskCategory = 'Category';

  // Priority
  static const String priorityHigh = 'High';
  static const String priorityMedium = 'Medium';
  static const String priorityLow = 'Low';

  // Categories
  static const List<String> defaultCategories = [
    'Personal',
    'Work',
    'Shopping',
    'Health',
    'Study',
    'Home',
    'Finance',
    'Other',
  ];

  // Buttons
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String update = 'Update';
  static const String create = 'Create';

  // Empty States
  static const String noTasks = 'No tasks yet';
  static const String noTasksSubtitle = 'Add your first task to get started!';
  static const String noCompletedTasks = 'No completed tasks';
  static const String noCompletedTasksSubtitle = 'Complete some tasks to see them here';

  // Messages
  static const String taskAdded = 'Task added successfully!';
  static const String taskUpdated = 'Task updated successfully!';
  static const String taskDeleted = 'Task deleted successfully!';
  static const String taskCompleted = 'Task completed!';
  static const String confirmDelete = 'Are you sure you want to delete this task?';

  // Validation
  static const String titleRequired = 'Title is required';
  static const String titleTooShort = 'Title must be at least 3 characters';

  // Filters
  static const String filterAll = 'All';
  static const String filterToday = 'Today';
  static const String filterUpcoming = 'Upcoming';
  static const String filterCompleted = 'Completed';
}
