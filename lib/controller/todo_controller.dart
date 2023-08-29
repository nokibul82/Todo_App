import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/todo_model.dart';

class TodoController extends GetxController {
  final todoList = Rx<List<TodoModel>>([]);
  final isLoading = false.obs;

  @override
  void onInit() async {
    await getAllTodos();
    super.onInit();
  }

  Future<void> getAllTodos() async {
    try {
      isLoading.value = true;
      todoList.value.clear();
      var response = await http.get(Uri.parse("${url}todos"), headers: {
        "Accept": "application/json",
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        isLoading.value = false;
        final data = json.decode(response.body);
        for (var item in data) {
          todoList.value.add(TodoModel.fromJson(item));
        }
        todoList.value.sort((a, b) => (a.title).compareTo(b.title));
        print("list length  ${todoList.value.length}");
      } else {
        isLoading.value = false;
        Get.snackbar("Error", json.decode(response.body)["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addTodo({required String content}) async {
    try {
      isLoading.value = true;
      var data = {
        "content": content,
      };
      var response = await http.post(Uri.parse("${url}todos"),
          headers: {"Accept": "application/json"}, body: data);
      print(response.statusCode);
      if (response.statusCode == 201) {
        isLoading.value = false;
        todoList.value
            .add(TodoModel(userId: 1, title: content, completed: false));
        todoList.value.sort((a, b) => (a.title).compareTo(b.title));
        print(todoList.value.length);
      } else {
        isLoading.value = false;
        Get.snackbar("Error", json.decode(response.body)["message"],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
