// final String message;
// final String messagetype;
// final String timestamp;
// final TickStatus tickStatus;
// final bool isSender;

class ConvModel {
  String? message;
  String? timestamp;
  String? messageType;
  bool isSender = false;

  ConvModel(
      {this.message, this.timestamp, this.messageType, required this.isSender});

  ConvModel.fromJson(Map<String, dynamic> json) {
    message = json['message'].toString();
    isSender = json['isSender'] ?? false;
    timestamp = json['timestamp'].toString();
    messageType = json['messagetype'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['isSender'] = isSender;
    data['timestamp'] = timestamp;
    data['messagetype'] = messageType;
    return data;
  }
}
