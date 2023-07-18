import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class EditToDoItemDialog {
  final ToDoItem toDoItem;
  final BuildContext context;
  late TextEditingController editorToDoController;

  EditToDoItemDialog({
    required this.toDoItem,
    required this.context,
  }) : editorToDoController = TextEditingController(text: toDoItem.text);

  void showEditDialog() {
    showDialog<void>(
      context: context,
      builder: (final BuildContext context) {
        return AlertDialog(
          title: const Text('Edit todo'),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                editorTextField(),
              ],
            ),
          ),
          actions: <Widget>[
            dialogActions(),
          ],
        );
      },
    );
  }

  Widget editorTextField() {
    return TextField(
      controller: editorToDoController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Edit text',
      ),
      onSubmitted: (_) {
        editToDoItem();
      },
    );
  }

  Widget dialogActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            editToDoItem();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void editToDoItem() {
    final Store<ToDoState> store = StoreProvider.of<ToDoState>(context);
    final String toDoItemGuid = toDoItem.guid;
    final String text = editorToDoController.text;
    store.dispatch(EditItemAction(guid: toDoItemGuid, updatedText: text));
  }
}
