class Statistics {
  int curConsDays;
  int maxConsDays;
  int total;
  DateTime? lastSessionEnd;

  Statistics({required this.curConsDays, required this.maxConsDays, required this.total, this.lastSessionEnd});
  
  Statistics copyWith({int? curConsDays, int? maxConsDays, int? total, DateTime? lastSessionEnd}) {
    return Statistics(
      curConsDays: curConsDays ?? this.curConsDays,
      maxConsDays: maxConsDays ?? this.maxConsDays,
      total: total ?? this.total,
      lastSessionEnd: lastSessionEnd ?? this.lastSessionEnd
    );
  }
}