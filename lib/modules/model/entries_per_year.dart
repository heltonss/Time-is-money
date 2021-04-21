class EntriesPerYear {
  EntriesPerYear({this.id, this.year, this.entriesPerMonthIds});

  factory EntriesPerYear.fromJson(Map<String, dynamic> json) {
    return EntriesPerYear(
        id: json['id'] as String,
        year: json['year'] as String,
        entriesPerMonthIds:
            json['entries_per_month_ids'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'year': year,
        'entries_per_month_ids': entriesPerMonthIds,
      };

  final String id;
  final String year;
  Map<String, dynamic> entriesPerMonthIds;
}
