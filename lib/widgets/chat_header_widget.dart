import 'package:find_my_pet_sg/screens/mainpage.dart';
import 'package:find_my_pet_sg/screens/search.dart';
import 'package:find_my_pet_sg/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:find_my_pet_sg/modal/person.dart';
// import 'package:find_my_pet_sg/widgets/pop_up_icon.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List users;

  const ChatHeaderWidget({
    required this.users,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        width: double.infinity,
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
                    final user = users[index - 1];
                    final Storage storage = Storage(user);
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => SearchScreen(
                                  user) //ChatPage(user: users[index]),
                              ));
                        },
                        child: FutureBuilder(
                            future: storage.downloadURL(),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                return CircleAvatar(
                                  radius: 24,
                                  backgroundImage: NetworkImage(snapshot.data!),
                                );
                              } else {
                                return CircleAvatar(
                                  radius: 24,
                                  backgroundImage: AssetImage(
                                      "assets/images/default_user_icon.png"),
                                );
                              }
                            }),
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
