import 'package:bloc/bloc.dart';
import 'package:to_do_task/presentation/cubit/task_state.dart';
import '../../domain/repo_interface/task_repo.dart';
import '../../domain/entity/task.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepo repository;
  bool _fromAddTask = false;
  TaskCubit(this.repository) : super(TaskLoading()) {
    loadTasks();
  }

  void loadTasks() {
    emit(TaskLoading());
    try {
      final tasks = repository.getAllTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError("Faild to load tasks: ${e.toString()}"));
    }
  }

  void addTask(String title) {
    try {
        _fromAddTask = true;
      repository.addTask(Task(title: title));
      loadTasks();
    } catch (e) {
      emit(TaskError("Faild to add tasks: ${e.toString()}"));
    }
  }

  bool get fromAddTask => _fromAddTask;

  void clearFlag() {
    _fromAddTask = false;
  }
}
