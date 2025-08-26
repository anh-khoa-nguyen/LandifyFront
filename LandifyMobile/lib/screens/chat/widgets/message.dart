enum Sender { me, other }

class Message {
  final Sender sender;
  final String text;
  final bool containsPropertyPreview;
  final bool isCooperationRequest;
  final bool isMeetingRequest;
  final bool isMeetingReminder;
  final bool isDelayRequest;


  Message({
    required this.sender,
    required this.text,
    this.containsPropertyPreview = false,
    this.isCooperationRequest = false,
    this.isMeetingRequest = false,
    this.isMeetingReminder = false,
    this.isDelayRequest = false,

  });
}