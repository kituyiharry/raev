import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ProfileWrapper extends SliverPersistentHeaderDelegate {
  final AnimationController homeAnimationController;
  final Animation marginAnimation;
  final Animation borderAnimation;
  final Widget child;
  final bool boxScroll;

  ProfileWrapper(
      {this.homeAnimationController,
      this.marginAnimation,
      this.borderAnimation,
      this.child,
      this.boxScroll})
      : super();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build

    return new AnimatedBuilder(
      animation: marginAnimation,
      child: ProfileHeader(
        listenable: homeAnimationController,
        tabChild: child,
        shouldRenderMore: boxScroll,
      ),
      builder: (BuildContext context, Widget child) => Material(
            // elevation: boxScroll ? 4.0 : 0.0,
            // color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: marginAnimation.value),
              decoration: BoxDecoration(
                // color: Colors.transparent
                //  border: Border.all(),
                gradient: LinearGradient(colors: [
                  Color(0xff89f7fe),
                  Color(0xff66a6ff),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: borderAnimation.value,
              ),
              child: child,
            ),
          ),
    );
  }

  // TODO: implement maxExtent
  @override
  double get maxExtent => 270.0;

  // TODO: implement minExtent
  @override
  double get minExtent => 150.0;

  @override
  bool shouldRebuild(ProfileWrapper oldDelegate) {
    // TODO: implement shouldRebuild
    return oldDelegate.minExtent != minExtent ||
        oldDelegate.maxExtent != maxExtent ||
        oldDelegate.child != oldDelegate.child;
  }
}

class ProfileHeader extends AnimatedWidget {
  final Widget tabChild;
  final bool shouldRenderMore;

  ProfileHeader(
      {Key key, Listenable listenable, this.tabChild, this.shouldRenderMore})
      : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    Animation<double> radiusAnim = Tween<double>(begin: 50.0, end: 60.0)
        .animate(ReverseAnimation(listenable));
    Animation<double> opacityAnim = ReverseAnimation(listenable);
    // TODO: implement build
    return SafeArea(
        child: Container(
      margin: EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Padding(padding: EdgeInsets.all(12.0),),
          new Row(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.,
            children: <Widget>[
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child:
                      /*CircleAvatar(
                           child: new Text('H'),
                           backgroundColor: Colors.blue,
                           radius: radiusAnim.value,
                           ),*/
                      Container(
                    width: radiusAnim.value,
                    height: radiusAnim.value,
                    decoration: BoxDecoration(
                        //borderRadius: BorderRadius.all(Radius.elliptical(16.0, 16.0)),
                        shape: BoxShape.circle,
                        // border: Border.all(color: Colors.white, width: 2.0),
                        image: DecorationImage(
                            image: AssetImage('assets/images/flowers.jpg'),
                            fit: BoxFit.cover,
                            alignment: Alignment.center)),
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.,
                  children: <Widget>[
                    Text(
                      'Harry K',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    Text(
                      'Justice always prevails',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  print('Sup!');
                },
              ),
            ],
          ),
          Expanded(
              child: AnimatedOpacity(
            //padding: const EdgeInsets.all(8.0),
            opacity: opacityAnim.value,
            duration: Duration(milliseconds: 300),
            child: ClipRect(
                child: Container(
                    //padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8.0),
                    //margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                    alignment: Alignment.center,
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 20.0),
                      // isThreeLine: true,
                      leading: CircleAvatar(child: Icon(Icons.local_dining)),
                      title: Text('Dinner at Basket!'),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            size: 12.0,
                          ),
                          Text('Imara Gardens, Embakasi'),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (BuildContext c) {
                          return [
                            PopupMenuItem(
                                child: Text(
                              'Join',
                              style: TextStyle(fontSize: 14.0),
                            )
                            ),
                            PopupMenuItem(
                                child: Text('Snooze',
                                    style: TextStyle(fontSize: 14.0))),
                            PopupMenuItem(
                                child: Text('Cancel',
                                    style: TextStyle(fontSize: 14.0))),
                          ];
                        },
                      ),
                    ))),
          )),
          // PreferredSize(child: tabChild, preferredSize: Size.fromHeight(70.0))
          tabChild
        ],
      ),
    ));
  }
}

// BakedWorkaround
