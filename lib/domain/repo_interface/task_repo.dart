import 'package:to_do_task/domain/entity/task.dart';

abstract class TaskRepo{
  List<Task> getAllTasks();
  void addTask(Task task);
}