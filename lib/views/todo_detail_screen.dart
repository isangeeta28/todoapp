import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/todo_model.dart';
import '../bloc/todo_bloc.dart';
import 'edit_todo_screen.dart';

class TodoDetailsScreen extends StatelessWidget {
  final Todo todo;

  TodoDetailsScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${todo.title}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Description: ${todo.description}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Status: ${todo.isCompleted ? "Completed" : "Incomplete"}',
              style: TextStyle(fontSize: 18, color: todo.isCompleted ? Colors.green : Colors.red),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Edit/Create To-Do Screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateEditTodoScreen(todo: todo),
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Delete Task
                    context.read<TodoBloc>().add(DeleteTodo(todo.id));
                    Navigator.pop(context);
                  },
                  child: Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
