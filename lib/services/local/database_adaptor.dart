import 'package:anbar/models/note.dart';

abstract class DBAdaptor {
  /// Create
  Future<bool> createNote({required Note note});

  /// Read
  Future<List<Note>?> getAllNotes();
  Future<Note?> readSingleNote({required int index});

  /// Update
  Future<Note?> updateNote(
      {String? title, String? body, required String currentTitle});

  /// Delete
  Future<bool> deleteNote({required int index});
}
