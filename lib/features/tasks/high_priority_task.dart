import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/models/task_model.dart';
import 'package:try_shared_preferences/core/components/list_view_tasks.dart';

class HighPriorityTask extends StatefulWidget {
  const HighPriorityTask({super.key});

  @override
  State<HighPriorityTask> createState() => _HighPriorityTaskState();
}

class _HighPriorityTaskState extends State<HighPriorityTask> {
  List<TaskModel> listTasks = [];
  List<TaskModel> highPriority = [];
  bool isChecked = false;
  int totalTasks = 0;
  int totalDoneTasks = 0;
  double percentage = 0;
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
        listTasks = tasksDecoded
            .map((element) => TaskModel.fromJson(element))
            .toList();
        highPriority = listTasks.reversed
            .where((element) => element.isHighPriority)
            .toList();
      });
    }
  }

  void _calculation() {
    totalTasks = listTasks.length;
    totalDoneTasks = listTasks.where((e) => e.isChecked).length;
    percentage = totalTasks == 0 ? 0 : totalDoneTasks / totalTasks;
  }

  void doneTask(bool? value, int? index) async {
    setState(() {
      listTasks[index!].isChecked = value ?? false;
      _calculation();
    });
    final listJson = listTasks.map((element) => element.toMap()).toList();
    await PrefernecesManager().setString("tasks", jsonEncode(listJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListViewTasks(
          onEdit: () {
            loadUserTasks();
          },
          
          onDelete: (String value) async {
            setState(() {
              listTasks.removeWhere((e) => e.taskName == value);
              highPriority.removeWhere((e) => e.taskName == value);
            });

            final tasksMapped = listTasks.map((e) => e.toMap()).toList();
            await PrefernecesManager().setString(
              "tasks",
              jsonEncode(tasksMapped),
            );
          },
          tasksList: highPriority,
          onTap: (bool? value, int? index) async {
            setState(() {
              highPriority[index!].isChecked = value ?? false;
            });
            final listJson = listTasks
                .map((element) => element.toMap())
                .toList();
            await PrefernecesManager().setString("tasks", jsonEncode(listJson));
          },
        ),
      ),
    );
  }
}
