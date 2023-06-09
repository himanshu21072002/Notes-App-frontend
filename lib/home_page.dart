import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:notes_app/add_new_note.dart';
import 'package:notes_app/modules/note.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Notes App")),
      ),
      body:(notesProvider.isLoaded==false)?const Center(child: CircularProgressIndicator()): notesProvider.notes.isNotEmpty?Center(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: notesProvider.notes.length,
          itemBuilder: (context, index) {
            Note currentNote = notesProvider.notes[index];
            var myJSON = jsonDecode(currentNote.content!);
            final _controller = QuillController(
              document: Document.fromJson(myJSON),
              selection: TextSelection.collapsed(offset: 0),
            );
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewNote(
                              isUpdate: true,
                              note: currentNote,
                            )));
              },
              onLongPress: () {
                notesProvider.delete(currentNote);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey, width: 2)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentNote.title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      QuillEditor.basic(
                        controller: _controller,
                        readOnly: true, // true for view only mode
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ):const Center(child: Text('No Notes yet')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const AddNewNote(isUpdate: false)),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
