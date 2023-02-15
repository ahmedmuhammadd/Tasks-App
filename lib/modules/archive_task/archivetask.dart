import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:tasks/shared/componant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks/shared/cubit/cubit.dart';
import 'package:tasks/shared/cubit/states.dart';

class ArchivedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).archivedTasks;
        return ConditionalBuilder(
            condition: tasks.length > 0,
            builder: (context) => ListView.separated(
                  itemBuilder: (context, index) =>
                      buildTaskItem(tasks[index], context),
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: 20.0,
                      end: 20.0,
                    ),
                    child: Container(
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  itemCount: tasks.length,
                ),
            fallback: (context) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.archive_outlined,size: 100,color: Colors.grey,),
                    Text('Please add some tasks',style: TextStyle(color:Colors.grey ),)
                  ],
                ),
              );
            });
      },
    );
  }
}
