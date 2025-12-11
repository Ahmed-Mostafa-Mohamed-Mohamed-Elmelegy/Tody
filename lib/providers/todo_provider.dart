import 'package:flutter/foundation.dart';
import 'package:tody/data/models/todo_model.dart';
import 'package:tody/data/repositories/todo_repository.dart';

/// Filter options for todos
enum TodoFilter { all, today, upcoming, completed }

/// Todo Provider for state management
class TodoProvider extends ChangeNotifier {
  final TodoRepository _repository = TodoRepository();

  List<TodoModel> _todos = [];
  TodoFilter _currentFilter = TodoFilter.all;
  String? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<TodoModel> get todos => _getFilteredTodos();
  List<TodoModel> get allTodos => _todos;
  TodoFilter get currentFilter => _currentFilter;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalCount => _todos.length;
  int get completedCount => _todos.where((t) => t.isCompleted).length;
  int get pendingCount => _todos.where((t) => !t.isCompleted).length;
  int get overdueCount => _todos.where((t) => t.isOverdue).length;
  int get todayCount => _repository.getTodaysTodos().length;

  /// Get statistics
  Map<String, int> get statistics => _repository.getStatistics();

  /// Initialize and load todos
  Future<void> loadTodos() async {
    _setLoading(true);
    try {
      _todos = _repository.getTodosSortedByDate();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  /// Get filtered todos based on current filter
  List<TodoModel> _getFilteredTodos() {
    List<TodoModel> filtered;

    switch (_currentFilter) {
      case TodoFilter.today:
        filtered = _repository.getTodaysTodos();
        break;
      case TodoFilter.upcoming:
        filtered = _repository.getUpcomingTodos();
        break;
      case TodoFilter.completed:
        filtered = _repository.getCompletedTodos();
        break;
      case TodoFilter.all:
        filtered = _todos;
    }

    if (_selectedCategory != null) {
      filtered = filtered.where((t) => t.category == _selectedCategory).toList();
    }

    return filtered;
  }

  /// Set filter
  void setFilter(TodoFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  /// Set category filter
  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  /// Create a new todo
  Future<void> addTodo({
    required String title,
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    String category = 'Personal',
  }) async {
    _setLoading(true);
    try {
      final todo = await _repository.createTodo(
        title: title,
        description: description,
        dueDate: dueDate,
        priority: priority,
        category: category,
      );
      _todos.insert(0, todo);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  /// Update a todo
  Future<void> updateTodo(TodoModel todo) async {
    _setLoading(true);
    try {
      await _repository.updateTodo(todo);
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  /// Toggle todo completion
  Future<void> toggleTodoCompletion(String id) async {
    try {
      final updatedTodo = await _repository.toggleTodoCompletion(id);
      final index = _todos.indexWhere((t) => t.id == id);
      if (index != -1) {
        _todos[index] = updatedTodo;
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Delete a todo
  Future<void> deleteTodo(String id) async {
    _setLoading(true);
    try {
      await _repository.deleteTodo(id);
      _todos.removeWhere((t) => t.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  /// Get todo by id
  TodoModel? getTodoById(String id) {
    return _repository.getTodoById(id);
  }

  /// Clear all todos
  Future<void> clearAllTodos() async {
    _setLoading(true);
    try {
      await _repository.clearAllTodos();
      _todos.clear();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _setLoading(false);
  }

  /// Get unique categories from todos
  List<String> get categories {
    final cats = _todos.map((t) => t.category).toSet().toList();
    cats.sort();
    return cats;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
