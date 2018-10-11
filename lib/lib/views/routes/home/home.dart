// import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

import 'package:sharpchat/views/routes/home/home_widgets/profile_sliver_header.dart'
as Profile;
import 'package:sharpchat/views/routes/home/home_widgets/bubble_decoration.dart'
as Bubble;
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
//import 'package:sticky_headers/sticky_headers.dart';



class TabTitleState extends StatelessWidget {
  final bool isActive;
  final String title;

  TabTitleState({Key key, this.isActive, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: Container(),
        secondChild: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 12.0),
            ),
          ),
        crossFadeState:
        isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: new Duration(milliseconds: 200));
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final List<Map> _tabs = [
    {'icon': Icons.message, 'title': 'CHAT', 'index': 0},
    {'icon': Icons.event, 'title': 'EVENTS', 'index': 1},
    {'icon': Icons.contacts, 'title': 'CONTACTS', 'index': 2},
  ];

  AnimationController homeAnimationController;
  Animation<double> marginAnimation;
  Animation<BorderRadius> borderRadiusAnimation;
  //ScrollController nestedScrollViewController;
  TabController _tabController;
  //Widget rng; //for Testing if the widget tree is being rebuilt!

  //final GlobalObjectKey messageBoxCardKey  = GlobalKey();
  final GlobalKey nestedScrollCardKey  = GlobalKey();
  Animation<double> cardOpacity;


  void _animateTabCallBack() {
    //if(!_tabController.indexIsChanging)
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //nestedScrollViewController = new ScrollController();
    _tabController = new TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_animateTabCallBack);
    homeAnimationController = new AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 800,
          ),
        );
    marginAnimation = new Tween<double>(begin: 8.0, end: 0.0).animate(
        CurvedAnimation(
          parent: homeAnimationController.view, curve: Curves.easeIn));
    borderRadiusAnimation = new BorderRadiusTween(
        begin: BorderRadius.circular(8.0), end: BorderRadius.circular(0.0))
      .animate(CurvedAnimation(
            parent: homeAnimationController, curve: Curves.easeIn));
  }

  void dispose() {
    homeAnimationController.dispose();
    //nestedScrollViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget buildDelegatedSliverHeader(bool innerBoxiIsScrolled) {
    return new SliverPersistentHeader(
        delegate: Profile.ProfileWrapper(
          homeAnimationController: homeAnimationController,
          marginAnimation: marginAnimation,
          borderAnimation: borderRadiusAnimation,
          boxScroll: innerBoxiIsScrolled,
          child: Material(
            color: Colors.transparent,
            child: PreferredSize(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,
                        ),
                      ),
                    Flexible(
                      flex: 2,
                      child: new TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: Colors.amber,
                        indicatorSize: TabBarIndicatorSize.label,
                        //indicatorPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        indicatorWeight: 2.0,
                        // These are the widgets to put in each tab in the tab bar.
                        tabs: _tabs
                        .map((Map header) => new Tab(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Icon(
                                  header['icon'],
                                  size: 14.0,
                                  ),
                                //Spacer(),
                                TabTitleState(
                                  isActive: _tabController.index ==
                                  header['index'],
                                  title: header['title'],
                                  )
                              ],
                              ),
                            ))
                        .toList(),
                      ))
                        ],
                        )),
                        preferredSize: Size.fromHeight(30.0)),
                        ),
                        ),
                        pinned: true);
  }

  Widget createPaddedHeaderList(Map<String, String> model, int items) {



    return new SliverPadding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        // In this example, the inner scroll subWidgetsview has
        // fixed-height list items, hence the use of
        // SliverFixedExtentList. However, one could use any
        // sliver widget here, e.g. SliverList or SliverGrid.
        //
        sliver: new SliverStickyHeader(
          overlapsContent: false,
          header:
          /*BackdropFilter(
            filter: UI.ImageFilter.blur(sigmaY: 10.0,sigmaX: 10.0),
            child: */
          new Container(
            height: 30.0,
            //margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.90),
              ),
            padding:
            EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            alignment: Alignment.centerLeft,
            //padding: EdgeInsets.symmetric(horizontal: 16.0),
            //alignment: Alignment.l,
            child: Text(model['title'])),
          //),
          sliver: new SliverList(
            delegate: new SliverChildBuilderDelegate(
              (context, i) {

                return 
                  InkWell(
                    onTap: (){
                      print("Switching");
                      Navigator.of(context).pushNamed('/chat');
                    },
                child: Card(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      elevation: 2.0,
                      child:

                      Column(
                        children: <Widget>[
                          Container(
                            decoration: Bubble.BubbleDecoration(),
                            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                            child: Text(
                              'Some very long message here about some stuff you think you care about but not really because you\'re just testing the overflow',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true),
                            ),
                          ListTile(
                            //dense: true,
                            isThreeLine: false,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/thumb/women/${math
                                .Random().nextInt(100)}.jpg'),
                              radius: 16.0,
                              ),
                            title: Text('Ras A\'ghul'),
                            subtitle: Text('2 minutes ago'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.chat_bubble,
                                    ),
                                  onPressed: () {},
                                  color: Colors.lightGreen,
                                  iconSize: 14.0,
                                  ),
                                (i % 6 == 0)
                                ? IconButton(
                                  icon: Icon(Icons.perm_media),
                                  onPressed: () {},
                                  color: Colors.lightGreen,
                                  iconSize: 14.0)
                                : Container(),
                                (i % 7 == 0)
                                ? IconButton(
                                  icon: Icon(Icons.attach_file),
                                  color: Colors.lightGreen,
                                  onPressed: () {},
                                  iconSize: 14.0)
                                  : Container(),
                                  ],
                                  ),
                                  )
                                   ],
                                   ),
                                   )
                  );


              },
            childCount: items,
            ),
            ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    /*rng = new Center(
      child: Text(math.Random().nextInt(100).toString()),
      );*/
    return new Material(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.55, 1.0])),
          child:
          /*new DefaultTabController(
            length: _tabs.length,child: */ // This is the number of tabs.
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              // print('at: ${scrollInfo.metrics.pixels} depth: ${scrollInfo.depth} , max: ${scrollInfo.metrics.maxScrollExtent}');
              if (scrollInfo.depth == 0 && !scrollInfo.metrics.outOfRange) {
                homeAnimationController.value = (scrollInfo.metrics.pixels /
                    scrollInfo.metrics.maxScrollExtent);
              }
            },
            child: new NestedScrollView(
                     //controller: nestedScrollViewController,
                     //key: nestedScrollCardKey,
                     physics: BouncingScrollPhysics(),
                     headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                       //print('MaxExt: ${nestedScrollViewController.position.maxScrollExtent}');
                       // These are the slivers that show up in the "outer" scroll view.
                       return <Widget>[
                         SliverAppBar(
                             title: const Text(
                               'RAEV',
                               style: TextStyle(
                                 color: Colors.black,
                                 letterSpacing: 4.0,
                                 fontWeight: FontWeight.bold,
                                 ),
                               ),
                             floating: true,
                             //pinned: true,
                             // primary: true,
                             centerTitle: true,
                             expandedHeight: 56.0,
                             backgroundColor: Colors.transparent,
                             elevation: 0.0,
                             ),
                         // buildDelegatedSliverHeader(innerBoxIsScrolled),
                         new SliverOverlapAbsorber(
                             // This widget takes the overlapping behavior of the SliverAppBar,
                             // and redirects it to the SliverOverlapInjector below. If it is
                             // missing, then it is possible for the nested "inner" scroll view
                             // below to end up under the SliverAppBar even when the inner
                             // scroll view thinks it has not been scrolled.
                             // This is not necessary if the "headerSliverBuilder" only builds
                             // widgets that do not overlap the next sliver.
                             handle:
                             NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                             // child: buildSliverHeader(innerBoxIsScrolled),
                             child: Builder(
                               builder: (BuildContext c) =>
                               buildDelegatedSliverHeader(innerBoxIsScrolled),
                               ),
                             //  buildDelegatedSliverHeader(innerBoxIsScrolled),
                             ),
                         ];
                     },
                     body: new TabBarView(
                               controller: _tabController,
                               // physics: BouncingScrollPhysics(),
                               // These are the contents of the tab views, below the tabs.
                               children: _tabs.map((Map header) {
                                 return new SafeArea(
                                     top: false,
                                     bottom: false,
                                     child: new Builder(
                                       // This Builder is needed to provide a BuildContext that is "inside"
                                       // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                                       // find the NestedScrollView.
                                       builder: (BuildContext context) {
                                         return new CustomScrollView(
                                             physics: BouncingScrollPhysics(),
                                             // The "controller" and "primary" members should be left
                                             // unset, so that the NestedScrollView can control this
                                             // inner scroll view.
                                             // If the "controller" property is set, then this scroll
                                             // view will not be associated with the NestedScrollView.
                                             // The PageStorageKey should be unique to this ScrollView;
                                             // it allows the list to remember its scroll position when
                                             // the tab view is not on the screen.
                                             key: new PageStorageKey<String>(header['title']),
                                             slivers: <Widget>[
                                               // This is the flip side of the SliverOverlapAbsorber above.
                                               // new SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),),
                                             new SliverObstructionInjector(
                                               handle:
                                               NestedScrollView.sliverOverlapAbsorberHandleFor(
                                                 context)),

                                             createPaddedHeaderList({'title': 'Unread'}, 20),
                                             createPaddedHeaderList({'title': 'Unseen'}, 36),
                                             createPaddedHeaderList({'title': 'seen'}, 14),
                                             createPaddedHeaderList({'title': 'new'}, 5),
                                             /*SliverFillViewport(
                                               viewportFraction: 0.4 ,
                                               delegate: SliverChildBuilderDelegate(
                                               (BuildContext c, int i) =>
                                               Center(child: Text('$i')),
                                               childCount: 1),
                                               ),*/
                                             SliverFillRemaining(
                                                 child: Container(
                                                   // color: Colors.blue,
                                                   // margin: EdgeInsets.all(8.0),
                                                   decoration: BoxDecoration(
                                                     //color: Colors.blue,
                                                     // borderRadius: BorderRadius.circular(8.0)
                                                     ),
                                                   child: Center(
                                                     child: new Text('ssd'),
                                                     ),
                                                   ),
                                                 ),
                                             ],
                                             )
                                               //)
                                               ;
                                       },
                                 ),
                                 );
                               }).toList(),
                               ),
                               ),
                               ),
                               ));
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class SliverObstructionInjector extends SliverOverlapInjector {
  /// Creates a sliver that is as tall as the value of the given [handle]'s
  /// layout extent.
  ///
  /// The [handle] must not be null.
  const SliverObstructionInjector({
    Key key,
    @required SliverOverlapAbsorberHandle handle,
    Widget child,
  })  : assert(handle != null),
  super(key: key, handle: handle, child: child);

  @override
  RenderSliverObstructionInjector createRenderObject(BuildContext context) {
    return new RenderSliverObstructionInjector(
        handle: handle,
        );
  }
}

