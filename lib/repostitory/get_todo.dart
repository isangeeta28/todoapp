import 'package:todoapp/repostitory/todo_respostory.dart';

import '../models/todo_model.dart';

class GetTodos {
  final TodoRepository repository;
  GetTodos(this.repository);

  Stream<List<Todo>> call() {
    return repository.getTodos();
  }
}