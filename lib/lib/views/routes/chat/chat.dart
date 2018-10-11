//import 'dart:ui';

// import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:sharpchat/utils/custom_circular_icon_button.dart' as Util;

const double _stackedProfileBarHeight = 114.0;
const double _stackedEntryBoxHeight = 112.0;
const double _anchorBoxHeight = _stackedEntryBoxHeight - 36.0;
const int _minTextLength = 0;

class Chat extends StatefulWidget {
  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> with TickerProviderStateMixin {
  FocusNode focusNode;
  TextEditingController textEditingController;

  //static const double _stackedProfileBarHeight = 114.0;
  //static const double _stackedEntryBoxHeight = 112.0;
  //static const double _anchorBoxHeight = _stackedEntryBoxHeight - 36.0;
  //static const int _minTextLength = 0;

  final NetworkImage networkImage =
      NetworkImage("https://source.unsplash.com/random/800*600");
  final ImageProvider image = Image.network(
          'https://randomuser.me/api/portraits/women/${math.Random().nextInt(100)}.jpg')
      .image;
  //final NetworkImage networkImage =
  //NetworkImage("https://picsum.photos/600/400/?random");
  //final ImageProvider image =
  //Image.network('https://picsum.photos/200/300/?random').image;

  //final List<MessageBubble> children = List.generate(30, (int index) => MessageBubble("Message $index seed: ${math.Random().nextInt((index+10)*(index+1))}", (index%3)==0));

  final List<MessageBubble> children = <MessageBubble>[];
  AnimationController scaleAnimationController;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    textEditingController = TextEditingController();
    scaleAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    focusNode.dispose();
    scaleAnimationController.dispose();
    textEditingController.dispose();
    //May be removed;
    super.dispose();
  }

  Widget buildListChatBox() {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white54,
              image: DecorationImage(
                  image: networkImage,
                  fit: BoxFit.cover,
                  alignment: Alignment.center)),
          child: new Column(children: <Widget>[
            Flexible(
                child: ListView.builder(
              padding: const EdgeInsets.only(
                  top: _stackedProfileBarHeight + 4.0, left: 8.0, right: 8.0),
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemBuilder: (_, int index) => children[index],
              itemCount: children.length,
            )),
            buildEntryBox()
          ]),
        ),
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: ProfileBar(image, focusNode),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomSheet: BottomSheet(onClosing: null, builder: null),
      body: buildListChatBox(),
    );
  }

  void forwardScaleAnimation() {
    if (scaleAnimationController.value != 0.0) return;
    scaleAnimationController.forward();
  }

  void reverseScaleAnimation() {
    if (scaleAnimationController.value != 1.0) return;
    scaleAnimationController.reverse();
  }

  void createMessage() {
    MessageBubble m = MessageBubble(
      textEditingController.text,
      (children.length % 3 == 0) || (children.length % 7 == 0),
    );
    setState(() {
      children.insert(0, m);
    });
    //m.animationController.forward();
    textEditingController.clear();
    reverseScaleAnimation();
  }

  Widget buildEntryBox() => Container(
        height: _stackedEntryBoxHeight,
        child: Stack(
          //crossAxisAlignment: CrossAxisAlignment.stretch,
          //fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            LimitedBox(
              maxHeight: _anchorBoxHeight,
              child: Container(
                color: Colors.white.withOpacity(0.9),
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: TextField(
                  maxLines: 4,
                  autofocus: false,
                  onSubmitted: (String submitString) {
                    print("Done: $submitString");
                  },
                  onChanged: (String span) {
                    (span.length > _minTextLength)
                        ? forwardScaleAnimation()
                        : reverseScaleAnimation();
                  },
                  controller: textEditingController,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.text,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      isDense: true,
                      hintText: 'break the ice',
                      border: InputBorder.none),
                ),
              ),
            ),
            Positioned(
              right: 8.0,
              top: 8.0,
              child: Row(
                children: <Widget>[
                  ScaleTransition(
                      scale: CurvedAnimation(
                          parent: scaleAnimationController,
                          curve: Curves.fastOutSlowIn),
                      child: Util.CustomIconButton(
                        createMessage,
                        iconData: Icons.send,
                        buttonColor: Colors.lightGreen,
                      )),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Util.CustomIconButton(
                    null,
                    iconData: Icons.attach_file,
                    buttonColor: Colors.lightBlue,
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Util.CustomIconButton(
                    null,
                    iconData: Icons.keyboard_voice,
                    buttonColor: Colors.lightBlue,
                  ),
                ],
              ),
            )
          ],
        ),
      );

  Widget buildEntryBar() {
    return Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: buildEntryBox(),
    );
  }
}

class ProfileBar extends StatefulWidget {
  final NetworkImage image;
  final FocusNode focusNode;

  ProfileBar(this.image, this.focusNode, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ProfileBarState(image, focusNode);
  }
}

class ProfileBarState extends State<ProfileBar> with TickerProviderStateMixin {
  final NetworkImage profileImage;
  final NetworkImage bannerImage =
      NetworkImage("https://source.unsplash.com/random");
  final FocusNode _focusNode;
  OverlayEntry _overlayEntry;
  AnimationController overlayController;
  // Animation<double> fadeAnimation;
  // Animation<Offset> offsetAnimation;
  Animation<double> offsetAnimationB;
  Animation<double> blurOpacity;

