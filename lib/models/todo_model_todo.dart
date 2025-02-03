// import 'package:todoapp/models/todo_model.dart';
//
// class TodoModel extends Todo {
//   TodoModel({
//     required String id,
//     required String title,
//     required String description,
//     required bool isCompleted,
//     required Timestamp createdAt,
//   }) : super(
//     id: id,
//     title: title,
//     description: description,
//     isCompleted: isCompleted,
//     createdAt: createdAt,
//   );
//
//   factory TodoModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return TodoModel(
//       id: doc.id,
//       title: data['title'] ?? '',
//       description: data['description'] ?? '',
//       isCompleted: data['isCompleted'] ?? false,
//       createdAt: data['createdAt'] ?? Timestamp.now(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'description': description,
//       'isCompleted': isCompleted,
//       'createdAt': createdAt,
//     };
//   }
// }