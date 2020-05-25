import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:roommatematcher/core/blocs/auth_bloc.dart';
import 'package:roommatematcher/core/models/chat.dart';
import 'package:roommatematcher/core/models/user.dart';
import 'package:roommatematcher/utils/circular_progress_loading.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {

  @override
  Widget build(BuildContext context) {
    final user =
        (BlocProvider.of<AuthenticationBloc>(context).state as Authenticated)
            .user;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        /// Things get really messy from here

        stream: Firestore.instance
            .collection('messages')
            .where('members', arrayContains: user.reference)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(
                'There was an error fetching your chats. Please check your connection and try again.');
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> data = snapshot.data.documents;
            List<ChatGroup> chats =
                data.map((e) => ChatGroup.fromSnapshot(e)).toList();
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) => FutureBuilder(
                  future: chats[index]
                      .members
                      .firstWhere((element) => element != user.reference)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Container();
                    }
                    if (snapshot.hasData) {
                      User peer = User.fromSnapshot(snapshot.data);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0xffcccccc),
                          backgroundImage: NetworkImage(peer.displayPic),
                        ),
                        title: Text(peer.name),
                        subtitle: Text(
                          'Hey there',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                        trailing: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.deepOrange,
                        ),
                        // TODO: Add onTap function
                      );
                    }

                    return ListTile();
                  }),
              itemCount: chats.length,
            );
          }
          return CircularProgressLoading();
        },
      ),
    );
  }
}