  ProfileBarState(this.profileImage, this._focusNode) : super();

  @override
  void initState() {
    super.initState();
    overlayController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    offsetAnimationB = Tween<double>(begin: 48.0, end: 0.0).animate(CurvedAnimation(parent: overlayController, curve: Interval(0.0, 0.8, curve: Curves.ease)));
    blurOpacity = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: overlayController, curve: Curves.ease));
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return AnimatedBuilder(
            animation: overlayController,
            builder: (BuildContext context, Widget child) {
              return Material(
                color: Colors.black38.withOpacity(blurOpacity.value),
                child: Transform.translate(
                  offset: Offset(0.0, offsetAnimationB.value),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: overlayController.value,
                    child: child,
                  ),
                ),
              );
            },
            child: buildVcard());
      },
    );
  }

  @override
  void dispose() {
    overlayController.dispose();
    super.dispose();
  }

  Widget buildVcard() {
    return Card(
        color: Colors.white,
        //color: Colors.transparent,
        margin:
            EdgeInsets.only(top: _stackedProfileBarHeight + 4.0, left: 8.0, right: 8.0, bottom: _stackedEntryBoxHeight),
        child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                //centerTitle: true,
                //backgroundColor: Colors.lightGreen,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                title: CircleAvatar(
                  //child: Text('R'),
                  backgroundColor: Colors.lightBlue,
                  backgroundImage: profileImage,
                ),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        topRight: Radius.circular(4.0)),
                    image: DecorationImage(
                        alignment: Alignment.center,
                        image: bannerImage,
                        fit: BoxFit.cover),
                  ),
                ),
                //TODO: Respect image Dimensions!
                expandedHeight: 200.0,
                bottom: PreferredSize(
                    child: Container(
                      transform: Matrix4.translationValues(0.0, 15.0, 0.0),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Util.CustomIconButton(
                            exitOverlay,
                            iconData: Icons.vpn_key,
                            buttonColor: Colors.lightBlue,
                          ),
                          Padding(padding: const EdgeInsets.all(8.0)),
                          Util.CustomIconButton(
                            exitOverlay,
                            iconData: Icons.block,
                            buttonColor: Colors.redAccent,
                          ),
                          Padding(padding: const EdgeInsets.all(8.0)),
                          Util.CustomIconButton(
                            exitOverlay,
                            iconData: Icons.close,
                            buttonColor: Colors.redAccent,
                          )
                        ],
                      ),
                    ),
                    preferredSize: Size.fromHeight(30.0)),
                pinned: true,
              ),
              SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        ListTile(
                          title: Text("Ras A'ghul",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                          subtitle: Text("Status or Vision or Motto or stuff"),
                          dense: true,
                          trailing: Icon(
                            Icons.account_circle,
                            color: Colors.lightBlue,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Events",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          subtitle:
                              Text("Currently you have no shared events "),
                          dense: true,
                          trailing: Icon(
                            Icons.perm_contact_calendar,
                            color: Colors.lightBlue,
                          ),
                        ),
                        Divider(),
                        ListTile(
                          title: Text(
                            "Media",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          subtitle: Text("Currently you have no shared media "),
                          dense: true,
                          trailing: Icon(
                            Icons.perm_media,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                  )),
            ]));
  }

  exitOverlay() {
    overlayController.reverse().whenCompleteOrCancel(_overlayEntry.remove);
  }

  createOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    if (_focusNode.hasFocus) _focusNode.unfocus();
    overlayState.insert(_overlayEntry);
    overlayController.forward();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          createOverlay(context);
        },
        child: Container(
            height: _stackedProfileBarHeight,
            //margin: EdgeInsets.only(top: 4.0,left: 4.0,right: 4.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.7),
              //borderRadius: BorderRadius.circular(50.0)
            ),
            // padding: EdgeInsets.symmetric(vertical: 4.0),
            child: SafeArea(
                child: Container(
              margin: EdgeInsets.only(top: 8.0),
              child: new Row(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.,
                children: <Widget>[
                  IconButton(
                      tooltip: 'Back to messages',
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.maybePop(context);
                      }),
                  Expanded(
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4.0),
                            child: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.all(Radius.elliptical(16.0, 16.0)),
                                  shape: BoxShape.circle,
                                  // border: Border.all(color: Colors.white, width: 2.0),
                                  image: DecorationImage(
                                      image: profileImage,
                                      fit: BoxFit.cover,
                                      alignment: Alignment.center)),
                            )),
                        Text(
                          'Ras A\'ghul',
                          style: TextStyle(fontSize: 14.0, color: Colors.black),
                        ),
                      ],
                    )),
                  ),
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.black),
                    onPressed: () {
                      print('Sup!');
                    },
                  ),
                ],
              ),
            ))),
      );
}

class MessageBubble extends StatelessWidget {
  final String bubbleText;
  final bool isActiveUser;

  MessageBubble(this.bubbleText, this.isActiveUser, {Key key})
      : super(key: key);

  Widget _messageBubble(BorderRadius radius, Color bg) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment:
          isActiveUser ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Column(
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 250.0),
                child: Text(bubbleText,
                    softWrap: true,
                    style: TextStyle(
                        //color: Colors.black38,
                        fontSize: 14.0)),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = isActiveUser ? Colors.white : Colors.greenAccent.shade100;
    final radius = isActiveUser
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return _messageBubble(radius, bg);
  }
}
