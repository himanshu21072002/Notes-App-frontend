import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes_app/modules/note.dart';
import 'package:notes_app/providers/note_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;

class AddNewNote extends StatefulWidget {
  final bool isUpdate;
  final Note? note;
  const AddNewNote({Key? key, required this.isUpdate, this.note})
      : super(key: key);

  @override
  State<AddNewNote> createState() => _AddNewNoteState();
}

class _AddNewNoteState extends State<AddNewNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  QuillController _controller = QuillController.basic();

  void addNewNote(String js) {
    Note newNote = Note(
      id: const Uuid().v1(),
      title: titleController.text,
      content: js,
      userid: 'himanshu@gmail.com',
      dateAdded: DateTime.now(),
    );
    Provider.of<NotesProvider>(context, listen: false).addnote(newNote);
    Navigator.pop(context);
  }

  void updateNote(String js) {
    widget.note!.title = titleController.text;
    widget.note!.content = js;
    Provider.of<NotesProvider>(context, listen: false).update(widget.note!);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      titleController.text = widget.note!.title!;
      var myJSON = jsonDecode(widget.note!.content!);
      _controller = QuillController(
        document: Document.fromJson( myJSON),
        selection: TextSelection.collapsed(offset: 0),
      );;
    }
  }
  FocusNode _focusNode = FocusNode();
  bool isTitle = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Note"),
        actions: [
          IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (titleController.text.isEmpty) {
                  Navigator.pop(context);
                } else {
                  if (widget.isUpdate) {
                    String js =
                        jsonEncode(_controller.document.toDelta().toJson());
                    updateNote(js);
                  } else {
                    String js =
                        jsonEncode(_controller.document.toDelta().toJson());
                    addNewNote(js);
                  }
                }
              }),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          isTitle==false?Container():QuillToolbar.basic(controller: _controller),
          TextField(
            onTap: () {
              setState(() {
                isTitle = _focusNode.hasFocus;
                print("is title :   $isTitle");
              });
            },
            controller: titleController,
            focusNode: _focusNode,
            autofocus: (widget.isUpdate == true) ? false : true,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isTitle = false;
                });
              },
              child: QuillEditor.basic(
                controller: _controller,
                readOnly: false, // true for view only mode
              ),
            ),
          ),
        ],
      ),
    );
  }
}
