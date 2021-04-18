import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todolist_assignment/bloc/to_do/to_do_bloc.dart';
import 'package:todolist_assignment/model/todo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(),
        home: BlocProvider(
          create: (BuildContext context) => ToDoBloc(),
          child: ToDoPage(),
        ));
  }
}

class ToDoPage extends StatelessWidget {
  var _controller = TextEditingController();
  ToDoBloc _toDoBloc;

  @override
  Widget build(BuildContext context) {
    _toDoBloc = BlocProvider.of<ToDoBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text(
        'Todo App',
      )),
      body: BlocBuilder(
          bloc: _toDoBloc,
          builder: (BuildContext context, ToDoState state) {
            if (state is InitialToDoState) {
              _toDoBloc.add(LoadTask());
              return SizedBox();
            }
            if (state is LoadedTaskState) {
              final todos = state.toDoModel.todos;
              return Container(
                child: Column(
                  children: <Widget>[
                    buildAddToDo(),
                    if (todos.length != 0) buildToDo(todos),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget buildAddToDo() {
    return Card(
      elevation: 8.0,
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Add a task",
          suffixIcon: IconButton(
            onPressed: () {
              if (_controller.text != null) {
                _toDoBloc.add(AddTask(_controller.text));
                WidgetsBinding.instance.addPostFrameCallback((_) => _controller.clear());
              }
            },
            icon: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Widget buildToDo(List<Todo> item) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: item.length,
        itemBuilder: (BuildContext context, int index) {
          final todo = item[index];
          return Card(
            color: Colors.grey.shade200,
            elevation: 8.0,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => _toDoBloc.add(CompleteTask(index)),
                      child: todo.complete
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(todo.title,
                        style: TextStyle(
                          decoration:
                              todo.complete ? TextDecoration.lineThrough : null,
                        )),
                    Spacer(flex: 1),
                    GestureDetector(
                      onTap: () => _toDoBloc.add(DeleteTask(index)),
                      child: Icon(Icons.delete),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
