import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';

enum ToDoStatus {
  initial,
  loaded,
}

@immutable
class ToDoState extends Equatable {
  final ToDoStatus status;
  final List<ToDoItem> toDoItems;

  const ToDoState({
    required this.status,
    this.toDoItems = const <ToDoItem>[],
  });

  @override
  List<Object> get props => <Object>[
        UniqueKey(),
        status,
        toDoItems,
      ];
}
