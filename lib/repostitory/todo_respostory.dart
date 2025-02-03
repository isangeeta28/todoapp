import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/todo_model.dart';

import '../models/todo_model_todo.dart';

class TodoRepository {
  final CollectionReference todosCollection = FirebaseFirestore.instance.collection('todos');

  Stream<List<Todo>> getTodos() {
    return todosCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Todo.fromFirestore(doc)).toList());
  }

  Future<void> addTodo(Todo todo) async {
    await todosCollection.add(todo.toFirestore());
  }

  Future<void> updateTodo(Todo todo) async {
    await todosCollection.doc(todo.id).update(todo.toFirestore());
  }

  Future<void> deleteTodo(String id) async {
    await todosCollection.doc(id).delete();
  }
}