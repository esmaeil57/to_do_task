import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/task_cubit.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final TextEditingController taskController = TextEditingController();

  void _showValidationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => const AlertDialog(
            title: Text("Validation"),
            content: Text("Text field is empty"),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskCubit = context.read<TaskCubit>();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.4,
      minChildSize: 0.2,
      maxChildSize: 0.8,
      builder:
          (_, scrollController) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              controller: scrollController,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    labelText: 'Task title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () {
                      final text = taskController.text.trim();
                      if (text.isNotEmpty) {
                        taskCubit.addTask(text);
                        Navigator.pop(context);
                      } else {
                        _showValidationPopup(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
