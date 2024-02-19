class Numeric {
  DateTime date;
  double data;

  Numeric({required this.date, required this.data});

  Numeric.fromMap(Map<String, Object?> numeric)
      : date = DateTime.parse(numeric['date'] as String),
        data = numeric['data'] as double;

  Map<String, Object?> toMap() {
    return {
      'date': date.toString(),
      'data': data,
    };
  }

  @override
  String toString() {
    return 'Numeric(date: $date, data: $data)';
  }
}
