import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/todo_provider.dart';

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Todo",
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.teal,
        hintColor: Colors.orangeAccent,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
          titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends ConsumerWidget {
  final TextEditingController _todoController = TextEditingController();

  TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Today’s Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: ListTile(
                      leading: Checkbox(
                        value: todo['isDone'] == 1,
                        activeColor: Colors.teal,
                        onChanged: (value) {
                          ref
                              .read(todosProvider.notifier)
                              .toggleTodoStatus(todo['id'], value!);
                        },
                      ),
                      title: Text(
                        todo['title'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          decoration: todo['isDone'] == 1
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () {
                          ref
                              .read(todosProvider.notifier)
                              .deleteTodoById(todo['id']);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildAddTodoField(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTodoField(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _todoController,
              decoration: const InputDecoration(
                hintText: 'Add a new task...',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.teal),
            onPressed: () {
              if (_todoController.text.isNotEmpty) {
                ref.read(todosProvider.notifier).addTodo(_todoController.text);
                _todoController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
