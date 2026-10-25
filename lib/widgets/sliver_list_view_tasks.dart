import 'package:flutter/material.dart';
import 'package:try_shared_preferences/models/task_model.dart';
import 'package:try_shared_preferences/widgets/custom_container_my_tasks.dart';

class SliverListViewTasks extends StatelessWidget {
  const SliverListViewTasks({
    super.key,
    required this.tasksList,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
    this.message = "No Tasks Added",
  });
  final List<TaskModel> tasksList;
  final Function(bool?, int? index) onTap;
  final Function(String) onDelete;
  final Function() onEdit;
  final String message;
  @override
  Widget build(BuildContext context) {
    return tasksList.isNotEmpty
        ? SliverPadding(
            padding: EdgeInsets.only(bottom: 65),
            sliver: SliverList.builder(
              itemCount: tasksList.length,
              itemBuilder: (BuildContext context, index) {
                return CustomContainerMyTasks(
                  tasksList: tasksList,
                  index: index,
                  onChanged: (value) {
                    onTap(value, index);
                  },
                  onDelete: (String value) {
                    onDelete(value);
                  },
                  onEdit: () {
                    onEdit();
                  },
                );
              },
            ),
          )
        : SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                message,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          );
  }
}
