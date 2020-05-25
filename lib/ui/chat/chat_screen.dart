import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/models/chat.dart';
import 'package:roommatematcher/core/models/user.dart';
import 'package:roommatematcher/utils/circular_progress_loading.dart';

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

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.peer.name),
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
                  Message message = Message.fromSnapshot(snapshot.data[index]);
                  return Container(
                    child: Text(message.content),
                    constraints: BoxConstraints(maxWidth: 240),
                    alignment: message.from == user.reference
                        ? Alignment.bottomRight
                        : Alignment.bottomLeft,
                    width: double.infinity,
                  );
                },
                itemCount: snapshot.data.length,
              );
            }

            return CircularProgressLoading();
          }),
      bottomSheet: Row(
        children: <Widget>[
          TextField(
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
          IconButton(
            onPressed: () async {
              // TODO: Add send message function
              _messageController.clear();
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
