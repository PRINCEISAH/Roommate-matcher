import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class ChatGroup {
  final List<DocumentReference> members;
  final CollectionReference messages;
  final DocumentReference reference;
  final String chatGroupId;

  ChatGroup({this.reference, this.chatGroupId, this.members})
      : messages = reference.collection(chatGroupId).reference();

  ChatGroup.fromMap(Map<String, dynamic> map,
      {this.reference, this.chatGroupId})
      : members = List<DocumentReference>.from(map['members']),
        messages = reference.collection(chatGroupId).reference();

  ChatGroup.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data,
          reference: snapshot.reference,
          chatGroupId: snapshot.documentID,
        );

  Map<String, dynamic> toMap() => {
        'members': this.members,
      };
}

class Message {
  final DateTime timestamp;
  final String content;
  final String type, chatId;

  final DocumentReference to, from, reference;

  Message({
    this.chatId,
    this.reference,
    @required this.to,
    @required this.from,
    @required this.timestamp,
    @required this.content,
    @required this.type,
  });

  Message.fromMap(Map<String, dynamic> json, {this.reference, this.chatId})
      : timestamp = json["timestamp"].toDate(),
        content = json["content"],
        type = json["type"],
        from = json["from"],
        to = json["to"];

  Map<String, dynamic> toMap() => {
        "timestamp": Timestamp.fromDate(timestamp),
        "content": content,
        "type": type,
        "from": from,
        "to": to
      };

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(
          snapshot.data,
          reference: snapshot.reference,
          chatId: snapshot.documentID,
        );
}
