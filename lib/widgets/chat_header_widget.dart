import 'package:find_my_pet_sg/models/messagedao.dart';
import 'package:find_my_pet_sg/screens/chat_screen.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:flutter/material.dart';

class ChatHeaderWidget extends StatefulWidget {
  final List users;
  final String username;

  const ChatHeaderWidget({
    required this.users,
    required this.username,
    key,
  }) : super(key: key);

  @override
  State<ChatHeaderWidget> createState() => _ChatHeaderWidgetState();
}
class _ChatHeaderWidgetState extends State<ChatHeaderWidget> {
  CircleAvatar _circleAvatar = CircleAvatar(
    radius: 25,
    backgroundImage: AssetImage("assets/images/default_user_icon.png"),
  );

  @override
  Widget build(BuildContext context) {
    if (widget.users.isEmpty) {
      return Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 40, bottom: 12),
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
                itemCount: widget.users.length + 1,
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
                    final otherUser = widget.users[index - 1];
                    final StorageMethods storage = StorageMethods(
                        username: otherUser);
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () async {
                          final StorageMethods storage = StorageMethods(username: otherUser);
                          String url = await storage.downloadURL();
                          CircleAvatar _circleAvatar = url == 'fail'
                              ? CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                          )
                              : CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(url),
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(
                                    username: otherUser,
                                    messageDao: MessageDao(
                                        widget.username, otherUser),
                                    circleAvatar: _circleAvatar,),
                              fullscreenDialog: true
                          ));
                        },
                        child: FutureBuilder(
                            future: storage.downloadURL(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done &&
                                  snapshot.hasData) {
                                _circleAvatar = snapshot.data == 'fail'
                                    ? CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_user_icon.png"),
                                )
                                    : CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                                return _circleAvatar;
                              } else {
                                return CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_user_icon.png"),
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
    } else {
      return Container(
        padding: EdgeInsets.only(left: 12, right: 12, top: 40, bottom: 12),
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
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                    final otherUser = widget.users[index];
                    final StorageMethods storage = StorageMethods(
                        username: otherUser);
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () async {
                          final StorageMethods storage = StorageMethods(username: otherUser);
                          String url = await storage.downloadURL();
                          CircleAvatar _circleAvatar = url == 'fail'
                              ? CircleAvatar(
                            radius: 25,
                            backgroundImage: AssetImage("assets/images/default_user_icon.png"),
                          )
                              : CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(url),
                          );
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ChatScreen(
                                    username: otherUser,
                                    messageDao: MessageDao(
                                        widget.username, otherUser),
                                    circleAvatar: _circleAvatar,),
                              fullscreenDialog: true
                          ));
                        },
                        child: FutureBuilder(
                            future: storage.downloadURL(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done &&
                                  snapshot.hasData) {
                                _circleAvatar = snapshot.data == 'fail'
                                    ? CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_user_icon.png"),
                                )
                                    : CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                                return _circleAvatar;
                              } else {
                                return CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_user_icon.png"),
                                );
                              }
                            }
                        ),
                      ),
                    );
                },
              ),
            )
          ],
        ),
      );
    }
  }
}
