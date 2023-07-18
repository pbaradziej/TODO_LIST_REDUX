import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:redux/redux.dart';
import 'package:todo_list_redux/data/models/to_do_item_model.dart';
import 'package:todo_list_redux/domain/entities/to_do_item.dart';
import 'package:todo_list_redux/domain/usecases/to_do_actions.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_action.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_middleware.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_reducer.dart';
import 'package:todo_list_redux/presentation/reducer/to_do_state.dart';

class MockToDoActions extends Mock implements ToDoActions {}

class FakeToDoItem extends Fake implements ToDoItem {}

void main() {
  late Store<ToDoState> store;
  late ToDoActions toDoActions;
  late List<ToDoItem> toDoItemsData;

  final ToDoItemModel toDoItemModel = ToDoItemModel(
    text: 'todoItem',
    guid: 'uniqueGuid',
    isComplete: true,
  );

  setUpAll(() {
    registerFallbackValue(FakeToDoItem());
  });

  setUp(TestWidgetsFlutterBinding.ensureInitialized);

  setUp(() {
    toDoActions = MockToDoActions();
    store = Store<ToDoState>(
      ToDoReducer().reducer,
      initialState: const ToDoState(status: ToDoStatus.initial),
      middleware: <void Function(Store<ToDoState>, dynamic, NextDispatcher)>[
        ToDoMiddleware(toDoActions: toDoActions).loadToDoMiddleware,
      ],
    );
    toDoItemsData = <ToDoItem>[toDoItemModel];
  });

  test('should have initial state', () {
    // assert
    const ToDoState toDoState = ToDoState(status: ToDoStatus.initial);
    expect(store.state, toDoState);
  });

  test('should initialize items', () {
    // arrange
    when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);

    // act
    store.dispatch(InitializeItemsAction());

    // assert
    store.onChange.listen((ToDoState state) {
      final ToDoState state = store.state;
      expect(state.toDoItems, toDoItemsData);
      expect(state.status, ToDoStatus.loaded);
    });
  });

  group('to do items actions', () {
    setUp(() {
      when(() => toDoActions.getToDoItems()).thenAnswer((_) async => toDoItemsData);
      store.dispatch(InitializeItemsAction());
      when(() => toDoActions.setToDoItems(any())).thenAnswer((_) async {});
    });

    test('should add item', () {
      // act
      store.dispatch(AddItemAction(item: toDoItemModel));

      // assert
      store.onChange.listen((ToDoState state) {
        final ToDoState state = store.state;
        expect(state.toDoItems, <ToDoItem>[toDoItemModel, toDoItemModel]);
        expect(state.status, ToDoStatus.loaded);
      });
    });

    test('should edit item', () {
      // arrange
      final ToDoItem updatedToDoItem = toDoItemModel.copyWith(text: 'updatedText');

      // act
      store.dispatch(
        const EditItemAction(
          guid: 'uniqueGuid',
          updatedText: 'updatedText',
        ),
      );

      // assert
      store.onChange.listen((ToDoState state) {
        final ToDoState state = store.state;
        expect(state.toDoItems, <ToDoItem>[updatedToDoItem]);
        expect(state.status, ToDoStatus.loaded);
      });
    });

    test('should remove item', () {
      // act
      store.dispatch(RemoveItemAction(item: toDoItemModel));

      // assert
      store.onChange.listen((ToDoState state) {
        final ToDoState state = store.state;
        expect(state.toDoItems, <ToDoItem>[]);
        expect(state.status, ToDoStatus.loaded);
      });
    });

    test('should change completion of to do item', () {
      // arrange
      final ToDoItem updatedToDoItem = toDoItemModel.copyWith(isComplete: false);

      // act
      store.dispatch(ChangeCompletionOfToDoItemAction(item: toDoItemModel));

      // assert
      store.onChange.listen((ToDoState state) {
        final ToDoState state = store.state;
        expect(state.toDoItems, <ToDoItem>[updatedToDoItem]);
        expect(state.status, ToDoStatus.loaded);
      });
    });
  });
}
