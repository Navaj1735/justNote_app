import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel{
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String category;
  @HiveField(2)
  late String description;
  @HiveField(3)
  late DateTime date;
  NoteModel({required this.title,required this.category,required this.description,required this.date});
  NoteModel.copy(NoteModel other) {
    category = other.category;
    title = other.title;
    description = other.description;
    date = other.date;
  }
}