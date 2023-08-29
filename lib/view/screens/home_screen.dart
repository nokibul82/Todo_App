import 'package:flutter/cupertino.dart';

import '../../controller/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widget/todo_card_widget.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TodoController());
    final todoList = controller.todoList.value;
    final textEditingController = TextEditingController();
    final scrollbarController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "ToDo",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.amberAccent,
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  await controller.getAllTodos();
                },
                child: Scrollbar(
                  thumbVisibility: true,
                  interactive: true,
                  trackVisibility: true,
                  controller: scrollbarController,
                  thickness: 10,
                  child: ListView.builder(
                    controller: scrollbarController,
                      itemCount: todoList.length,
                      itemBuilder: (context, index) =>
                          TodoCard(todoModel: todoList[index])),
                ));
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Add todo item',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: "type here..."),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      controller.addTodo(
                          content: textEditingController.text.toLowerCase());
                      Navigator.pop(context);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
