import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:justnote_app/model/note_model.dart';

class NoteController with ChangeNotifier {
  final Box<NoteModel> _noteBox = Hive.box('NoteBox');
  List<NoteModel> notes = [];

  int existingNoteIndex = -1;
  //load data
  Future<List<NoteModel>> getNotes() async {
    return _noteBox.values.toList();
  }

  Future<void> loadEvents() async {
    final getNote = await getNotes();
    notes = getNote;
    notifyListeners();
  }

//Add event
  Future<void> addEvent(NoteModel event) async {
    await _noteBox.add(event);
    notifyListeners();
  }

//Delete event
  Future<void> deleteEvent(int index) async {
    await _noteBox.deleteAt(index);
    notifyListeners();
  }

//Update event
  Future<void> updateEvent(int index, NoteModel updateNote) async {
    await _noteBox.putAt(index, updateNote);
    notifyListeners();
  }

  void filterNotes(String query) async {
    if (query.isEmpty) {
      // If the search query is empty, show all notes
      notes = await getNotes();
    } else {
      // Otherwise, filter notes based on the search query
      final allNotes = await getNotes();
      notes = allNotes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
