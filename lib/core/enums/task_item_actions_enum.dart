enum TaskItemActionsEnum {
  markAsDone(name:"Done | Undo"),
  edit(name:"Edit"),
  delete(name:"Delete");

  final String name;
  const TaskItemActionsEnum({required this.name});
}