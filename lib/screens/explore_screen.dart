import 'package:find_my_pet_sg/widgets/custom_dialog_box.dart';
import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';
import '../widgets/search_textfield.dart';
import 'create_lost_post_screen.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

int _selectedPageIndex = 0;
List<Widget>? _pages;
PageController? _pageController;

class ExploreScreen extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? _user;

  ExploreScreen(QueryDocumentSnapshot<Object?>? user) {
    this._user = user;
  }

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with AutomaticKeepAliveClientMixin<ExploreScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return CustomDialogBox(title: "Have you Lost or Found a pet?", descriptions: "poop", text: "yes", user: widget._user);

          });
        },
        child: new Icon(
          Icons.add,
          size: 40.0,
          color: Colors.white,
        ),
        elevation: 8.0,
      ),
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 18, bottom: 10),
              child: SearchTextField(),
            ),
          ),
          Divider(
            height: 1,
            thickness: 2,
            color: Colors.pink,
          ),
          Expanded(
            child: StreamBuilder(
              stream:
              FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    child: snapshot.data!.docs[index].data()['type'] == "lost"
                      ? LostPetPost(
                      snap: snapshot.data!.docs[index].data(),
                      user: widget._user,
                    )
                        : FoundPetPost(
                      snap: snapshot.data!.docs[index].data(),
                      user: widget._user,
                    )
                    ,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
    // )

    // Column(
    //   children: [
    //     SafeArea(
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 12, top: 18, bottom: 10),
    //         child: SearchTextField(),
    //       ),
    //     ),
    //     Divider(
    //       height: 1,
    //       thickness: 2,
    //       color: Colors.pink,
    //     ),
    //   ],
    // ),
    // );
  }
}