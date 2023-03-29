import 'dart:convert';
import 'dart:developer';
import '../modules/note.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String url="https://notes-app-hg.onrender.com/notes";
 static Future<void> addNote(Note note) async{
    var uri=Uri.parse("$url/add");
    var response=await http.post(uri,body: note.toMap());
    var decode= jsonDecode(response.body);
    log(decode.toString());
  }

  static Future<void> updateNote(Note note) async{
    var uri=Uri.parse("$url/update");
    var response=await http.post(uri,body: note.toMap());
    var decode= jsonDecode(response.body);
    log(decode.toString());
  }

  static Future<void> deleteNote(Note note) async{
    var uri=Uri.parse("$url/delete");
    var response=await http.post(uri,body: note.toMap());
    var decode= jsonDecode(response.body);
    log(decode.toString());
  }

  static Future<List<Note>> fetchNotes(String userid) async{
    var uri=Uri.parse("$url/list");
    var response=await http.post(uri,body: {"userid":userid});
    var decode = jsonDecode(response.body);
    List<Note> notes=[];
    for(var noteFromApi in decode){
      Note note= Note.fromMap(noteFromApi);
      notes.add(note);
    }
    return notes;
  }

}