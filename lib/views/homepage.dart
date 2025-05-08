// views/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/views/widgets/todoitem.dart';
import '../main.dart';
import '../viewmodels/todo_viewmodel.dart';

class HomePage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TodoViewModel>(context);
    final boxes = Provider.of<Boxes>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do App'),
        actions: [
          IconButton(
            icon: Icon(viewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              viewModel.toggleTheme();
              boxes.settings.put('isDarkMode', viewModel.isDarkMode);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      viewModel.addTodo(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Consumer<TodoViewModel>(
                builder: (context, viewModel, child) => ListView.builder(
                  itemCount: viewModel.todos.length,
                  itemBuilder: (context, index) {
                    final todo = viewModel.todos[index];
                    return TodoItem(todo: todo); // Use extracted widget
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}