import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_task/my_tasks/di/di_container.dart' as di;
import 'my_tasks/data/model/task_model.dart';
import 'my_tasks/presentation/ui/task_screen.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do Task',
      home: TaskScreen(),
      theme: ThemeData.dark(),
      );
  }
}
