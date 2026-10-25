class TaskModel {
  //final int taskID;
  final String taskName;
  final String taskDescription;
  final bool isHighPriority;
  bool isChecked;

  TaskModel({
    //required this.taskID,
    required this.taskName,
    required this.taskDescription,
    required this.isHighPriority,
    this.isChecked = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      //taskID: json["taskID"],
      taskName: json["taskName"],
      taskDescription: json["taskDescription"],
      isHighPriority: json["isHighPriority"],
      isChecked: json["isChecked"] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      //"taskID":taskID,
      "taskName": taskName,
      "taskDescription": taskDescription,
      "isHighPriority": isHighPriority,
      "isChecked": isChecked,
    };
  }
}
