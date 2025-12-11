import 'package:hive_flutter/hive_flutter.dart';
import 'package:tody/data/models/todo_model.dart';

/// Hive local storage service for todos
class HiveService {
  static const String _todoBoxName = 'todos';
  static late Box<TodoModel> _todoBox;

  /// Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TodoModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PriorityAdapter());
    }

    // Open boxes
    _todoBox = await Hive.openBox<TodoModel>(_todoBoxName);
  }

  /// Get todo box
  static Box<TodoModel> get todoBox => _todoBox;

  /// Get all todos
  static List<TodoModel> getAllTodos() {
    return _todoBox.values.toList();
  }

  /// Add a todo
  static Future<void> addTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  /// Update a todo
  static Future<void> updateTodo(TodoModel todo) async {
    await _todoBox.put(todo.id, todo);
  }

  /// Delete a todo
  static Future<void> deleteTodo(String id) async {
    await _todoBox.delete(id);
  }

  /// Get todo by id
  static TodoModel? getTodoById(String id) {
    return _todoBox.get(id);
  }

  /// Clear all todos
  static Future<void> clearAll() async {
    await _todoBox.clear();
  }

  /// Close Hive
  static Future<void> close() async {
    await Hive.close();
  }
}
