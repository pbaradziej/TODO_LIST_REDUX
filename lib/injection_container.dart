import 'package:get_it/get_it.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_middleware.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_reducer.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

final GetIt sl = GetIt.instance;

void init() {
  sl.registerFactory(
    () => Store<ToDoState>(
      ToDoReducer().reducer,
      initialState: const ToDoState(status: ToDoStatus.initial),
      middleware: <void Function(Store<ToDoState>, dynamic, NextDispatcher)>[
        ToDoMiddleware().loadToDoMiddleware,
      ],
    ),
  );
}
