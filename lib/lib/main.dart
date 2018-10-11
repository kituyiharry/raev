import 'package:flutter/material.dart';
import 'views/routes/home/home.dart';
import 'package:sharpchat/views/routes/chat/chat.dart';

void main() => runApp(new MyApp());

final Map<String, WidgetBuilder> routes = {
  '/': (BuildContext _context) => Home(),
  '/chat' : (BuildContext _context) => Chat()
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'RAEV',
      theme: ThemeData(
        fontFamily: 'Montserrat'  
      ),
      /*theme: ThemeData.light(),*//*new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.amber,
      ),*/
      //home: new Home(),
      routes: routes,
    );
  }
}
