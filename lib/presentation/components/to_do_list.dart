import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/injection_container.dart';
import 'package:todo_list_redux/presentation/components/to_do_list_app_bar.dart';
import 'package:todo_list_redux/presentation/components/to_do_list_tab_bar_view.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class ToDoList extends StatelessWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const ToDoListAppBar(),
        body: StoreProvider<ToDoState>(
          store: sl<Store<ToDoState>>(),
          child: const ToDoListTabBarView(),
        ),
      ),
    );
  }
}
