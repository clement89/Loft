import 'package:loftfin/widgets/outline_textdield.dart';

class FieldItem {
  String displayName;
  String fieldName;
  TextType type;
  bool isRequired;
  int order;

  FieldItem({
    required this.displayName,
    required this.fieldName,
    required this.type,
    required this.isRequired,
    required this.order,
  });
  factory FieldItem.fromMap(Map<String, dynamic> json) {
    return FieldItem(
      displayName: json['displayName'],
      fieldName: json['fieldName'],
      type: getType(json['type']),
      isRequired: json['isRequired'],
      order: json['order'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'fieldName': fieldName,
      'type': type,
      'isRequired': isRequired,
      'order': order,
    };
  }
}

TextType getType(String type) {
  if (type == 'text') {
    return TextType.text;
  } else {
    return TextType.date;
  }
}
