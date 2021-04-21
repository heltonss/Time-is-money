class EntriesPerDay {
  EntriesPerDay({this.day, this.entries});

  factory EntriesPerDay.fromJson(Map<String, dynamic> json) {
    return EntriesPerDay(
      day: json['day'] as String,
      entries: json['entries'] as List<int>,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day,
        'entries': entries,
      };

  final String day;
  final List<int> entries;
}
