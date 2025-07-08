import 'package:hive/hive.dart';
import 'package:to_do_task/domain/entity/task.dart';

class TaskModel {
  String title;
  bool isDone;

  TaskModel({required this.title, this.isDone = false});

  // Mapping between Entity <-> Model
  Task toEntity() => Task(title: title, isDone: isDone);

  static TaskModel fromEntity(Task task) => TaskModel(title: task.title, isDone: task.isDone);
}

// Hive TypeAdapter
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      title: fields[0] as String,
      isDone: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(2) 
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.isDone);
  }
}
