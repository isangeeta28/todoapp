import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/todo_model.dart';
import '../repostitory/todo_respostory.dart';

abstract class TodoEvent {}
class LoadTodos extends TodoEvent {}
class AddTodo extends TodoEvent { final Todo todo; AddTodo(this.todo); }
class UpdateTodo extends TodoEvent { final Todo todo; UpdateTodo(this.todo); }
class DeleteTodo extends TodoEvent { final String id; DeleteTodo(this.id); }

class TodoState {
  final List<Todo> todos;
  TodoState(this.todos);
}

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository = TodoRepository();

  TodoBloc() : super(TodoState([])) {
    on<LoadTodos>((event, emit) async {
      final todosStream = repository.getTodos();
      await for (var todos in todosStream) {
        emit(TodoState(todos));
      }
    });

    on<AddTodo>((event, emit) async {
      // Await the add operation
      await repository.addTodo(event.todo);
      // After adding, reload the todos list
      final todosStream = repository.getTodos();
      await for (var todos in todosStream) {
        emit(TodoState(todos));
      }
    });

    on<UpdateTodo>((event, emit) async {
      // Await the update operation
      await repository.updateTodo(event.todo);
      // After updating, reload the todos list
      final todosStream = repository.getTodos();
      await for (var todos in todosStream) {
        emit(TodoState(todos));
      }
    });

    on<DeleteTodo>((event, emit) async {
      // Await the delete operation
      await repository.deleteTodo(event.id);
      // After deleting, reload the todos list
      final todosStream = repository.getTodos();
      await for (var todos in todosStream) {
        emit(TodoState(todos));
      }
    });
  }
}
