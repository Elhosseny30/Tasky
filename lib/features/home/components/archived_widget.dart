import 'dart:math';

import 'package:flutter/material.dart';

class ArchivedWidget extends StatelessWidget {
  const ArchivedWidget({
    super.key,
    required this.totalDoneTasks,
    required this.totalTasks,
    required this.percentage,
  });
  final int totalDoneTasks;
  final int totalTasks;
  final double percentage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Achieved Tasks",
                style: Theme.of(context).textTheme.titleMedium,
              ),

              Text(
                "$totalDoneTasks Out of $totalTasks Done",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),

          Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: -pi / 2,
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: CircularProgressIndicator(
                    value: percentage,
                    backgroundColor: Color(0xff6D6D6D),
                    valueColor: AlwaysStoppedAnimation(Color(0xff15B86C)),
                  ),
                ),
              ),
              Text(
                "${(percentage * 100).toInt()}%",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
