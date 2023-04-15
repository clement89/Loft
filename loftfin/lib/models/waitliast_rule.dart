class WaitList {
  String start;
  String end;
  String perkCount;

  WaitList({
    required this.start,
    required this.end,
    required this.perkCount,
  });

  factory WaitList.fromMap(Map<String, dynamic> json) {
    return WaitList(
      start: json['start'],
      end: json['end'],
      perkCount: json['perkCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'displayName': start,
      'fieldName': end,
      'type': perkCount,
    };
  }
}
