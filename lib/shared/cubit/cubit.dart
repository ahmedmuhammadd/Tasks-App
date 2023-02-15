import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasks/modules/archive_task/archivetask.dart';
import 'package:tasks/modules/done_task/donetask.dart';
import 'package:tasks/modules/new_task/newtask.dart';
import 'package:tasks/shared/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitialState());
  int currentIndex = 0;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  Database database;

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> Screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedScreen(),
  ];
  List<String> titles = [
    'NEW TASKS',
    'DONE TASKS',
    'ARCHIVED TASKS',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangeNavBarState());
  }

  void createDataBase() {
    openDatabase(
      'todo2.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks(id INTEGER PRIMARY KEY, task TEXT , date TEXT, time TEXT, status TEXT) ')
            .then(
          (value) {
            print('table created!');
          },
        ).catchError(
          (error) {
            print('error is $error');
          },
        );
      },
      onOpen: (database) {
        print('database opened');
        getFromDateBase(database);
      },
    ).then((value) {
      database = value;
      emit(CreateDataBaseState());
    });
  }

  Future insertDataBase({
    @required time,
    @required date,
    @required task,
  }) async {
    return await database.transaction(
      (txn) {
        txn
            .rawInsert(
          'INSERT INTO tasks(task,time,date,status) VALUES("$task","$time","$date","new")',
        )
            .then(
          (value) {
            print('$value added successfully ');
            emit(InsertIntoDataBaseState());
            getFromDateBase(database);
          },
        ).catchError(
          (value) {
            print(value.toString());
          },
        );
        return null;
      },
    );
  }

  void getFromDateBase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(GetFromDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach(
        (element) {
          if (element['status'] == 'new') {
            newTasks.add(element);
          } else if (element['status'] == 'done') {
            doneTasks.add(element);
          } else
            archivedTasks.add(element);
        },
      );
      emit(GetFromDataBaseState());
    });
  }

  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  void changeBottomNavIcon({
    bool isShow,
    IconData icon,
  }) {
    fabIcon = icon;
    isBottomSheetShown = isShow;
    emit(ChangeNavBarIconState());
  }

  void updateDataBase({@required String status, @required int id}) async {
    return await database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', ['$status', id]).then(
      (value) => {
        getFromDateBase(database),
        emit(UpdateDataBaseState()),
      },
    );
  }

  void deleteDataBase({@required int id}) async {
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then(
      (value) => {
        getFromDateBase(database),
        emit(DeleteFromDataBaseState()),
      },
    );
  }
}
