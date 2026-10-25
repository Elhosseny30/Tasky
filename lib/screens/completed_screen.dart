import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/models/task_model.dart';
import 'package:try_shared_preferences/widgets/list_view_tasks.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  List<TaskModel> allListTasks = [];
  List<TaskModel> displayCompletedTasks = [];

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
        displayCompletedTasks = allListTasks
            .where((element) => element.isChecked == true)
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
              "Completed Tasks",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 18),
            Expanded(
              child: ListViewTasks(
                onEdit: () {
                  loadUserTasks();
                },
                onDelete: (String value) async {
                  setState(() {
                    allListTasks.removeWhere((e) => e.taskName == value);
                    displayCompletedTasks.removeWhere(
                      (e) => e.taskName == value,
                    );
                  });
                  final allTasksMapped = allListTasks
                      .map((e) => e.toMap())
                      .toList();
                  await PrefernecesManager().setString(
                    "tasks",
                    jsonEncode(allTasksMapped),
                  );
                },
                message: "No Completed Tasks",
                tasksList: displayCompletedTasks,
                onTap: (bool? value, int? index) async {
                  final taskTarget = displayCompletedTasks[index!].taskName;
                  final newValue = value ?? false;
                  setState(() {
                    displayCompletedTasks[index].isChecked = newValue;
                    final targetIndex = allListTasks.indexWhere(
                      (task) => task.taskName == taskTarget,
                    );

                    if (targetIndex != -1) {
                      allListTasks[targetIndex].isChecked = newValue;
                    }
                    displayCompletedTasks.removeAt(index);
                    //loadUserTasks();
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
