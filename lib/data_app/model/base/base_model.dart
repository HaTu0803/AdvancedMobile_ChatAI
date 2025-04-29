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
  String? order_field;
  int? offset;
  int? limit;

  BaseQueryParams({
    this.q,
    this.order,
    this.order_field,
    this.offset,
    this.limit,
  });

  Map<String, dynamic> toJson() {
    return {
      if (q != null) 'q': q,
      if (order != null) 'order': order,
      if (order_field != null) 'order_field': order_field,
      if (offset != null) 'offset': offset,
      if (limit != null) 'limit': limit,
    };
  }

  String toQueryString() {
    final Map<String, dynamic> json = toJson();

    final filtered = json.entries.where((e) => e.value != null);

    return filtered
        .map((e) =>
            '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value.toString())}')
        .join('&');
  }
}

class Meta {
  final int limit;
  final int total;
  final int offset;
  final bool hasNext;

  Meta({
    required this.limit,
    required this.total,
    required this.offset,
    required this.hasNext,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      limit: json['limit'],
      total: json['total'],
      offset: json['offset'],
      hasNext: json['hasNext'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'limit': limit,
      'total': total,
      'offset': offset,
      'hasNext': hasNext,
    };
  }
}
