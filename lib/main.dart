import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/model/task_model.dart';
import 'data/repo/task_repo_impl.dart';
import 'domain/repo_interface/task_repo.dart';
import 'presentation/cubit/task_cubit.dart';
import 'presentation/ui/task_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  final taskBox = await Hive.openBox<TaskModel>('tasks');

  TaskRepo repository = TaskRepositoryImpl(taskBox);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final TaskRepo repository;
  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => TaskCubit(repository),
        child: const TaskScreen(),
      ),
      theme: ThemeData.dark(),
    );
  }
}
