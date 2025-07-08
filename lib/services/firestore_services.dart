import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instância não estática

  // Métodos estáticos existentes
  static Future addUser(Map<String, dynamic> userInfoMap, String id) async {
    print('Adicionando usuário...');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
    print('Usuário adicionado com sucesso.');
  }

  static Future getUserInfo(String id) async {
    DocumentSnapshot _snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get();
    if (_snapshot.exists) {
      return _snapshot;
    }
  }

  static addMessage(
    String chatRoomId,
    String messageId,
    Map<String, dynamic> messageInfoMap,
  ) async {
    await FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatRoomId)
        .collection('chats')
        .doc(messageId)
        .set(messageInfoMap);
  }

  static updateLastMessage(
    String chatRoomId,
    Map<String, dynamic> lastMessageInfoMap,
  ) async {
    await FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  /// Busca um chat room pelo ID ou verifica sua existência.
  ///
  /// Retorna:
  /// - `true` se `mode` for 'check' e o chat room existir.
  /// - `false` se `mode` for 'check' e o chat room NÃO existir.
  /// - `DocumentSnapshot` se `mode` for 'get' e o chat room existir.
  /// - `null` se `mode` for 'get' e o chat room NÃO existir.
  /// - `null` se `mode` não for nem 'check' nem 'get' (ou outro cenário não tratado).
  static Future<dynamic> getChatRoomId(String chatRoomId, String mode) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore
          .instance // Use a instância _firestore
          .collection('Chatrooms')
          .doc(chatRoomId)
          .get();

      if (mode == 'check') {
        return documentSnapshot.exists; // Retorna true ou false diretamente
      } else if (mode == 'get') {
        return documentSnapshot.exists
            ? documentSnapshot
            : null; // Retorna o doc ou null
      } else {
        print(
          "Modo '${mode}' inválido ou não suportado na função getChatRoomId.",
        );
        return null;
      }
    } catch (e) {
      print("Erro ao acessar chat room '$chatRoomId': $e");
      return null;
    }
  }

  // Método de busca de usuário no Firestore (agora não estático)
  static Future<QuerySnapshot> searchUser(String userNameSearch) async {
    // Converte o texto de busca para maiúsculas para corresponder ao seu campo 'username'
    String searchPrefix = userNameSearch.toUpperCase();

    // Lembre-se que _firestore é uma instância final da classe
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        // Consulta de intervalo para "começa com"
        .where('username', isGreaterThanOrEqualTo: searchPrefix)
        .where('username', isLessThan: searchPrefix + '\uf8ff')
        .limit(10) // Limita a 10 resultados
        .get();
    return querySnapshot;
  }

  static createChatRoom(
    String chatRoomId,
    Map<String, dynamic> chatRoomInfoMap,
  ) async {
    final _snapshot = await getChatRoomId(chatRoomId, 'check');
    if (_snapshot == false) {
      return FirebaseFirestore.instance
          .collection('Chatrooms')
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  static Future<Stream<QuerySnapshot>> getChatRoomMessages(chatroomId) async {
    return FirebaseFirestore.instance
        .collection('Chatrooms')
        .doc(chatroomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .snapshots();
  }
}
