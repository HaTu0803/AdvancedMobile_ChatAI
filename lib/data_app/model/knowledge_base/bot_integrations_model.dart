class DisconnectBotIntegration {
  final String assistantId;
  final String type;

  DisconnectBotIntegration({
    required this.assistantId,
    required this.type,
  });
  Map<String, dynamic> toJson() {
    return {
      'assistantId': assistantId,
      'type': type,
    };
  }

  factory DisconnectBotIntegration.fromJson(Map<String, dynamic> json) {
    return DisconnectBotIntegration(
      assistantId: json['assistantId'],
      type: json['type'],
    );
  }
}

class TelegramBot {
  String botToken;

  TelegramBot({
    required this.botToken,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
    };
  }

  factory TelegramBot.fromJson(Map<String, dynamic> json) {
    return TelegramBot(
      botToken: json['botToken'],
    );
  }
}

class SlackBot {
  String botToken;
  String clientId;
  String clientSecret;
  String signingSecret;

  SlackBot({
    required this.botToken,
    required this.clientId,
    required this.clientSecret,
    required this.signingSecret,
  });

  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'signingSecret': signingSecret,
    };
  }

  factory SlackBot.fromJson(Map<String, dynamic> json) {
    return SlackBot(
      botToken: json['botToken'],
      clientId: json['clientId'],
      clientSecret: json['clientSecret'],
      signingSecret: json['signingSecret'],
    );
  }
}

class MessengerSlackBot {
  String botToken;
  String pageId;
  String appSecret;

  MessengerSlackBot({
    required this.botToken,
    required this.pageId,
    required this.appSecret,
  });
  Map<String, dynamic> toJson() {
    return {
      'botToken': botToken,
      'pageId': pageId,
      'appSecret': appSecret,
    };
  }

  factory MessengerSlackBot.fromJson(Map<String, dynamic> json) {
    return MessengerSlackBot(
      botToken: json['botToken'],
      pageId: json['pageId'],
      appSecret: json['appSecret'],
    );
  }
}
