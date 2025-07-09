import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_task/di_container.dart' as di;
import 'data/model/task_model.dart';
import 'presentation/cubit/task_cubit.dart';
import 'presentation/ui/task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.di<TaskCubit>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'To Do Task',
        home: TaskScreen(),
        theme: ThemeData.dark(),
        ),
    );
  }
}
