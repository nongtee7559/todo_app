import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:meta/meta.dart';
import 'package:todolist_assignment/model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

part 'to_do_event.dart';

part 'to_do_state.dart';

const PREF_TODOS = "todos";

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  @override
  ToDoState get initialState => InitialToDoState();

  @override
  Stream<ToDoState> mapEventToState(ToDoEvent event) async* {
    if (event is LoadTask) {
      yield* _mapLoadTaskToState();
    } else if (event is AddTask) {
      yield* _mapAddTaskToState(event);
    } else if (event is DeleteTask) {
      yield* _mapDeleteTaskToState(event);
    } else if (event is CompleteTask) {
      yield* _mapCompleteTaskToState(event);
    }
  }

  Stream<ToDoState> _mapLoadTaskToState() async* {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var todoModel = await pref.getString(PREF_TODOS);
    if (todoModel == null) {
      yield LoadedTaskState(new ToDoModel(todos: []));
    }else{
      var todoMap = json.decode(todoModel);
      var data = ToDoModel.fromJson(todoMap);
      yield LoadedTaskState(data);
    }
  }

  Stream<ToDoState> _mapAddTaskToState(AddTask event) async* {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var toDoModel = (state as LoadedTaskState).toDoModel;
    toDoModel.todos.add(new Todo(title: event.title,complete: false));
    pref.setString(PREF_TODOS,json.encode(toDoModel));
    yield LoadedTaskState(toDoModel);
  }

  Stream<ToDoState> _mapDeleteTaskToState(DeleteTask event) async* {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var toDoModel = (state as LoadedTaskState).toDoModel;
    toDoModel.todos.removeAt(event.index);
    pref.setString(PREF_TODOS,json.encode(toDoModel));
    yield LoadedTaskState(toDoModel);
  }

  Stream<ToDoState> _mapCompleteTaskToState(CompleteTask event) async* {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var toDoModel = (state as LoadedTaskState).toDoModel;
    toDoModel.todos[event.index].complete = !toDoModel.todos[event.index].complete;
    pref.setString(PREF_TODOS,json.encode(toDoModel));
    yield LoadedTaskState(toDoModel);
  }
}
