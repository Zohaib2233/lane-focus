import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThreadModel {
  String? lastMessage;
  DateTime? lastMessageTime;
  String? chatHeadId;
  List<String>? participants;
  List? lastMessageSeenBy;

  ChatThreadModel({
    this.chatHeadId,
    this.lastMessage,
    this.participants,
    this.lastMessageTime,
    this.lastMessageSeenBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatHeadId': chatHeadId ?? '',
      'lastMessage': lastMessage ?? '',
      'participants': participants ?? [],
      'lastMessageSeenBy': lastMessageSeenBy ?? [],
      'lastMessageTime': lastMessageTime ?? DateTime.now(),
    };
  }

  factory ChatThreadModel.fromMap(DocumentSnapshot map) {
    return ChatThreadModel(
      chatHeadId: map['chatHeadId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      lastMessageSeenBy: map['lastMessageSeenBy'] ?? [],
      participants: List.from(map['participants'] ?? []),
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
    );
  }
}
