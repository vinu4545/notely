class NoteActivityEntry {
  final int? id;
  final int noteId;
  final String action;
  final String details;
  final DateTime createdAt;

  NoteActivityEntry({
    this.id,
    required this.noteId,
    required this.action,
    required this.details,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NoteActivityEntry.fromMap(Map<String, Object?> map) {
    return NoteActivityEntry(
      id: map['id'] as int?,
      noteId: map['noteId'] as int,
      action: map['action'] as String,
      details: map['details'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'noteId': noteId,
      'action': action,
      'details': details,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
