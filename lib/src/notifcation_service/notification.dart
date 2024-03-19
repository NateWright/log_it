class LogNotification {
  int id;
  final int logID;
  final DateTime date;

  LogNotification({
    required this.id,
    required this.logID,
    required this.date,
  });

  LogNotification.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        logID = map['log_id'] as int,
        date = DateTime.parse(map['date'] as String);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'log_id': logID,
      'date': date.toString(),
    };
  }
}
