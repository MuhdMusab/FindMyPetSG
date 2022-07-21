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
  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  FullPosts({
    Key? key,
    required this.user,
    required this.filters,
    required this.snapshot,
  }) : super(key: key);

  @override
  State<FullPosts> createState() => _FullPostsState();
}

class _FullPostsState extends State<FullPosts>
    with AutomaticKeepAliveClientMixin<FullPosts> {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
        itemCount: widget.snapshot.data!.docs.length,
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
                      widget.snapshot.data!.docs[index].data()['breed'] ==
                          (filter as Category).name;
                } else {
                  postTypeBool = postTypeBool ||
                      widget.snapshot.data!.docs[index].data()['type'] ==
                          (filter as PostType).postType;
                }
              }
            }
          }
          return Container(
              child: postTypeBool && categoryBool
                  ? widget.snapshot.data!.docs[index].data()['type'] == "lost"
                      ? LostPetPost(
                          snap: widget.snapshot.data!.docs[index].data(),
                          user: widget.user,
                        )
                      : FoundPetPost(
                          snap: widget.snapshot.data!.docs[index].data(),
                          user: widget.user,
                        )
                  : Container());
        });
  }
}
