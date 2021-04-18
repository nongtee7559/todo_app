// To parse this JSON data, do
//
//     final toDoModel = toDoModelFromJson(jsonString);

import 'dart:convert';

ToDoModel toDoModelFromJson(String str) => ToDoModel.fromJson(json.decode(str));

String toDoModelToJson(ToDoModel data) => json.encode(data.toJson());

class ToDoModel {
  ToDoModel({
    this.todos,
  });

  List<Todo> todos = new List();

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
    todos: List<Todo>.from(json["todos"].map((x) => Todo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
  };
}

class Todo {
  Todo({
    this.title,
    this.complete,
  });

  String title;
  bool complete;

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    title: json["title"],
    complete: json["complete"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "complete": complete,
  };
}
