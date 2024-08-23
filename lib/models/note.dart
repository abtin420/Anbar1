import 'package:hive/hive.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String body;

  const Note({required this.title, required this.body});

  Note copyWith({String? newtitle, String? newbody}) {
    return Note(
      title: newtitle ?? title,
      body: newbody ?? body,
    );
  }
}
