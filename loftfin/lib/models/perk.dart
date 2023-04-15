class Perk {
  int id;
  String displayName;
  String imageUrl;
  String vendorName;
  String vendorWebsite;
  String startDate;
  String endDate;
  double amount;
  int displayOrder;
  int count;
  List<dynamic> transactionKeywords;

  Perk({
    required this.id,
    required this.displayName,
    required this.imageUrl,
    required this.vendorName,
    required this.vendorWebsite,
    required this.startDate,
    required this.endDate,
    required this.amount,
    required this.displayOrder,
    required this.count,
    required this.transactionKeywords,
  });
  factory Perk.fromMap(Map<String, dynamic> json) {
    return Perk(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? '(empty)',
      imageUrl: json['imageUrl'] ?? 'https://picsum.photos/200/300?grayscale',
      vendorName: json['vendorName'] ?? '',
      vendorWebsite: json['vendorWebsite'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      amount: json['amount'] ?? 5,
      displayOrder: json['displayOrder'] ?? 1,
      count: json['count'] ?? 0,
      transactionKeywords: json['transactionKeywords'] ?? [],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': displayName,
      'displayName': displayName,
      'imageUrl': imageUrl,
      'vendorName': vendorName,
      'vendorWebsite': vendorWebsite,
      'startDate': startDate,
      'endDate': endDate,
      'amount': amount,
      'displayOrder': displayOrder,
      'count': count,
      'transactionKeywords': transactionKeywords,
    };
  }
}
// var sample = {"id":5,"imageUrl":null,"displayName":null,"vendorName":"name","":"web","":12.0,"":null,"":"2022-02-18","":"2
// 022-03-17","":1,"transactionKeywords":["uiui","
// ioi"]}
