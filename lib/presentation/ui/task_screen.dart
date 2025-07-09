import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_task/presentation/cubit/task_state.dart';

import '../../domain/entity/task.dart';
import '../cubit/task_cubit.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text('Tasks'),
        ),
        elevation: 4,
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: TextField(controller: controller)),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      final cubit = context.read<TaskCubit>();
                      final currentState = cubit.state;
                      final inputText = controller.text.trim();

                      if (inputText.isNotEmpty) {
                        cubit.addTask(inputText);
                        controller.clear();
                      } else {
                        if (currentState is TaskLoaded &&
                            currentState.tasks.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "There is no tasks.",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        } else if (inputText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "TEXT FIELD IS EMPTY.",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: BlocConsumer<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is TaskLoaded && state.tasks.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(" tasks available.")),
                    );
                  } else if (state is TaskLoaded && state.tasks.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          " tasks not available.",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  } else if (state is TaskError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TaskLoaded) {
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
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      "Unexpected state",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
