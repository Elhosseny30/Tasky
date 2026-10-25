import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/widgets/custom_svg_widget.dart';
import 'package:try_shared_preferences/models/task_model.dart';
import 'package:try_shared_preferences/features/add_task/add_task.dart';
import 'package:try_shared_preferences/features/home/components/archived_widget.dart';
import 'package:try_shared_preferences/features/home/components/high_priority_tasks_widget.dart';
import 'package:try_shared_preferences/features/home/components/sliver_list_view_tasks.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Guest";
  List<TaskModel> listTasks = [];
  bool isChecked = false;
  int totalTasks = 0;
  int totalDoneTasks = 0;
  String? userImagePath;
  double percentage = 0;
  @override
  void initState() {
    super.initState();
    loadUserName();
    loadUserTasks();
  }

  Future<void> loadUserName() async {
    setState(() {
      userName = PrefernecesManager().getString("username") ?? "Guest";
      userImagePath = PrefernecesManager().getString("userImagePath");
    });
  }

  void loadUserTasks() async {
    final getTasks = PrefernecesManager().getString("tasks");
    if (getTasks != null) {
      final tasksDecoded = jsonDecode(getTasks) as List<dynamic>;

      setState(() {
        listTasks = tasksDecoded
            .map((element) => TaskModel.fromJson(element))
            .toList();

        _calculation();
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
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext) {
                  return AddTask();
                },
              ),
            );
            if (result != null && result == true) {
              loadUserTasks();
            }
          },
          backgroundColor: Color(0xff15B86C),
          foregroundColor: Color(0xffFFFCFC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),

          icon: Icon(Icons.add),
          label: Text("Add New Task"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: userImagePath == null? AssetImage("assets/images/leading_person.png"):FileImage(File(userImagePath!),),
                        ),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Evening ,$userName",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            Text(
                              "One task at a time.One step closer.",
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Yuhuu ,Your work Is ",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Row(
                          children: [
                            Text(
                              "almost done ! ",
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            CustomSvgWidget.withoutColor(
                              path: "assets/images/hand.svg",
                            ),
                          ],
                        ),
                      ],
                    ),
                    ArchivedWidget(
                      totalDoneTasks: totalDoneTasks,
                      totalTasks: totalTasks,
                      percentage: percentage,
                    ),
                    SizedBox(height: 8),

                    HighPriorityTasksWidget(
                      refersh: () {
                        loadUserTasks();
                      },
                      listTasks: listTasks,
                      onTap: (bool? value, int? index) async {
                        doneTask(value, index);
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      "My Tasks",
                      style: Theme.of(
                        context,
                      ).textTheme.displaySmall!.copyWith(fontSize: 20),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              SliverListViewTasks(
                tasksList: listTasks,
                onTap: (bool? value, int? index) {
                  doneTask(value, index);
                },
                onDelete: (String value) async {
                  setState(() {
                    listTasks.removeWhere((e) => e.taskName == value);
                    _calculation();
                  });
                  final x = listTasks.map((e) => e.toMap()).toList();
                  final y = jsonEncode(x);
                  await PrefernecesManager().setString("tasks", y);
                },
                onEdit: () {
                  loadUserTasks();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
