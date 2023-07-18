import 'package:flutter/material.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';

@immutable
abstract class Action {
  const Action();
}

@immutable
abstract class ItemAction extends Action {
  final ToDoItem item;

  const ItemAction({required this.item});
}

class InitializeItemsAction extends Action {}

class AddItemAction extends ItemAction {
  const AddItemAction({required super.item});
}

class EditItemAction extends Action {
  final String guid;
  final String updatedText;

  const EditItemAction({
    required this.guid,
    required this.updatedText,
  });
}

class RemoveItemAction extends ItemAction {
  const RemoveItemAction({required super.item});
}

class ChangeCompletionOfToDoItemAction extends ItemAction {
  const ChangeCompletionOfToDoItemAction({required super.item});
}

class LoadingToDoItemListAction extends Action {}

class LoadedToDoItemListAction extends Action {
  final List<ToDoItem> items;

  const LoadedToDoItemListAction({required this.items});
}
