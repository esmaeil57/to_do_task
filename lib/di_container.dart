import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:to_do_task/data/repo/task_repo_impl.dart';
import 'package:to_do_task/domain/repo_interface/task_repo.dart';
import 'package:to_do_task/presentation/cubit/task_cubit.dart';
import 'data/model/task_model.dart';

final di = GetIt.instance;

Future<void> init() async {
  final taskBox = await Hive.openBox<TaskModel>('tasks');
  di.registerSingleton<Box<TaskModel>>(taskBox);
  di.registerLazySingleton<TaskRepo>(
    () => TaskRepositoryImpl(di<Box<TaskModel>>()),
  );

  di.registerFactory(() => TaskCubit(di<TaskRepo>()));
}
