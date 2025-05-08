// viewmodels/todo_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class TodoViewModel extends ChangeNotifier {
  final Box<Todo> _todoBox;
  bool _isDarkMode = false;
  bool isDarkModeInitialized = false;

  List<Todo> get todos => _todoBox.values.toList();
  bool get isDarkMode => _isDarkMode;

  TodoViewModel(this._todoBox);

  void loadThemePreference(bool value) {
    _isDarkMode = value;
    isDarkModeInitialized = true;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void addTodo(String title) {
    final todo = Todo(id: DateTime.now().toString(), title: title);
    _todoBox.put(todo.id, todo);
    notifyListeners();
  }

  void updateTodo(String id, String newTitle) {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.title = newTitle;
      _todoBox.put(id, todo);
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todoBox.delete(id);
    notifyListeners();
  }

  void toggleDone(String id) {
    final todo = _todoBox.get(id);
    if (todo != null) {
      todo.isDone = !todo.isDone;
      _todoBox.put(id, todo);
      notifyListeners();
    }
  }
}