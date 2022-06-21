import 'package:find_my_pet_sg/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/lost_pet_post.dart';
import '../widgets/search_textfield.dart';
import 'create_post_screen.dart';

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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePostScreen()),
          );
          // Navigator.pushNamed(context, CreatePostPage.route);
        },
        child: new Icon(Icons.add, size: 40.0),
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
                    child: LostPetPost(
                      snap: snapshot.data!.docs[index].data(),
                    ),
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
