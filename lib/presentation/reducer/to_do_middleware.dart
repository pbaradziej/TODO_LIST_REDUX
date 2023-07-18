import 'package:redux/redux.dart';
import 'package:todo_list_redux/data/registers/to_do_register.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';
import 'package:todo_list_redux/domain/usecases/to_do_actions.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class ToDoMiddleware {
  final ToDoActions toDoActions;
  final ToDoRegister toDoRegister;

  ToDoMiddleware({
    ToDoActions? toDoActions,
    ToDoRegister? toDoRegister,
  })  : toDoActions = toDoActions ?? ToDoActions(),
        toDoRegister = toDoRegister ?? ToDoRegister();

  void loadToDoMiddleware(
    Store<ToDoState> store,
    dynamic action,
    NextDispatcher next,
  ) {
    if (action is InitializeItemsAction) {
      dispatchInitializeItemsAction(store);
    } else if (action is AddItemAction) {
      dispatchAddItemAction(store, action);
    } else if (action is EditItemAction) {
      dispatchEditItemAction(store, action);
    } else if (action is RemoveItemAction) {
      dispatchRemoveItemAction(store, action);
    } else if (action is ChangeCompletionOfToDoItemAction) {
      dispatchChangeCompletionOfToDoItemAction(store, action);
    }

    next(action);
  }

  void dispatchInitializeItemsAction(Store<ToDoState> store) {
    final LoadingToDoItemListAction loadingToDoItemListAction = LoadingToDoItemListAction();
    store.dispatch(loadingToDoItemListAction);
    final Future<List<ToDoItem>> toDoItems = toDoActions.getToDoItems();
    toDoItems.then((List<ToDoItem> value) {
      toDoRegister.initializeToDoItems(value);
      store.dispatch(LoadedToDoItemListAction(items: value));
    });
  }

  void dispatchAddItemAction(Store<ToDoState> store, AddItemAction action) {
    toDoRegister.addToDoItem(action.item);
    _setToDoWithDispatch(store);
  }

  void dispatchEditItemAction(Store<ToDoState> store, EditItemAction action) {
    toDoRegister.editToDoItem(action.guid, action.updatedText);
    _setToDoWithDispatch(store);
  }

  void dispatchRemoveItemAction(Store<ToDoState> store, RemoveItemAction action) {
    toDoRegister.removeToDoItem(action.item);
    _setToDoWithDispatch(store);
  }

  void dispatchChangeCompletionOfToDoItemAction(Store<ToDoState> store, ChangeCompletionOfToDoItemAction action) {
    toDoRegister.changeCompletionOfToDoItem(action.item);
    _setToDoWithDispatch(store);
  }

  void _setToDoWithDispatch(Store<ToDoState> store) {
    _setToDoItems().then(
      (_) => store.dispatch(LoadedToDoItemListAction(items: toDoRegister.toDoItems)),
    );
  }

  Future<void> _setToDoItems() async {
    final List<ToDoItem> toDoItems = toDoRegister.toDoItems;
    await toDoActions.setToDoItems(toDoItems);
  }
}
