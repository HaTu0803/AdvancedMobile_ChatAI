class UsageTokenResponse {
  final int totalTokens;
  final int availableTokens;
  final int unlimited;
  final String date;

  UsageTokenResponse({
    required this.totalTokens,
    required this.availableTokens,
    required this.unlimited,
    required this.date,
  });

  factory UsageTokenResponse.fromJson(Map<String, dynamic> json) {
    return UsageTokenResponse(
      totalTokens: json['totalTokens'],
      availableTokens: json['availableTokens'],
      unlimited: json['unlimited'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalTokens': totalTokens,
      'availableTokens': availableTokens,
      'unlimited': unlimited,
      'date': date,
    };
  }
}
