import 'package:find_my_pet_sg/models/filter_model.dart';
import 'package:find_my_pet_sg/models/post_type_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_my_pet_sg/models/category.dart';
import '../widgets/lost_pet_post.dart';
import '../widgets/found_pet_post.dart';

class FullPosts extends StatefulWidget {
  List<Filter?> filters;
  QueryDocumentSnapshot<Object?>? user;
  FullPosts({
    Key? key,
    required this.user,
    required this.filters,
  }) : super(key: key);

  @override
  State<FullPosts> createState() => _FullPostsState();
}

class _FullPostsState extends State<FullPosts> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy("dateTimePosted", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (ctx, index) {
                bool postTypeBool = true;
                bool categoryBool = true;
                if (widget.filters.isNotEmpty) {
                  postTypeBool = false;
                  categoryBool = false;
                  for (int i = 0; i < 16; i++) {
                    Filter filter = widget.filters[i]!;
                    if (filter.value) {
                      if (filter is Category) {
                        categoryBool = categoryBool ||
                            snapshot.data!.docs[index].data()['breed'] ==
                                (filter as Category).name;
                      } else {
                        postTypeBool = postTypeBool ||
                            snapshot.data!.docs[index].data()['type'] ==
                                (filter as PostType).postType;
                      }
                    }
                  }
                }
                return Container(
                    child: postTypeBool && categoryBool
                        ? snapshot.data!.docs[index].data()['type'] == "lost"
                        ? LostPetPost(
                      snap: snapshot.data!.docs[index].data(),
                      user: widget.user,
                    )
                        : FoundPetPost(
                      snap: snapshot.data!.docs[index].data(),
                      user: widget.user,
                    )
                        : Container()
                );
              }
          );
        },
      ),
    );
  }
}
