import 'package:chat_app/services/firestore_services.dart';
import 'package:chat_app/services/shared_preferences_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class ChatPage extends StatefulWidget {
  final String name, userName, profiUrl;
  const ChatPage({
    super.key,
    required this.name,
    required this.userName,
    required this.profiUrl,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //userInfoFuture sendo utilizado para receber e contruir a pagina de forma assincrona
  late Future<Map<String, dynamic>> userInfoFuture;

  //armazenar os dados recebidos do Future
  late Map<String, dynamic> userInfo;

  //Id do chat resposavel por exibir o cat correto ao usuario
  late String chatRoomId;
  //recebe o texto da menssagem
  TextEditingController _messageController = TextEditingController();
  // identificar...
  bool statusClickSend = false;
  //messageId, para identificarmos o id da menssagem
  late String messageId;
  //adionar a menssagem, realizando operacoes para identificar o envio
  void addMessage(bool statusClickSend) async {
    if (_messageController.text != '') {
      String message = _messageController.text;
      _messageController.text = "";

      DateTime now = DateTime.now();
      String formateddDate = DateFormat('h:mma').format(now);

      Map<String, dynamic> messageInfoMap = {
        'message': message,
        'sendBy': userInfo[SharedPreferencesServices.userNameKey],
        'ts': formateddDate,
        'time': FieldValue.serverTimestamp(),
        'imgUrl': userInfo[SharedPreferencesServices.userImageKey],
      };
      messageId = randomAlphaNumeric(10);
      await FirestoreServices.updateLastMessage(chatRoomId, messageInfoMap);
      if (statusClickSend) {
        message = '';
      }
    }
  }

  getChatRoomIdbyUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return '$b\_$a';
    } else {
      return '$a\_$b';
    }
  }

  setInfos({
    required Map<String, dynamic> userInfoReceive,
    required String a,
    required String b,
  }) {
    userInfo = userInfoReceive;
    chatRoomId = getChatRoomIdbyUsername(a, b);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    userInfoFuture = SharedPreferencesServices.getUserInfo();
    userInfoFuture.then((userInfo) {
      setInfos(
        userInfoReceive: userInfo,
        a: widget.userName,
        b: userInfo[SharedPreferencesServices.userNameKey] as String,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: userInfoFuture,
        builder: (context, asyncSnapshot) {
          if (!asyncSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Container(
            margin: EdgeInsets.only(top: 60),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.23),
                    Text(
                      'My brother',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30),
                                ),
                                color: Colors.blueAccent,
                              ),
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    'My brother',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 20, top: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                color: Colors.black54,
                              ),
                              height: 50,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 5,
                                  ),
                                  child: Text(
                                    'My brother',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.black,
                              ),
                              child: Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFececf8),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write a message...',
                                    prefix: SizedBox(width: 10),
                                    suffixIcon: Icon(
                                      Icons.attach_file,
                                      color: Colors.black,
                                    ),
                                    hintStyle: TextStyle(color: Colors.black),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(color: Colors.black),

                                  maxLines: null,
                                  minLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(60),
                                color: Colors.black,
                              ),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 10),
                          ],
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
