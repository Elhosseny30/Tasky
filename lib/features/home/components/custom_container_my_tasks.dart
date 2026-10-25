import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/enums/task_item_actions_enum.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/theme/theme_controller.dart';
import 'package:try_shared_preferences/core/widgets/custom_check_box%20.dart';
import 'package:try_shared_preferences/core/widgets/custom_text_form_field.dart';
import 'package:try_shared_preferences/models/task_model.dart';

class CustomContainerMyTasks extends StatelessWidget {
  const CustomContainerMyTasks({
    super.key,
    required this.tasksList,
    required this.index,
    required this.onChanged,
    required this.onDelete,
    required this.onEdit,
  });
  final List<TaskModel> tasksList;
  final int index;
  final void Function(bool?) onChanged;
  final void Function(String) onDelete;
  final void Function() onEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 16),
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ThemeController.themeNotifier.value == ThemeMode.light
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
              onChanged: onChanged,
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
                  ? (ThemeController.themeNotifier.value == ThemeMode.dark
                        ? Color(0xffA0A0A0)
                        : Color(0xff6A6A6A))
                  : (ThemeController.themeNotifier.value == ThemeMode.dark
                        ? Color(0xffC6C6C6)
                        : Color(0xff3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChanged(!tasksList[index].isChecked);
                case TaskItemActionsEnum.delete:
                  _showAlertDialog(context, index);
                case TaskItemActionsEnum.edit:
                  final bool? res = await editTaskMethod(context,index);

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
  }

  Future <bool?>editTaskMethod(BuildContext context,int index) {
    return showModalBottomSheet<bool>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        final TextEditingController taskNameController = TextEditingController(
          text: tasksList[index].taskName,
        );
        final TextEditingController taskDescriptionController =
            TextEditingController(text: tasksList[index].taskDescription);
        bool isHighPriority = tasksList[index].isHighPriority;
        GlobalKey<FormState> key = GlobalKey<FormState>();
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
                          style: Theme.of(context).textTheme.titleMedium,
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
                           // taskID: tasksList[index].taskID,
                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighPriority: isHighPriority,
                          );
                          List<TaskModel> taskList = [];

                          final getTasks = PrefernecesManager().getString(
                            "tasks",
                          );
                          if (getTasks != null) {
                            List<dynamic> decoded =
                                jsonDecode(getTasks) as List<dynamic>;
                            taskList = decoded
                                .map((e) => TaskModel.fromJson(e))
                                .toList();
                          }
                          taskList[index] = model;

                          final taskMapped = taskList.map((e) => e.toMap()).toList();
                          
                          await PrefernecesManager().setString(
                            "tasks",
                            jsonEncode(taskMapped),
                          );

                          Navigator.of(context).pop(true);
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
            style: Theme.of(context).textTheme.headlineMedium,
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
