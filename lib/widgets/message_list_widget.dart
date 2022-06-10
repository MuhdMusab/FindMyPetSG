import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MessageList extends StatefulWidget {
  Function? sendMessage;
  TextEditingController? textEditingController;
  Function? canSendMessage;

  MessageList({
    Key? key,
    this.sendMessage,
    this.textEditingController,
    this.canSendMessage,
  }) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  void callback() {
    setState(() {});
  }
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

                widget.sendMessage!(callback);
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
              widget.sendMessage!(callback);
            })
      ],
    );
  }
}
