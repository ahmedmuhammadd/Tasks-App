import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasks/shared/componant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/shared/cubit/cubit.dart';
import 'package:tasks/shared/cubit/states.dart';

class HomeScreen extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var taskController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener:(context,state){
          if (state is InsertIntoDataBaseState) Navigator.pop(context);
        } ,
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
                title: Center(
                  child: Text(
                    cubit.titles[cubit.currentIndex],
                  ),
                )),
            body: ConditionalBuilder(
              builder: (context) => cubit.Screens[cubit.currentIndex],
              condition: state is! GetFromDataBaseLoadingState,
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState.validate()) {
                    cubit.insertDataBase(time: timeController.text, date: dateController.text, task: taskController.text);
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                      padding: EdgeInsets.all(20),
                      color: Colors.grey[100],
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'task must not be empty';
                                } else
                                  return null;
                              },
                              controller: taskController,
                              labelText: 'task',
                              prefix: Icons.title,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return 'time must not be empty';
                                  } else
                                    return null;
                                },
                                controller: timeController,
                                labelText: 'time',
                                prefix: Icons.watch_later_outlined,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then(
                                        (value) {
                                      timeController.text =
                                          value.format(context).toString();
                                    },
                                  ).catchError(
                                        (error) {
                                      print(error.toString());
                                    },
                                  );
                                }),
                            SizedBox(
                              height: 15.0,
                            ),
                            defaultFormField(
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'date must not be empty';
                                } else
                                  return null;
                              },
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                ).then(
                                      (value) {
                                    dateController.text =
                                        DateFormat.yMMMd().format(value);
                                  },
                                ).catchError(
                                      (error) {
                                    print(error.toString());
                                  },
                                );
                              },
                              controller: dateController,
                              labelText: 'date',
                              prefix: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).closed.then((value) {
                   cubit.changeBottomNavIcon(isShow:false ,icon: Icons.edit);
                  }); //showBottomSheet
                  cubit.changeBottomNavIcon(isShow:true ,icon: Icons.add);
                }
              }, //onPressed
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archive',
                ),
              ],
            ),
          );
        },

      ),
    );
  }


}

