class UsageResponse {
  final String name;
  final int dailyTokens;
  final int monthlyTokens;
  final int annuallyTokens;

  UsageResponse({
    required this.name,
    required this.dailyTokens,
    required this.monthlyTokens,
    required this.annuallyTokens,
  });

  factory UsageResponse.fromJson(Map<String, dynamic> json) {
    return UsageResponse(
      name: json['name'] ?? 'Free Plan',
      dailyTokens: json['dailyTokens'] ?? 0,
      monthlyTokens: json['monthlyTokens'] ?? 0,
      annuallyTokens: json['annuallyTokens'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dailyTokens': dailyTokens,
      'monthlyTokens': monthlyTokens,
      'annuallyTokens': annuallyTokens,
    };
  }
}
