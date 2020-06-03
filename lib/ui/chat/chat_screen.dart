import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/models/chat.dart';
import 'package:roommatematcher/core/models/user.dart';
import 'package:roommatematcher/core/repository/user_repository.dart';
import 'package:roommatematcher/utils/circular_progress_loading.dart';
import 'package:roommatematcher/utils/make_phone_call.dart';

class ChatScreen extends StatefulWidget {
  final ChatGroup chat;
  final User peer;

  const ChatScreen({Key key, this.chat, this.peer}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() async {
    if (_messageController.text.trim() != '') {
      User currentUser = await UserRepository().getCurrentUser();
      Message message = Message(
          to: widget.peer.reference,
          from: currentUser.reference,
          timestamp: DateTime.now(),
          content: _messageController.text,
          type: "0");
      DocumentReference messageReference = widget.chat.messages
          .document(message.timestamp.millisecondsSinceEpoch.toString());
      try {
        await messageReference.setData(message.toMap());
        _messageController.clear();
      } catch (e) {
        print('Message send error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peer.name),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: Theme.of(context).textTheme.copyWith(
              headline6: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(color: Colors.black),
            ),
        actions: <Widget>[
          // TODO: Include call function
          IconButton(
              icon: Icon(Icons.call),
              onPressed: () => makePhoneCall(widget.peer.phone)),
        ],
      ),
      body: StreamBuilder(
          stream: widget.chat.messages.orderBy('timestamp').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('There was an error trying to load this chat');
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  Message message =
                      Message.fromSnapshot(snapshot.data.documents[index]);
                  bool isFromUser = message.from.path == user.reference.path;
                  return Row(
                    mainAxisAlignment: isFromUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: isFromUser
                                ? Colors.white
                                : Colors.blueGrey.shade700,
                            height: 1.4,
                          ),
                        ),
                        padding: EdgeInsets.all(8),
                        margin: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isFromUser
                              ? Colors.deepOrange
                              : Colors.lightBlueAccent.shade50,
                        ),
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .7,
                        ),
                      ),
                    ],
                  );
                },
                itemCount: snapshot.data.documents.length,
              );
            }

            return CircularProgressLoading();
          }),
      bottomSheet: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 10,
              color: Colors.deepOrange.shade200,
            )
          ],
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: 6,
                minLines: 1,
                decoration: InputDecoration(
                  hintText: 'Type your message',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  fillColor: Colors.grey,
                ),
              ),
            ),
            IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
