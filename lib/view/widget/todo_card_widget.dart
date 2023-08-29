import '../../model/todo_model.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatefulWidget {
  final TodoModel todoModel;
  const TodoCard({super.key, required this.todoModel});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      title: widget.todoModel.completed
          ? Text(
              widget.todoModel.title,
              style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.black.withOpacity(0.3)),
            )
          : Text(
              widget.todoModel.title,
            ),
      value: widget.todoModel.completed,
      onChanged: (bool? value) {
        setState(() {
          widget.todoModel.completed = value!;
        });
      },
    );
  }
}
