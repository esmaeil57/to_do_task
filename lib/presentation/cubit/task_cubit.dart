import 'package:bloc/bloc.dart';
import '../../domain/repo_interface/task_repo.dart';
import '../../domain/entity/task.dart';
part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo repository;

  TaskCubit(this.repository) : super(TaskLoading()) {
    loadTasks();
  }

  void loadTasks() {
    final tasks = repository.getAllTasks();
    emit(TaskLoaded(tasks));
  }

  void addTask(String title) {
    repository.addTask(Task(title: title));
    loadTasks(); // reload tasks after adding
  }
}
