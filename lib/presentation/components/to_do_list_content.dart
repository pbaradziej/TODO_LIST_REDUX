import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';
import 'package:todo_list_redux/presentation/components/to_do_list_view.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class ToDoListContent extends StatefulWidget {
  const ToDoListContent({Key? key}) : super(key: key);

  @override
  State<ToDoListContent> createState() => _ToDoListContentState();
}

class _ToDoListContentState extends State<ToDoListContent> {
  late Store<ToDoState> store;
  late TextEditingController adderToDoController;

  @override
  void initState() {
    super.initState();
    adderToDoController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    store = StoreProvider.of<ToDoState>(context);
    return Column(
      children: <Widget>[
        adderTextField(),
        const SizedBox(height: 10),
        const ToDoListView(
          isCompletedTab: false,
        ),
      ],
    );
  }

  Widget adderTextField() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: adderToDoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Input text',
            ),
            onSubmitted: (_) {
              final String text = adderToDoController.text;
              final ToDoItem toDoItem = ToDoItem(text: text);
              store.dispatch(AddItemAction(item: toDoItem));
              adderToDoController.clear();
            },
          ),
        ),
        IconButton(
          onPressed: () {
            final String text = adderToDoController.text;
            final ToDoItem toDoItem = ToDoItem(text: text);
            store.dispatch(AddItemAction(item: toDoItem));
            adderToDoController.clear();
          },
          icon: const Icon(
            Icons.add,
          ),
        ),
      ],
    );
  }
}
