// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/viewmodels/todo_viewmodel.dart';
import 'package:todo/views/homepage.dart';
import 'models/todo.dart';

class Boxes {
  final Box<Todo> todos;
  final Box settings;

  Boxes({required this.todos, required this.settings});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(TodoAdapter());

  final todoBox = await Hive.openBox<Todo>('todos');
  final settingsBox = await Hive.openBox('settings');

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: Boxes(todos: todoBox, settings: settingsBox)),
        ChangeNotifierProvider(
          create: (context) => TodoViewModel(todoBox),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoViewModel>(context);
    final boxes = Provider.of<Boxes>(context);

    // Load theme once
    if (!viewModel.isDarkModeInitialized) {
      viewModel.loadThemePreference(boxes.settings.get('isDarkMode', defaultValue: false));
    }

    return MaterialApp(
      title: 'To-Do MVVM',
      theme: viewModel.isDarkMode ? _darkTheme : _lightTheme,
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Custom Light Theme
final _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blueGrey, // AppBar color
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.black, // Title/text color
    elevation: 2,
  ),
  scaffoldBackgroundColor: Colors.white,
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(Colors.blueGrey),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: Colors.black), // Task titles
  ),
);

// Custom Dark Theme
final _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[800],
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[800],
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.all(Colors.grey[500]),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(color: Colors.white70),
  ),
);