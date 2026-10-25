import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/models/task_model.dart';
import 'package:try_shared_preferences/core/components/list_view_tasks.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  List<TaskModel> allListTasks = [];
  List<TaskModel> displayToDoTasks = [];

  @override
  void initState() {
    super.initState();
    loadUserTasks();
  }

  void loadUserTasks() async {
    final getTasks = PrefernecesManager().getString("tasks");
    if (getTasks != null) {
      final tasksDecoded = jsonDecode(getTasks) as List<dynamic>;

      setState(() {
        allListTasks = tasksDecoded
            .map((element) => TaskModel.fromJson(element))
            .toList();
        displayToDoTasks = allListTasks
            .where((element) => element.isChecked == false)
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "To Do Tasks",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 18),
            Expanded(
              child: ListViewTasks(
                message: "No Tasks to do",
                tasksList: displayToDoTasks,
                onDelete: (String value) async {
                  setState(() {
                    allListTasks.removeWhere((e) => e.taskName == value);
                    displayToDoTasks.removeWhere((e) => e.taskName == value);
                  });
                  final allTasksMapped = allListTasks
                      .map((e) => e.toMap())
                      .toList();
                  await PrefernecesManager().setString(
                    "tasks",
                    jsonEncode(allTasksMapped),
                  );
                },
                onEdit: () {
                  loadUserTasks();
                },
                onTap: (bool? value, int? index) async {
                  final targetIndex = displayToDoTasks[index!].taskName;
                  final newValue = value ?? false;
                  setState(() {
                    displayToDoTasks[index].isChecked = newValue;
                    final taskIndex = allListTasks.indexWhere(
                      (task) => task.taskName == targetIndex,
                    );

                    if (taskIndex != -1) {
                      allListTasks[taskIndex].isChecked = newValue;
                    }
                    displayToDoTasks.removeAt(index);
                  });
                  final listJson = allListTasks
                      .map((element) => element.toMap())
                      .toList();
                  await PrefernecesManager().setString(
                    "tasks",
                    jsonEncode(listJson),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
