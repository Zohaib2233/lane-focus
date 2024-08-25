import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanefocus/core/constants/instance_collections.dart';
import 'package:lanefocus/core/constants/instance_constants.dart';
import 'package:lanefocus/core/utils/snackbar.dart';
import 'package:uuid/uuid.dart';
import '../../model/chat/chat_threads.dart';
import '../../model/chat/messages_model.dart';
import '../../model/user/user_model.dart';
import '../../view/screens/admin/admin_chat/admin_chat_screen.dart';

class ChatController extends GetxController {
  RxInt unreadCount = 0.obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<MessageModel> groupMessages = <MessageModel>[]
      .obs; //different lists for messaging as user can enter 1-1 chat with group members within group.
  RxList<UserModel> chatHeadUsers = <UserModel>[].obs;
  RxList<ChatThreadModel> chatHeads = <ChatThreadModel>[].obs;
  TextEditingController msgController = TextEditingController(),
      searchController = TextEditingController();
  RxString searchText = ''.obs;

  enterChatRoom(
    String receiverId,
  ) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();
    if (currentUserId.trim() == receiverId.trim()) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Error', message: 'This is your own profile');
      return;
    }
    List<String> participants = [currentUserId, receiverId];
    List<String> partiRev = [receiverId, currentUserId];
    // Check if a chat room already exists between the two users
    QuerySnapshot snap;
    snap = await chatCollection
        .where('participants', isEqualTo: participants)
        .get();
    if (snap.docs.isEmpty) {
      snap =
          await chatCollection.where('participants', isEqualTo: partiRev).get();
    }

    if (snap.docs.isNotEmpty) {
      // Chat room already exists
      final receiverSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();
      UserModel userModel =
          UserModel.fromJson(receiverSnapshot.data() as Map<String, dynamic>);
      getChatsInThread(snap.docs.first.id);
      Get.to(
        () => ChatScreen(
          receiverUserModel: userModel,
          chatHeadId: snap.docs.first.id,
        ),
      );
    } else {
      // Chat room does not exist

      ChatThreadModel chatThreadModel = ChatThreadModel();
      chatThreadModel.lastMessage = '';
      chatThreadModel.lastMessageTime = DateTime.now();
      chatThreadModel.chatHeadId = const Uuid().v4();
      chatThreadModel.participants = participants;

      await chatCollection
          .doc(chatThreadModel.chatHeadId)
          .set(chatThreadModel.toMap());

      final receiverSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverId)
          .get();
      UserModel userModel =
          UserModel.fromJson(receiverSnapshot.data() as Map<String, dynamic>);
      getChatsInThread(chatThreadModel.chatHeadId ?? '');
      Get.to(
        () => ChatScreen(
          receiverUserModel: userModel,
          chatHeadId: chatThreadModel.chatHeadId!,
        ),
      );
    }
  }

  sendMessageInThread(
      {required String chatRoomId,
      required String message,
      required String token,
      required String targetId,
      required String name,
      required String img,
      required String userId,
      required String type}) async {
    MessageModel messageModel = MessageModel();
    messageModel.message = message;
    messageModel.messageId = const Uuid().v4();
    messageModel.sentBy = FirebaseAuth.instance.currentUser!.uid;
    messageModel.sentAt = DateTime.now();
    await chatCollection
        .doc(chatRoomId)
        .collection('messages')
        .add(messageModel.toMap());

    await chatCollection.doc(chatRoomId).update({
      'lastMessage': message,
      'lastMessageTime': DateTime.now(),
      'lastMessageSeenBy': FieldValue.arrayUnion([auth.currentUser!.uid]),
    });
    // NotificationService.instance.sendNotification(name, token,
    //     type == "text" ? message : "sent an image", targetId, "one-one-chat");

    msgController.clear();
  }

  getChatsInThread(String chatThreadId) async {
    Stream stream = chatCollection
        .doc(chatThreadId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .snapshots();

    stream.listen((event) {
      List<MessageModel> tempMessages = [];
      for (var element in event.docs) {
        tempMessages.add(MessageModel.fromJson2(element));
      }
      messages.value = tempMessages;
    });
  }

  getAllChatHeads() async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    try {
      Stream stream = await chatCollection
          .where('participants', arrayContains: uid)
          .orderBy('lastMessageTime', descending: true)
          .snapshots();

      stream.listen((event) async {
        List<ChatThreadModel> tempHeads = [];
        List<UserModel> tempHeadUsers = [];

        for (var element in event.docs) {
          tempHeads.add(ChatThreadModel.fromMap(element));
        }
        chatHeads.value = tempHeads;
        for (var element in chatHeads) {
          List participants = element.participants ?? [];

          for (var element in participants) {
            if (element != uid) {
              DocumentSnapshot snap = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(element)
                  .get();
              tempHeadUsers
                  .add(UserModel.fromJson(snap.data() as Map<String, dynamic>));
            }
          }
        }
        chatHeadUsers.value = tempHeadUsers;
        // log("message:::::${chatHeadUsers.first.toJson()}");
      });
    } on FirebaseException catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Server Error', message: e.message.toString());
    }
  }

  getUnreadCount() async {
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    try {
      Stream stream = await chatCollection
          .where('participants', arrayContains: uid)
          .orderBy('lastMessageTime', descending: true)
          .snapshots();

      stream.listen((event) async {
        List<ChatThreadModel> tempHeads = [];

        unreadCount.value = 0;
        for (var element in event.docs) {
          tempHeads.add(ChatThreadModel.fromMap(element));
        }
        for (var element in tempHeads) {
          if (!(element.lastMessageSeenBy != null &&
              element.lastMessageSeenBy!.contains(uid))) {
            unreadCount.value += 1;
          }
        }
      });
    } on FirebaseException catch (e) {
      CustomSnackBars.instance.showFailureSnackbar(
          title: 'Server Error', message: e.message.toString());
    }
  }

  markAsRead(String chatroomId) async {
    await chatCollection.doc(chatroomId).update({
      'lastMessageSeenBy': FieldValue.arrayUnion([auth.currentUser!.uid])
    });
  }

  @override
  void onInit() async {
    await getAllChatHeads();
    await getUnreadCount();
    super.onInit();
  }

  @override
  void onClose() {
    msgController.dispose();
    super.onClose();
  }
}
