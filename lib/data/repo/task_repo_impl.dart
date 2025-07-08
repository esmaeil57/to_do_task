import 'package:hive/hive.dart';
import '../../domain/entity/task.dart';
import '../../domain/repo_interface/task_repo.dart';
import '../model/task_model.dart';


class TaskRepositoryImpl implements TaskRepo{
  final Box<TaskModel> taskBox;

  TaskRepositoryImpl(this.taskBox);

  @override
  List<Task> getAllTasks() {
    return taskBox.values.map((taskModel) => taskModel.toEntity()).toList();
  }

  @override
  void addTask(Task task) {
    taskBox.add(TaskModel.fromEntity(task));
  }
}
