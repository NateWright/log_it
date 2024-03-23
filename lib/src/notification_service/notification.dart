class LogNotification {
  final int id;
  final int logID;
  final DateTime date;

  LogNotification({
    required this.logID,
    required this.date,
  }) : id = -1;

  LogNotification.fromMap(Map<String, Object?> map)
      : id = map['id'] as int,
        logID = map['log_id'] as int,
        date = DateTime.parse(map['date'] as String);

  Map<String, Object?> toMap() {
    return {
      'id': id == -1 ? null : id,
      'log_id': logID,
      'date': date.toString(),
    };
  }
}
