import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_task/my_tasks/di/di_container.dart';
import 'package:to_do_task/my_tasks/presentation/cubit/task_state.dart';
import '../../domain/entity/task.dart';
import '../cubit/task_cubit.dart';
import 'add_task_sheet.dart';

class TaskScreen extends StatelessWidget {
  final TaskCubit taskCubit = di<TaskCubit>();

  TaskScreen({super.key});

  void _showPopup(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openAddTaskSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: taskCubit,
        child:  AddTaskSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => taskCubit..loadTasks(),
      child: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskLoaded) {
            final msg = state.tasks.isEmpty ? "Tasks not available." : "Tasks available.";
            _showPopup(context, "Info", msg);
          } else if (state is TaskError) {
            _showPopup(context, "Error", state.message);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Tasks')),
            floatingActionButton: FloatingActionButton(
              elevation: 5,
              backgroundColor: Colors.black87,
              onPressed: () => _openAddTaskSheet(context),
              child: const Icon(Icons.add),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(child: _buildTaskList(state)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskList(TaskState state) {
    if (state is TaskLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is TaskLoaded) {
      if (state.tasks.isEmpty) {
        return const Center(child: Text("No tasks found."));
      }
      return ListView.builder(
        itemCount: state.tasks.length,
        itemBuilder: (context, index) {
          Task task = state.tasks[index];
          return ListTile(title: Text(task.title));
        },
      );
    } else if (state is TaskError) {
      return Center(
        child: Text(
          "Error: ${state.message}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else {
      return const Center(
        child: Text("Unexpected state", style: TextStyle(color: Colors.red)),
      );
    }
  }
}
