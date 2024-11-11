class CallLogsModel {
  String calleName;
  String calleNumber;
  String callType;
  String callStartTime;
  String callDuration;
  String callId;

  CallLogsModel({
    required this.calleName,
    required this.calleNumber,
    required this.callType,
    required this.callStartTime,
    required this.callDuration,
    required this.callId,
  });

  factory CallLogsModel.fromJson(Map<String, dynamic> json) => CallLogsModel(
    calleName: json["calle_name"],
    calleNumber: json["calle_number"],
    callType: json["call_type"],
    callStartTime: json["call_start_time"],
    callDuration: json["call_duration"],
    callId: json["call_Id"],
  );

  Map<String, dynamic> toJson() => {
    "calle_name": calleName,
    "calle_number": calleNumber,
    "call_type": callType,
    "call_start_time": callStartTime,
    "call_duration": callDuration,
    "call_Id": callId,
  };
}