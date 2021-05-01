class HistoryEntry {
  HistoryEntry(
      {this.period,
      this.title,
      this.totalTime,
      this.subEntries,
      this.entryRecord});

  final String period;
  final String title;
  final int totalTime;
  final List<HistoryEntry> subEntries;
  final List<DateTime> entryRecord;
}
