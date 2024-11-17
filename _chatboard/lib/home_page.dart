import 'package:flutter/material.dart';
import 'auth_service.dart'; // Import the AuthService class
import 'chat_page.dart'; // Import the ChatPage class
import 'profile_page.dart'; // Import the ProfilePage class
import 'settings_page.dart'; // Import the SettingsPage class

class HomePage extends StatelessWidget {
  final AuthService authService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  HomePage({required this.authService}); // Update the constructor

  final List<Map<String, String>> messageBoards = [
    {'name': 'General Discussion', 'image': 'assets/general.png'},
    {'name': 'Tech Talk', 'image': 'assets/tech.png'},
    {'name': 'Random', 'image': 'assets/random.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Message Boards'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Message Boards'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage(authService: authService)),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: messageBoards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(messageBoards[index]['image']!),
            title: Text(messageBoards[index]['name']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    boardName: messageBoards[index]['name']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}