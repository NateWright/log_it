class Photo {
  DateTime date;
  String data;

  Photo({required this.date, required this.data});

  Photo.fromMap(Map<String, Object?> numeric)
      : date = DateTime.parse(numeric['date'] as String),
        data = numeric['data'] as String;

  Map<String, Object?> toMap() {
    return {
      'date': date.toString(),
      'data': data,
    };
  }

  @override
  String toString() {
    return 'Picture(date: $date, data: $data)';
  }
}
