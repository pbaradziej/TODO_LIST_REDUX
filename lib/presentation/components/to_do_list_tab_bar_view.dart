import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/presentation/components/to_do_list_content.dart';
import 'package:todo_list_redux/presentation/components/to_do_list_view.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class ToDoListTabBarView extends StatefulWidget {
  const ToDoListTabBarView({Key? key}) : super(key: key);

  @override
  State<ToDoListTabBarView> createState() => _ToDoListTabBarViewState();
}

class _ToDoListTabBarViewState extends State<ToDoListTabBarView> {
  late Store<ToDoState> store;
  late TabController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = DefaultTabController.of(context);
    initializeStoreItems(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: buildDesktopTabBar(context),
    );
  }

  void initializeStoreItems(BuildContext context) {
    store = StoreProvider.of<ToDoState>(context);
    final ToDoState state = store.state;
    if (state.status == ToDoStatus.initial) {
      store.dispatch(InitializeItemsAction());
    }
  }

  Widget buildDesktopTabBar(BuildContext context) {
    return TabBarView(
      controller: _controller,
      children: <Widget>[
        const ToDoListContent(),
        const ToDoListView(
          isCompletedTab: true,
        ),
      ],
    );
  }
}
