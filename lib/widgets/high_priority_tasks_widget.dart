import 'package:flutter/material.dart';

import 'package:try_shared_preferences/core/theme/theme_controller.dart';
import 'package:try_shared_preferences/core/widgets/custom_check_box%20.dart';
import 'package:try_shared_preferences/core/widgets/custom_svg_widget.dart';
import 'package:try_shared_preferences/models/task_model.dart';
import 'package:try_shared_preferences/screens/high_priority_task.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,
    required this.listTasks,
    required this.onTap,
    required this.refersh,
  });
  final List<TaskModel> listTasks;
  final Function(bool?, int? index) onTap;
  final Function refersh;
  @override
  Widget build(BuildContext context) {
    return listTasks.isEmpty?
    Center(child: Text("No High Priority Tasks",
    style: Theme.of(context).textTheme.headlineMedium,
    
    )): Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "High Priority Tasks",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff15B86C),
                  ),
                ),
                SizedBox(height: 8),
                ...listTasks.reversed
                    .where((e) => e.isHighPriority)
                    .take(4)
                    .map((element) {
                      return Row(
                        children: [
                          Transform.scale(
                            scale: 1.3,
                            child: 
                            CustomCheckBox(value: element.isChecked, onChanged: (value) {
                                final index = listTasks.indexWhere(
                                  (e) => e.taskName == element.taskName,
                                );
                                onTap(value, index);
                              },)
                            
                          ),
                          SizedBox(width: 4),
                           Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    element.taskName,
                                    style:  element.isChecked?Theme.of(context).textTheme.titleLarge:Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 16),
                                  )
                           
                       
                        ],
                      );
                    }),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async{
                await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return HighPriorityTask();
                  },
                ),
              );
              refersh();
            },
            child: Container(
              padding: EdgeInsets.all(8),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2,
                  color:ThemeController.themeNotifier.value == ThemeMode.dark?Color(0xff6E6E6E): Color(0xffD1DAD6)),
              ),
              child: CustomSvgWidget(path:"assets/images/arrow-up-right.svg",
                          
              ),
            ),
          ),
        ],
      ),
    );
  }
}
