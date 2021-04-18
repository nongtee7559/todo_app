part of 'to_do_bloc.dart';
@immutable
abstract class ToDoState {}

class InitialToDoState extends ToDoState {}

class LoadedTaskState extends ToDoState{
  ToDoModel toDoModel = new ToDoModel();
  LoadedTaskState(this.toDoModel);
}