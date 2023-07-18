import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';
import 'package:todo_list_redux/presentation/components/edit_to_do_item_dialog.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class ToDoListView extends StatefulWidget {
  final bool isCompletedTab;

  const ToDoListView({
    required this.isCompletedTab,
    Key? key,
  }) : super(key: key);

  @override
  State<ToDoListView> createState() => _ToDoListViewState();
}

class _ToDoListViewState extends State<ToDoListView> {
  late Store<ToDoState> store;
  late bool isCompletedTab;

  @override
  void initState() {
    super.initState();
    isCompletedTab = widget.isCompletedTab;
  }

  @override
  Widget build(BuildContext context) {
    store = StoreProvider.of<ToDoState>(context);
    return StoreConnector<ToDoState, ToDoState>(
      converter: (Store<ToDoState> store) => store.state,
      builder: (BuildContext context, ToDoState state) {
        final ToDoStatus status = state.status;
        if (status == ToDoStatus.initial) {
          return const CircularProgressIndicator();
        }

        final List<ToDoItem> toDoItems = state.toDoItems;
        final List<ToDoItem> filteredItems =
            toDoItems.where((ToDoItem item) => item.isComplete == isCompletedTab).toList();
        return ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: filteredItems.length,
          itemBuilder: (BuildContext context, int index) {
            return showToDoItems(filteredItems, index);
          },
        );
      },
    );
  }

  Widget showToDoItems(List<ToDoItem> toDoItems, int index) {
    final ToDoItem toDoItem = toDoItems[index];
    return Container(
      child: Card(
        child: InkWell(
          onTap: () => store.dispatch(ChangeCompletionOfToDoItemAction(item: toDoItem)),
          child: Row(
            children: <Widget>[
              radioButton(toDoItem),
              cardText(toDoItem),
              spacer(),
              editButton(toDoItem),
              deleteButton(toDoItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget radioButton(ToDoItem toDoItem) {
    return Radio<bool>(
      value: toDoItem.isComplete,
      groupValue: true,
      onChanged: (_) => store.dispatch(ChangeCompletionOfToDoItemAction(item: toDoItem)),
      toggleable: true,
    );
  }

  Widget cardText(ToDoItem toDoItem) {
    return Text(
      toDoItem.text,
      style: TextStyle(
        decoration: isCompletedTab ? TextDecoration.lineThrough : TextDecoration.none,
      ),
    );
  }

  Widget spacer() {
    return const Expanded(
      child: SizedBox(),
    );
  }

  Widget editButton(ToDoItem toDoItem) {
    return IconButton(
      onPressed: () => alertDialog(toDoItem),
      icon: const Icon(
        Icons.edit,
      ),
    );
  }

  Widget deleteButton(ToDoItem toDoItem) {
    return IconButton(
      onPressed: () => store.dispatch(RemoveItemAction(item: toDoItem)),
      icon: const Icon(
        Icons.delete,
      ),
    );
  }

  void alertDialog(ToDoItem toDoItem) {
    final EditToDoItemDialog dialog = EditToDoItemDialog(
      toDoItem: toDoItem,
      context: context,
    );
    dialog.showEditDialog();
  }
}
