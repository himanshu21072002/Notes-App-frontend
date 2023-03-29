import 'package:flutter/material.dart';
import 'package:notes_app/modules/note.dart';
import 'package:notes_app/services/api_service.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
 bool  isLoaded=false;
  NotesProvider(){
    fetchNotes();
  }
  void addnote(Note note) {
    notes.add(note);
    notifyListeners();
    ApiService.addNote(note);
  }

  void update(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    notifyListeners();
    ApiService.updateNote(note);
  }

  void delete(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes() async {
   notes= await ApiService.fetchNotes('himanshu@gmail.com');
   isLoaded=true;
   notifyListeners();
  }
}
