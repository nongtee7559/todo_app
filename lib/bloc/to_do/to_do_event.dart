part of 'to_do_bloc.dart';

@immutable
abstract class ToDoEvent {}

class LoadTask extends ToDoEvent{
  @override
  String toString() => "LoadTask";
}

class AddTask extends ToDoEvent {
  final title;
  AddTask(this.title);
  @override
  String toString() => "AddTask";
}

class DeleteTask extends ToDoEvent {
  final index;
  DeleteTask(this.index);
  @override
  String toString() => "DeleteTask";
}

class CompleteTask extends ToDoEvent {
  final index;
  CompleteTask(this.index);
  @override
  String toString() => "UpdateTask";
}




