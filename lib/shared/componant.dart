import 'package:flutter/material.dart';
import 'package:tasks/shared/cubit/cubit.dart';

Widget defaultButton(
        {double width = double.infinity,
        double radius = 0.0,
        Color background = Colors.blue,
        bool isUppercase = true,
        @required String text,
        @required Function function}) =>
    Container(
      width: width,
      child: MaterialButton(
        child: Text(
          isUppercase ? text.toLowerCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: function,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
    );

Widget defaultFormField(
        {TextInputType keyboardType,
        Function validator,
        Function onChanged,
        Function onTap,
        Function onFieldSubmitted,
        @required TextEditingController controller,
        @required String labelText,
        @required IconData prefix}) =>
    TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        prefix: Icon(prefix),
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${model['task']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDataBase(status: 'done', id: model['id']);
            },
            icon: Icon(Icons.check_box),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context)
                  .updateDataBase(status: 'archived', id: model['id']);
            },
            icon: Icon(Icons.archive_outlined),
          ),
          IconButton(
            onPressed: () {
              AppCubit.get(context).deleteDataBase(id: model['id']);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
