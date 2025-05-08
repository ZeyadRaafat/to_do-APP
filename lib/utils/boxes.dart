// utils/boxes.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';

class Boxes {
  final Box<Todo> todos;
  final Box settings;

  Boxes({required this.todos, required this.settings});
}