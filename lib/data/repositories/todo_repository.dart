import 'package:tody/data/models/todo_model.dart';
import 'package:tody/data/services/hive_service.dart';
import 'package:uuid/uuid.dart';

/// Repository for todo CRUD operations
class TodoRepository {
  final Uuid _uuid = const Uuid();

  /// Get all todos
  List<TodoModel> getAllTodos() {
    return HiveService.getAllTodos();
  }

  /// Get todos sorted by date
  List<TodoModel> getTodosSortedByDate({bool ascending = false}) {
    final todos = getAllTodos();
    todos.sort((a, b) => ascending
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));
    return todos;
  }

  /// Get pending todos
  List<TodoModel> getPendingTodos() {
    return getAllTodos().where((todo) => !todo.isCompleted).toList();
  }

  /// Get completed todos
  List<TodoModel> getCompletedTodos() {
    return getAllTodos().where((todo) => todo.isCompleted).toList();
  }

  /// Get today's todos
  List<TodoModel> getTodaysTodos() {
    final now = DateTime.now();
    return getAllTodos().where((todo) {
      if (todo.dueDate == null) return false;
      return todo.dueDate!.year == now.year &&
          todo.dueDate!.month == now.month &&
          todo.dueDate!.day == now.day;
    }).toList();
  }

  /// Get upcoming todos
  List<TodoModel> getUpcomingTodos() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return getAllTodos().where((todo) {
      if (todo.dueDate == null || todo.isCompleted) return false;
      final dueDay = DateTime(
          todo.dueDate!.year, todo.dueDate!.month, todo.dueDate!.day);
      return dueDay.isAfter(today);
    }).toList();
  }

  /// Get overdue todos
  List<TodoModel> getOverdueTodos() {
    return getAllTodos().where((todo) => todo.isOverdue).toList();
  }

  /// Get todos by category
  List<TodoModel> getTodosByCategory(String category) {
    return getAllTodos().where((todo) => todo.category == category).toList();
  }

  /// Get todos by priority
  List<TodoModel> getTodosByPriority(Priority priority) {
    return getAllTodos().where((todo) => todo.priority == priority).toList();
  }

  /// Create a new todo
  Future<TodoModel> createTodo({
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    String category = 'Personal',
  }) async {
    final todo = TodoModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      createdAt: DateTime.now(),
      dueDate: dueDate,
      priority: priority,
      category: category,
    );

    await HiveService.addTodo(todo);
    return todo;
  }

  /// Update a todo
  Future<void> updateTodo(TodoModel todo) async {
    await HiveService.updateTodo(todo);
  }

  /// Toggle todo completion
  Future<TodoModel> toggleTodoCompletion(String id) async {
    final todo = HiveService.getTodoById(id);
    if (todo == null) throw Exception('Todo not found');

    final updatedTodo = todo.copyWith(
      isCompleted: !todo.isCompleted,
      completedAt: !todo.isCompleted ? DateTime.now() : null,
    );

    await HiveService.updateTodo(updatedTodo);
    return updatedTodo;
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    await HiveService.deleteTodo(id);
  }

  /// Get todo by id
  TodoModel? getTodoById(String id) {
    return HiveService.getTodoById(id);
  }

  /// Clear all todos
  Future<void> clearAllTodos() async {
    await HiveService.clearAll();
  }

  /// Get statistics
  Map<String, int> getStatistics() {
    final todos = getAllTodos();
    return {
      'total': todos.length,
      'completed': todos.where((t) => t.isCompleted).length,
      'pending': todos.where((t) => !t.isCompleted).length,
      'overdue': todos.where((t) => t.isOverdue).length,
      'today': getTodaysTodos().length,
    };
  }
}
