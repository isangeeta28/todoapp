import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo_model.dart';
import '../bloc/todo_bloc.dart';

class CreateEditTodoScreen extends StatefulWidget {
  final Todo? todo;

  CreateEditTodoScreen({this.todo});

  @override
  _CreateEditTodoScreenState createState() => _CreateEditTodoScreenState();
}

class _CreateEditTodoScreenState extends State<CreateEditTodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.todo != null) {
      _titleController.text = widget.todo!.title;
      _descriptionController.text = widget.todo!.description;
      _isCompleted = widget.todo!.isCompleted;
    }
  }

  void _showValidationDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Validation Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Create To-Do' : 'Edit To-Do'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 16),
            if (widget.todo != null) // Show this only when editing
              Row(
                children: [
                  Checkbox(
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value!;
                      });
                    },
                  ),
                  Text('Completed'),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Validate if title and description are empty or null
                if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
                  _showValidationDialog('Please enter both title and description.');
                } else {
                  final todo = Todo(
                    id: widget.todo?.id ?? '',
                    title: _titleController.text,
                    description: _descriptionController.text,
                    isCompleted: _isCompleted,
                    createdAt: DateTime.now(),
                  );

                  if (widget.todo == null) {
                    context.read<TodoBloc>().add(AddTodo(todo));
                  } else {
                    context.read<TodoBloc>().add(UpdateTodo(todo));
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(widget.todo == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
