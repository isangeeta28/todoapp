import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_bloc.dart';
import '../bloc/todo_bloc.dart';

import '../models/todo_model.dart';
import 'edit_todo_screen.dart'; // Import the Create/Edit Todo Screen

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do List',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          ToggleButtons(
            isSelected: [
              context.read<ThemeBloc>().state is LightThemeState,
              context.read<ThemeBloc>().state is DarkThemeState,
            ],
            onPressed: (index) {
              final themeBloc = BlocProvider.of<ThemeBloc>(context);
              if (index == 0) {
                themeBloc.add(SetLightTheme());
              } else if (index == 1) {
                themeBloc.add(SetDarkTheme());
              }
            },
            children: const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.wb_sunny, color: Colors.orange),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.nightlight_round, color: Colors.indigo),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            borderColor: Colors.white,
            selectedBorderColor: Colors.white,
            fillColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                final filteredTodos = state.todos.where((todo) {
                  return todo.title.contains(_searchQuery) || todo.description.contains(_searchQuery);
                }).toList();

                final incompleteTasks = filteredTodos.where((todo) => !todo.isCompleted).toList();
                final completedTasks = filteredTodos.where((todo) => todo.isCompleted).toList();

                return ListView(
                  children: [
                    _buildTaskSection('Incomplete Tasks', incompleteTasks, context),
                    _buildTaskSection('Completed Tasks', completedTasks, context),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEditTodoScreen()),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, size: 32),
        tooltip: 'Add New Task',
      ),
    );
  }

  Widget _buildTaskSection(String title, List<Todo> tasks, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ),
        ...tasks.map((task) => _buildTaskTile(task, context)).toList(),
      ],
    );
  }

  Widget _buildTaskTile(Todo task, BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        title: Text(
          task.title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                context.read<TodoBloc>().add(UpdateTodo(Todo(
                  id: task.id,
                  title: task.title,
                  description: task.description,
                  isCompleted: value ?? false,
                  createdAt: DateTime.now(),
                )));
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                // Show confirmation dialog before deleting the task
                _showDeleteConfirmationDialog(context, task);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEditTodoScreen(todo: task),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Todo task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () {
                // Dismiss the dialog without deleting
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Dismiss the dialog and delete the task
                context.read<TodoBloc>().add(DeleteTodo(task.id));
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
