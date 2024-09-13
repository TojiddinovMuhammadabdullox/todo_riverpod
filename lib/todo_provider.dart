import 'package:riverpod/riverpod.dart';
import 'package:todo/db/db_helper.dart';

final todosProvider =
    StateNotifierProvider<TodoNotifier, List<Map<String, dynamic>>>((ref) {
  return TodoNotifier();
});

class TodoNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  TodoNotifier() : super([]);
  Future<void> loadTodos() async {
    final todos = await DatabaseHelper.instance.fetchTodos();
    state = todos;
  }

  Future<void> addTodo(String title) async {
    final newTodo = {'title': title, 'isDone': 0};
    await DatabaseHelper.instance.addTodo(newTodo);
    loadTodos();
  }

  Future<void> toggleTodoStatus(int id, bool isDone) async {
    await DatabaseHelper.instance
        .updateTodo({'id': id, 'isDone': isDone ? isDone : 0});
    loadTodos();
  }

  Future<void> deleteTodoById(int id) async {
    await DatabaseHelper.instance.deleteTodoById(id);
    loadTodos();
  }
}
