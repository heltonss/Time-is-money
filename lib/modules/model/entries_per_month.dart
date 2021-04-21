class EntriesPerMonth {
  EntriesPerMonth({this.month, this.entriesPerDayIds});

  factory EntriesPerMonth.fromJson(Map<String, dynamic> json) {
    return EntriesPerMonth(
      month: json['month'] as String,
      entriesPerDayIds: json['entries_per_day_ids'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'month': month.toString(),
        'entries_per_day_ids': entriesPerDayIds,
      };

  final String month;
  final Map<String, dynamic> entriesPerDayIds;
}
