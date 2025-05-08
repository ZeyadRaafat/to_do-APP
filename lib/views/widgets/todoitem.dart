// views/todo_item.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/todo.dart';
import '../../viewmodels/todo_viewmodel.dart';

class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.todo.title);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveEdit() {
    final viewModel = Provider.of<TodoViewModel>(context, listen: false);
    viewModel.updateTodo(widget.todo.id, _controller.text);
    setState(() {
      _isEditing = false;
    });
  }

  void _deleteTodo(BuildContext context) {
    final viewModel = Provider.of<TodoViewModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this task?"),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              viewModel.deleteTodo(widget.todo.id);
              Navigator.of(context).pop();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todo = widget.todo;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Checkbox(
              value: todo.isDone,
              onChanged: (_) {
                final viewModel = Provider.of<TodoViewModel>(context, listen: false);
                viewModel.toggleDone(todo.id);
              },
            ),
            Expanded(
              child: _isEditing
                  ? TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Edit Task',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _saveEdit(),
              )
                  : Text(todo.title),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(_isEditing ? Icons.save : Icons.edit),
                  onPressed: _isEditing
                      ? _saveEdit
                      : () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTodo(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}