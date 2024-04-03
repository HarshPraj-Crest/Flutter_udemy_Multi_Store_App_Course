import 'package:flutter/foundation.dart';
import 'package:notes/sqf_lite_helper.dart';

class NoteProvider with ChangeNotifier {
  static List<Note> _items = [];
  List<Note> get getItems {
    return [..._items];
  }

  int? get count {
    return _items.length;
  }

  addItem(Note note) async {
    await SQLHelper.insertNote(note).whenComplete(() => _items.add(note));
    notifyListeners();
  }

  loadNotesProvider() async {
    List<Map> data = await SQLHelper.loadNotes();
    _items = data.map((note) {
      return Note(
        id: note['id'],
        title: note['title'],
        content: note['content'],
        description: note['description'],
      );
    }).toList();
    notifyListeners();
  }

  updateItems (Note newNote) async {
    await SQLHelper.updateNote(newNote).whenComplete(() => loadNotesProvider());
    notifyListeners();
  }

  deleteItem(int id) async {
    await SQLHelper.deleteNote(id)
        .whenComplete(() => _items.removeWhere((element) => element.id == id));
    notifyListeners();
  }

  clearItems () async {
    SQLHelper.deleteForever().whenComplete(() => _items = []);
    notifyListeners();
  }
}
