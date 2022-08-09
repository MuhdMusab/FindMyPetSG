import 'dart:ui';

import 'package:find_my_pet_sg/config/constants.dart';
import 'package:find_my_pet_sg/helper/functions.dart';
import 'package:find_my_pet_sg/models/message_model.dart';
import 'package:find_my_pet_sg/models/messagedao.dart';
import 'package:find_my_pet_sg/services/storage_methods.dart';
import 'package:find_my_pet_sg/widgets/highlighted_message_widget.dart';
import 'package:find_my_pet_sg/widgets/message_widget.dart';
import 'package:find_my_pet_sg/widgets/message_widget_with_date.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageList extends StatefulWidget {
  final MessageDao messageDao;
  final ScrollController scrollController;
  final CircleAvatar circleAvatar;

  const MessageList({
    required this.messageDao,
    required this.scrollController,
    required this.circleAvatar,
    key,
  }) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  @override
  void initState() {
    super.initState();
  }

  bool _isButtonVisible = false;
  bool _isFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    int _prevDate = 32;
    void _scrollToBottom() {
      if (widget.scrollController.hasClients) {
        setState(() {
          _isButtonVisible = false;
        });
        widget.scrollController
            .jumpTo(widget.scrollController.position.maxScrollExtent);
      }
    }

    return Expanded(
      child: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.atEdge) {
            setState(() {
              _isButtonVisible = false;
            });
          }
          if (notification.direction == ScrollDirection.forward) {
            setState(() {
              _isButtonVisible = false;
            });
          } else if (notification.direction == ScrollDirection.reverse) {
            setState(() {
              _isButtonVisible = true;
            });
          }
          return true;
        },
        child: Stack(
          children: [
            FirebaseAnimatedList(
              physics: BouncingScrollPhysics(),
              controller: widget.scrollController,
              query: widget.messageDao.getOwnMessageQuery(),
              itemBuilder: (context, snapshot, animation, index) {
                Map<dynamic, dynamic> json =
                    snapshot.value as Map<dynamic, dynamic>;
                if (json['imageUrl'] == null) {
                  json['imageUrl'] = '';
                }
                final message = Message.fromJson(json);
                if (message.date.day != _prevDate) {
                  _prevDate = message.date.day;
                  return GestureDetector(
                    child: MessageWidgetWithDate(
                      message: message.text,
                      isMe: message.isMe,
                      date: message.date,
                      messageDao: widget.messageDao,
                      circleAvatar: widget.circleAvatar,
                      imageUrl: message.imageUrl,
                    ),
                    onLongPress: () {
                      setState(() {
                        _isFilterVisible = true;
                      });
                      showDialog(
                          barrierColor: Colors.white.withOpacity(0),
                          context: context,
                          builder: (builder) {
                            return HighlightedMessageWidget(
                              message: message.text,
                              isMe: message.isMe,
                              date: message.date,
                              messageDao: widget.messageDao,
                              imageUrl: message.imageUrl,
                            );
                          }).then((value) => {
                            setState(() {
                              _isFilterVisible = false;
                            })
                          });
                    },
                  );
                }
                return GestureDetector(
                  child: MessageWidget(
                    message: message.text,
                    isMe: message.isMe,
                    date: message.date,
                    messageDao: widget.messageDao,
                    circleAvatar: widget.circleAvatar,
                    imageUrl: message.imageUrl,
                  ),
                  onLongPress: () {
                    setState(() {
                      _isFilterVisible = true;
                    });
                    showDialog(
                        barrierColor: Colors.white.withOpacity(0),
                        context: context,
                        builder: (builder) {
                          return HighlightedMessageWidget(
                            message: message.text,
                            isMe: message.isMe,
                            date: message.date,
                            messageDao: widget.messageDao,
                            imageUrl: message.imageUrl,
                          );
                        }).then((value) => {
                          setState(() {
                            _isFilterVisible = false;
                          })
                        });
                  },
                );
              },
            ),
            _isButtonVisible
                ? Positioned(
                    bottom: 10,
                    left: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        _scrollToBottom();
                      },
                      backgroundColor: pink(),
                      heroTag: getRandomString(),
                      child: Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Container(),
            _isFilterVisible
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
