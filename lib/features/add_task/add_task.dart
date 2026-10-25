import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:try_shared_preferences/core/services/preferneces_manager.dart';
import 'package:try_shared_preferences/core/widgets/custom_text_form_field.dart';
import 'package:try_shared_preferences/models/task_model.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final TextEditingController taskNameController = TextEditingController();

  final TextEditingController taskDescriptionController =
      TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isHighPriority = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24),
        child: Form(
          key: _key,
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
                  if (_key.currentState?.validate() ?? false) {
                    List<dynamic> taskList = [];
                    TaskModel model = TaskModel(
                      //taskID: taskList.length+1,
                      taskName: taskNameController.text,
                      taskDescription: taskDescriptionController.text,
                      isHighPriority: isHighPriority,
                    );
                    

                    final getTasks = PrefernecesManager().getString("tasks");
                    if (getTasks != null) {
                      taskList = jsonDecode(getTasks) as List<dynamic>;
                    }
                    taskList.add(model.toMap());
                    final taskEncoded = jsonEncode(taskList);

                    await PrefernecesManager().setString("tasks", taskEncoded);

                    Navigator.of(context).pop(true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.of(context).size.width, 40),
                ),
                icon: Icon(Icons.add),
                label: Text("Add Task"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
