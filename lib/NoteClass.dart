import 'package:flutter/material.dart';
class Notes{
  int? id;
  late String Notetitle;
  late String NoteDescription;
  late DateTime? Dueto ;

  Notes({this.id, required this.Notetitle, required this.NoteDescription,  DateTime? Dueto});
  Map<String, dynamic> toMap() {
    return {'Title': Notetitle, 'Description': NoteDescription};
  }
}
