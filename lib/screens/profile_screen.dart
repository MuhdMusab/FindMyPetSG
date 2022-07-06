import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:find_my_pet_sg/helper/google_sign_in_provider.dart';
import 'package:find_my_pet_sg/screens/settings_screen.dart';
import 'package:find_my_pet_sg/services/auth.dart';
import 'package:find_my_pet_sg/services/database.dart';
import 'package:find_my_pet_sg/services/notification_service.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:find_my_pet_sg/services/storage_service.dart';
import 'package:find_my_pet_sg/screens/mainpage.dart';
import 'package:find_my_pet_sg/widgets/own_lost_pet_post.dart';
import 'package:find_my_pet_sg/widgets/own_found_pet_post.dart';
import 'package:find_my_pet_sg/widgets/own_slider_carousel.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:find_my_pet_sg/modal/chatroom.dart';
import 'package:find_my_pet_sg/modal/chatroomdao.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  StreamSubscription<DocumentSnapshot>? subscription;
  List<DocumentSnapshot>? myList;

  //final DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.);

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    // _activateListeners();
  }

  // void _activateListeners() {
  //   final String username = widget._user!['name'].toString();
  //   FirebaseDatabase.instance.ref().child(username).onValue.listen((event) {
  //     final String message = event.snapshot.value as String;
  //     NotificationService().showNotification(1, "new message ", message, 2);
  //   });
  // }
  ChatroomDao _chatroomDao = ChatroomDao();
  ScrollController _scrollController = ScrollController();
  TextEditingController userNameTextEditingController = TextEditingController();

  Future showImageSource(BuildContext context, Storage storage, String username) async {
    showModalBottomSheet(
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
                String profilePicLink = await storage.downloadURL();
                DatabaseMethods.editProfilePicLink(username, profilePicLink);
                FilePickerStatus.done;
                Navigator.pop(context);
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
    int postLength = 0;
    _callback() {
      setState(() {});
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(),
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
      body: Column(
        children: [
          SizedBox(height: 10,),
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: [
                ClipOval(
                  child: Material(
                    color: Colors.transparent,
                    child: FutureBuilder(
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
          ),
          SizedBox(height: 10,),
          Text(
            "Hello, " + widget._user!['name'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FutureBuilder<Map<String, dynamic>>(
                  future: DatabaseMethods.getUserPosts(username),
                  builder: (context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      //do nothing
                    } else {
                      postLength = snapshot.data!.length;
                    }
                    return Text(
                      "Your posts (" + postLength.toString() + ")",
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

              ),
            ),
          ),
          SizedBox(height: 20,),
          Divider(
            height: 1,
            thickness: 2,
            color: Colors.white,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  int postIndex = 0;
                  ListView listView = ListView.builder(
                    itemBuilder: (ctx, index) =>
                    index < snapshot.data!.docs.length && snapshot.data!.docs[index].data()['username'] == username
                        ? snapshot.data!.docs[index].data()['type'] == 'lost'
                          ? OwnLostPetPost(snapshot: snapshot.data!.docs[index].data(),
                              postIndex: postIndex++, username: username, callback: _callback,
                                postId: snapshot.data!.docs[index].data()['postId'],)
                          : OwnFoundPetPost(snapshot: snapshot.data!.docs[index].data(),
                              postIndex: postIndex++, username: username, callback: _callback,
                                postId: snapshot.data!.docs[index].data()['postId'],)
                          : Container(),
                    itemCount: snapshot.data!.docs.length,
                  );
                  postLength = postIndex + 1;
                  return listView;
                }
            ),
          ),
        ],
      ),
    );
  }
}
