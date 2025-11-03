
import 'dart:ui';

class Note {
  String title ; 
  String content ;
  final DateTime? createdAt;
  DateTime? updatedAt;
  final Color? color;
  final List<String>? tags;
  bool isPinned;
  VoidCallback? onTap;
  final VoidCallback? onEdit;
  VoidCallback? onDelete;
  final VoidCallback? onPin;
  // later for teh categories ( array since can belong to a lot ) 
  // latter for the picture 

  Note(
    {
    this.onTap, this.onEdit, this.onDelete, this.onPin , 
    this.createdAt, 
    this.updatedAt, 
    this.color, 
    this.tags, 
    this.isPinned = false , 
    required this.title, 
    required this.content, 
    }); 
  
}