import 'package:anbar/models/note.dart';
import 'package:anbar/services/local/database_adaptor.dart';
import 'dart:developer';

import 'package:hive/hive.dart';

class AppDatabase implements DBAdaptor {
  /// singleton
  AppDatabase._();
  static final AppDatabase _shared = AppDatabase._();
  factory AppDatabase.instance() => _shared;
  static const String _boxName = 'notes';

  ///create note in DB if its success returns 'true'
  @override
  Future<bool> createNote({required Note note}) async {
    try {
      await Hive.box(_boxName).add(note);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  ///delete note from DB with in given index
  @override
  Future<bool> deleteNote({required int index}) async {
    // TODO: implement deleteNote
    try {
      await Hive.box(_boxName).deleteAt(index);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  /// read all notes from DB, return list of notes when its success
  @override
  Future<List<Note>?> getAllNotes() async {
    try {
      return Hive.box<Note>(_boxName).values.toList();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  /// read single note from DB with index given , returns note if success
  @override
  Future<Note?> readSingleNote({required int index}) async {
    try {
      final note = Hive.box(_boxName).getAt(index);
      return note;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<Note?> updateNote(
      {String? title, String? body, required String currentTitle}) async {
    try {
      //find current note from db
      final currentNote = Hive.box<Note>(_boxName)
          .values
          .firstWhere((Note element) => element.title == currentTitle);
      //finds notes index
      final index =
          Hive.box<Note>(_boxName).values.toList().indexOf(currentNote);
      //update note with new values
      final updatedNote = currentNote.copyWith(newtitle: title, newbody: body);
      // put updated note in db
      await Hive.box(_boxName).putAt(index, updatedNote);
      return updatedNote;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
