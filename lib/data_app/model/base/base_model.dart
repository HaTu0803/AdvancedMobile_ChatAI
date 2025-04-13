class BaseModel {
  final String createdAt;
  final String? updatedAt;
  final String? createdBy;
  final String? updatedBy;

  BaseModel({
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
  });

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }
}

class BaseQueryParams {
  String? q;
  String? order; // ASC | DESC
  String? orderField;
  int? offset;
  int? limit;

  BaseQueryParams({
    this.q,
    this.order,
    this.orderField,
    this.offset,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      'q': q,
      'order': order,
      'order_field': orderField,
      'offset': offset,
      'limit': limit,
    };
  }
}
