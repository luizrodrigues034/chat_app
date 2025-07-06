import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/services/shared_preferences_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<Map<String, dynamic>> userInfoFuture;

  late TextEditingController _searchUserController;
  List<Map<String, dynamic>> _searchResults = [];

  String _currentText = '';
  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  void _onTextChange() async {
    setState(() {
      _currentText = _searchUserController.text;
    });

    if (_currentText.isNotEmpty) {
      final querySnapshot = await FirestoreServices.searchUser(_currentText);
      setState(() {
        _searchResults = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    userInfoFuture = SharedPreferencesServices.getUserInfo();
    _searchUserController = TextEditingController();
    _searchUserController.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _searchUserController.removeListener(_onTextChange);
    _searchUserController.dispose();
    super.dispose();
  }

  Widget _buildSearchResults(Map<String, dynamic> userInfo) {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        if (user['Id'] == userInfo[SharedPreferencesServices.userIdKey]) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: SizedBox.expand(
                    child: Image.network(
                      user['photo'] ??
                          'https://i.pravatar.cc/150?img=${index + 1}', // Imagem de placeholder
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset('images/boy.jpg', fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              title: Text(
                user['name'] ?? 'Usuário desconhecido',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user['email'] ?? 'Nenhum email',
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
              onTap: () async {
                print('Iniciando chat com ${user['username']}');
                print(
                  'Iniciando chat com ${userInfo[SharedPreferencesServices.userNameKey]}',
                );
                var chatRoomId = getChatRoomIdbyUsername(
                  user['Id'],
                  userInfo[SharedPreferencesServices.userIdKey],
                );
                Map<String, dynamic> chatRoomInfoMap = {
                  'users': [
                    user['username'],
                    userInfo[SharedPreferencesServices.userNameKey],
                  ],
                };
                await FirestoreServices.createChatRoom(
                  chatRoomId,
                  chatRoomInfoMap,
                );
              },
            ),
            Material(
              elevation: 2,
              child: SizedBox(
                height: 1,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDefaultChatList(BuildContext context) {
    return ListView(
      children: [
        Column(
          children: [
            ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: ClipOval(
                  child: SizedBox.expand(
                    child: Image.asset('images/boy.jpg', fit: BoxFit.cover),
                  ),
                ),
              ),
              title: Text(
                'My brother',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Hello, how are you doing?',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '12:55',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3),
            Container(
              color: const Color.fromARGB(114, 0, 0, 0),
              height: 1,
              width: MediaQuery.of(context).size.width * 0.85,
            ),
            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map<String, dynamic>>(
        future: userInfoFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final userInfo = snapshot.data!;
          return Container(
            margin: EdgeInsets.only(top: 60),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/wave.png',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Hello, ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          userInfo[SharedPreferencesServices.userNameKey]
                                  ?.split(" ")[0] ??
                              'have a nice day',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[800],
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            userInfo[SharedPreferencesServices.userImageKey] ??
                                'https://lh3.googleusercontent.com/a/ACg8ocJl2KUI34tE8t2soiQC_I0p4IcY13hNxGhyHIVWuArH-d_ykg=s96-c',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    ' Welcome To',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'My ChatApp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: _searchUserController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                border: InputBorder.none,
                                hintText: 'Search User',
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          // ** IMPLEMENTAÇÃO PRINCIPAL AQUI **
                          Expanded(
                            child: _currentText.isEmpty
                                ? _buildDefaultChatList(context)
                                : _buildSearchResults(userInfo),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
