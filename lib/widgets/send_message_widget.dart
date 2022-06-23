import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SendMessageWidget extends StatefulWidget {
  Function? sendMessage;
  TextEditingController? textEditingController;
  Function? canSendMessage;
  ScrollController? scrollController;

  SendMessageWidget({
    Key? key,
    this.sendMessage,
    this.textEditingController,
    this.canSendMessage,
    this.scrollController,
  }) : super(key: key);

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {


  // void _scrollToBottom() {
  //   if (widget.scrollController!.hasClients) {
  //     print('a');
  //     widget.scrollController!.jumpTo(widget.scrollController!.position.maxScrollExtent);
  //     // widget.scrollController!.animateTo(
  //     //   widget.scrollController!.position.maxScrollExtent,
  //     //   duration: const Duration(milliseconds: 300),
  //     //   curve: Curves.easeOut,
  //     // );
  //   } else {
  //     print('b');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: widget.textEditingController,
              onSubmitted: (input) {

                widget.sendMessage!();
              },
              decoration:
              const InputDecoration(hintText: 'Enter new message'),
            ),
          ),
        ),
        IconButton(
            icon: Icon(widget.canSendMessage!()
                ? CupertinoIcons.arrow_right_circle_fill
                : CupertinoIcons.arrow_right_circle),
            onPressed: () {
              widget.sendMessage!();
            })
      ],
    );
  }
}
