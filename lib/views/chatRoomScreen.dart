// import 'package:find_my_pet_sg/helper/authenticate.dart';
// import 'package:find_my_pet_sg/services/auth.dart';
// import 'package:find_my_pet_sg/views/search.dart';
// import 'package:flutter/material.dart';
//
// class ChatRoom extends StatefulWidget {
//   const ChatRoom({Key? key}) : super(key: key);
//
//   @override
//   State<ChatRoom> createState() => _ChatRoomState();
// }
//
// class _ChatRoomState extends State<ChatRoom> with AutomaticKeepAliveClientMixin<ChatRoom>{
//   @override
//   bool get wantKeepAlive => true;
//
//   AuthMethods authMethods = AuthMethods();
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("FindMyPetSG"),
//         actions: [
//           GestureDetector(
//             onTap: () {
//               authMethods.signOut();
//               Navigator.pushReplacement(context, MaterialPageRoute(
//                   builder: (context) => Authenticate()
//               ));
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               child: Icon(Icons.exit_to_app),
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.search),
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(
//               builder: (context) => SearchScreen()
//           ));
//         },
//       ),
//     );
//   }
// }
