class UsageResponse {
  String name;
  int dailyTokens;
  int monthlyTokens;
  int annuallyTokens;

  UsageResponse({
    required this.name,
    required this.dailyTokens,
    required this.monthlyTokens,
    required this.annuallyTokens,
  });

  factory UsageResponse.fromJson(Map<String, dynamic> json) {
    return UsageResponse(
      name: json['name'],
      dailyTokens: json['dailyTokens'],
      monthlyTokens: json['monthlyTokens'],
      annuallyTokens: json['annuallyTokens'],
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
