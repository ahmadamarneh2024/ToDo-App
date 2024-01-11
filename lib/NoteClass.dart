class Notes {
  int? id;
  late String Notetitle;
  late String NoteDescription;
  bool completed;  // New field

  Notes({this.id, required this.Notetitle, required this.NoteDescription, this.completed = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'Title': Notetitle,
      'Description': NoteDescription,
      'completed': completed ? 1 : 0,  // Convert boolean to 1 or 0
    };
  }
}
