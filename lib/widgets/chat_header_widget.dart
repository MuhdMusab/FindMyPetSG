import 'package:find_my_pet_sg/modal/messagedao.dart';
import 'package:find_my_pet_sg/screens/chat_screen.dart';
import 'package:find_my_pet_sg/screens/mainpage.dart';
import 'package:find_my_pet_sg/screens/search.dart';
import 'package:find_my_pet_sg/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/modal/person.dart';
import 'package:find_my_pet_sg/widgets/pop_up_icon.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List users;
  final String username;

  const ChatHeaderWidget({
    required this.users,
    required this.username,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(right: 12),
                    child: CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.search),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      margin: EdgeInsets.only(right: 12),
                      child: CircleAvatar(
                        radius: 24,
                        child: Icon(Icons.search),
                      ),
                    );
                  } else {
                    final otherUser = users[index - 1];
                    final Storage storage = Storage(otherUser);
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChatScreen(username: otherUser, messageDao: MessageDao(username, otherUser))
                          ));
                        },
                        child: FutureBuilder(
                            future: storage.downloadURL(),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState == ConnectionState.done &&
                                  snapshot.hasData) {
                                return CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                                );
                              }
                            }
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    }

  }
}