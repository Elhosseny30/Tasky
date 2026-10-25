import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/enums/task_item_actions_enum.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/theme/theme_controller.dart';
import 'package:try_shared_preferences/core/widgets/custom_check_box%20.dart';
import 'package:try_shared_preferences/core/widgets/custom_text_form_field.dart';
import 'package:try_shared_preferences/models/task_model.dart';

class ListViewTasks extends StatelessWidget {
  const ListViewTasks({
    super.key,
    required this.tasksList,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    this.message = "No Tasks Added",
  });
  final List<TaskModel> tasksList;
  final Function(bool?, int? index) onTap;
  final Function(String name) onDelete;
  final Function() onEdit;
  final String message;
  @override
  Widget build(BuildContext context) {
    return tasksList.isNotEmpty
        ? ListView.builder(
            padding: EdgeInsets.only(bottom: 65),
            itemCount: tasksList.length,
            itemBuilder: (BuildContext context, index) {
              return Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.only(left: 16),
                height: 75,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        ThemeController.themeNotifier.value == ThemeMode.light
                        ? Color(0xffD1DAD6)
                        : Colors.transparent,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 1.3,
                      child: CustomCheckBox(
                        value: tasksList[index].isChecked,
                        onChanged: (value) {
                          onTap(value, index);
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: tasksList[index].taskDescription == ""
                          ? Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              tasksList[index].taskName,
                              style: tasksList[index].isChecked
                                  ? Theme.of(context).textTheme.titleLarge
                                  : Theme.of(context).textTheme.titleMedium,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  tasksList[index].taskName,
                                  style: tasksList[index].isChecked
                                      ? Theme.of(context).textTheme.titleLarge
                                      : Theme.of(context).textTheme.titleMedium,
                                ),

                                Text(
                                  tasksList[index].taskDescription,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tasksList[index].isChecked
                                      ? Theme.of(context).textTheme.titleLarge
                                      : Theme.of(context).textTheme.titleSmall,
                                ),
                              ],
                            ),
                    ),
                    PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: tasksList[index].isChecked
                            ? (ThemeController.themeNotifier.value ==
                                      ThemeMode.dark
                                  ? Color(0xffA0A0A0)
                                  : Color(0xff6A6A6A))
                            : (ThemeController.themeNotifier.value ==
                                      ThemeMode.dark
                                  ? Color(0xffC6C6C6)
                                  : Color(0xff3A4640)),
                      ),
                      onSelected: (value) async {
                        switch (value) {
                          case TaskItemActionsEnum.markAsDone:
                            onTap(!tasksList[index].isChecked, index);
                          case TaskItemActionsEnum.delete:
                            _showAlertDialog(context, index);
                          case TaskItemActionsEnum.edit:
                            final bool? res = await editTaskMethod(
                              context,
                              index,
                            );
                            if (res == true) {
                              onEdit();
                            } else {
                              null;
                            }
                        }
                      },
                      itemBuilder: (context) {
                        return TaskItemActionsEnum.values.map((e) {
                          return PopupMenuItem(value: e, child: Text(e.name));
                        }).toList();
                      },
                    ),
                  ],
                ),
              );
            },
          )
        : Align(
            alignment: Alignment.center,
            child: Text(
              message,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          );
  }

  Future<bool?> editTaskMethod(BuildContext context, int index) {
    return showModalBottomSheet<bool>(
      context: context,
      builder: (context) {
        final TextEditingController taskNameController = TextEditingController(
          text: tasksList[index].taskName,
        );
        final TextEditingController taskDescriptionController =
            TextEditingController(text: tasksList[index].taskDescription);
        GlobalKey<FormState> key = GlobalKey<FormState>();

        bool isHighPriority = tasksList[index].isHighPriority;
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24,
              ),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      title: "Task Name",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter Task Name";
                        }
                        return null;
                      },

                      taskNameController: taskNameController,
                      hintText: "Finish UI design for login screen",
                    ),

                    SizedBox(height: 20),

                    CustomTextFormField(
                      title: "Task Description",
                      maxLines: 5,

                      taskNameController: taskDescriptionController,
                      hintText:
                          "Finish onboarding UI and hand off to devs by Thursday.",
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Priority",
                          style: TextStyle(
                            color: Color(0xffFFFCFC),
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Switch(
                          value: isHighPriority,
                          onChanged: (value) {
                            setState(() {
                              isHighPriority = value;
                            });
                          },
                        ),
                      ],
                    ),

                    Spacer(),

                    ElevatedButton.icon(
                      onPressed: () async {
                        if (key.currentState?.validate() ?? false) {
                          TaskModel model = TaskModel(
                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighPriority: isHighPriority,
                          );
                          final oldTask = tasksList[index];

                          final getTasks = PrefernecesManager().getString(
                            "tasks",
                          );

                          if (getTasks != null) {
                            final tasksDecoded =
                                jsonDecode(getTasks) as List<dynamic>;
                            final storedTasks = tasksDecoded
                                .map((e) => TaskModel.fromJson(e))
                                .toList();

                            int targetIndex = storedTasks.indexWhere(
                              (e) => e.taskName == oldTask.taskName,
                            );

                            if (targetIndex != -1) {
                              storedTasks[targetIndex] = model;
                            }

                            final taskMapped = storedTasks
                                .map((e) => e.toMap())
                                .toList();

                            await PrefernecesManager().setString(
                              "tasks",
                              jsonEncode(taskMapped),
                            );
                            Navigator.of(context).pop(true);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      icon: Icon(Icons.edit),
                      label: Text("Edit Task"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Task",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          content: Text("Are you sure to delete this task?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancle"),
            ),
            TextButton(
              onPressed: () {
                onDelete(tasksList[index].taskName);
                Navigator.pop(context);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
