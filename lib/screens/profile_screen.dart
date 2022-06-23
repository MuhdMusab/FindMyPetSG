import 'package:file_picker/file_picker.dart';
import 'package:find_my_pet_sg/helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/screens/settings_screen.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/services/storage_service.dart';
import 'package:find_my_pet_sg/screens/mainpage.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/chatroomdao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ProfileScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  ProfileScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    tz.initializeTimeZones();
  }

  ChatroomDao _chatroomDao = ChatroomDao();
  ScrollController _scrollController = ScrollController();
  TextEditingController userNameTextEditingController = TextEditingController();
  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: _chatroomDao.getUserQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Chatroom.fromJson(json);
          print(message.username);
          return Text('data');
        },
      ),
    );
  }

  Future showImageSource(BuildContext context, Storage storage, String username) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Choose image from Gallery'),
              onTap: () async {
                final img = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png']
                );
                if (img == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No file selected'),
                      )
                  );
                  return null;
                }
                final path = img.files.single.path!;
                final fileName = '$username' + '_profile_picture';

                storage.uploadFile(path, fileName);
                FilePickerStatus.done;
                setState(() {});
              },
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final String username = widget._user!['name'].toString();
    final Storage storage = Storage(username);
    final image = Image.asset("assets/images/default_user_icon.png");
    final chatroomDao = ChatroomDao();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "FindMyPetSG",
          style: TextStyle(
            fontSize: 38,
            color: Color(0xFFf26579),
            fontFamily: 'Open Sans Extra Bold',
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            color: Color(0xFFf26579),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                    ))
              },
              icon: Icon(Icons.settings)
          )
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Stack(
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child:  //AssetImage("assets/images/default_user_icon.png",),
                    FutureBuilder(
                        future: storage.downloadURL(),
                        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                            return Ink.image(
                              image: NetworkImage(snapshot.data!),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              child: InkWell(
                                onTap: () async {
                                  showImageSource(context, storage, username);
                                },
                              ),
                            );
                          } else {
                            return Ink.image(
                              image: AssetImage("assets/images/default_user_icon.png",),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                              child: InkWell(
                                onTap: () async {
                                  showImageSource(context, storage, username);
                                },
                              ),
                            );
                          }
                        }
                    ),
                  ),
                ),
                Positioned(
                  bottom: 1,
                  right: 2,
                  child: ClipOval(
                    child: Container(
                      padding: EdgeInsets.all(3),
                      color: Colors.white,
                      child: ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(7),
                          color: Colors.blue,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Text(widget._user!['name'].toString()),
            ElevatedButton(
                onPressed: () async {
                  //chatroomDao.addChatroom(username,  Chatroom(userNameTextEditingController.text));
                  //chatroomDao.addChatroom(userNameTextEditingController.text,  Chatroom(username));
                  NotificationService().showNotification(1, 'title', 'body', 5);
                },
                child: Text('press', style: TextStyle(color: Colors.black),)
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: userNameTextEditingController,
              style: simpleBlackTextStyle(),
              decoration: InputDecoration(
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: "username",
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