// Helper utilities for sliveroverlapinjector customized specifically for this layout,
// Perhaps it isn't needed but is around for now in case i need to support sticky headers

/// A sliver that has a sliver geometry based on the values stored in a
/// [SliverOverlapAbsorberHandle].
///
/// The [RenderSliverOverlapAbsorber] must be an earlier descendant of a common
/// ancestor [RenderViewport] (probably a [RenderNestedScrollViewViewport]), so
/// that it will always be laid out before the [RenderSliverObstructionInjector]
/// during a particular frame.
class RenderSliverObstructionInjector extends RenderSliverOverlapInjector {
  /// Creates a sliver that is as tall as the value of the given [handle]'s extent.
  ///
  /// The [handle] must not be null.
  RenderSliverObstructionInjector({
    @required SliverOverlapAbsorberHandle handle,
    RenderSliver child,
  })  : assert(handle != null),
  _handle = handle,
  super(handle: handle);

  double _currentLayoutExtent;
  double _currentMaxExtent;

  /// The object that specifies how wide to make the gap injected by this render
  /// object.
  ///
  /// This should be a handle owned by a [RenderSliverOverlapAbsorber] and a
  /// [RenderNestedScrollViewViewport].
  SliverOverlapAbsorberHandle get handle => _handle;
  SliverOverlapAbsorberHandle _handle;
  set handle(SliverOverlapAbsorberHandle value) {
    assert(value != null);
    if (handle == value) return;
    if (attached) {
      handle.removeListener(markNeedsLayout);
    }
    _handle = value;
    if (attached) {
      handle.addListener(markNeedsLayout);
      if (handle.layoutExtent != _currentLayoutExtent ||
          handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    handle.addListener(markNeedsLayout);
    if (handle.layoutExtent != _currentLayoutExtent ||
        handle.scrollExtent != _currentMaxExtent) markNeedsLayout();
  }

  @override
  void performLayout() {
    _currentLayoutExtent = handle.layoutExtent;
    _currentMaxExtent = handle.layoutExtent;
    // print(
    //   'clamped: $_currentLayoutExtent, min($diff, ${constraints.remainingPaintExtent}), viewport:  ${constraints.viewportMainAxisExtent} ');
    //
    //

    //print(
    //   'offset: ${constraints.scrollOffset}, min($diff, ${constraints.remainingPaintExtent}), viewport:  ${constraints.viewportMainAxisExtent} ');
    geometry = new SliverGeometry(
        // scrollExtent:0.0,
        // paintExtent: math.max(0.0, clampedLayoutExtent),
        //maxPaintExtent: _currentMaxExtent,

        scrollExtent: 0.0,
        // paintExtent: math.max(0.0, diff),
        //layoutExtent: _currentMaxExtent,

        paintExtent: _currentMaxExtent,
        maxPaintExtent: _currentMaxExtent,
        );
  }
}
