import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class ToDoReducer {
  ToDoState reducer(ToDoState oldState, dynamic action) {
    if (action is LoadingToDoItemListAction) {
      return const ToDoState(
        status: ToDoStatus.initial,
      );
    } else if (action is LoadedToDoItemListAction) {
      return ToDoState(
        status: ToDoStatus.loaded,
        toDoItems: action.items,
      );
    }

    return oldState;
  }
}
