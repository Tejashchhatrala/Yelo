// import 'package:gharelu/src/auth/models/custom_user_model.dart';
// import 'package:gharelu/src/chat/data_source/chat_data_source.dart';
// import 'package:gharelu/src/chat/models/room_model.dart';
// import 'package:gharelu/src/core/constant/app_constant.dart';
// import 'package:gharelu/src/core/extensions/list_extension.dart';
// import 'package:gharelu/src/core/providers/firbease_provider.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// final getChatListProvider = StreamProvider.family<List<RoomModel>, bool>((ref, isMerchant) {
//   final firestore = ref.read(firestoreProvider);
//   final auth = ref.read(firebaseAuthProvider);

//   // List<RoomModel> chatRoom = [];

//   // final response = firestore.collection(AppConstant.rooms).where(isMerchant ? 'merchant_id' : 'user_id', isEqualTo: auth.currentUser?.uid).snapshots().listen((event) async {
//   //   chatRoom = List<RoomModel>.from(event.docs.map((e) => RoomModel.fromJson(e.data())));
//   //   for (var room in chatRoom) {
//   //     final index = chatRoom.indexOf(room);
//   //     final user = await getUserInfo(ref, room.userId);
//   //     final merchant = await getMerchantInfo(ref, room.merchantId);
//   //     final data = chatRoom[index].copyWith(user: user, merchant: merchant);
//   //     chatRoom.update(index, data);
//   //   }

//   // });
//   // return response;
//   ref.read(getChatProvider);
// });

// // final getUserInfoProvider = FutureProvider.family<CustomUserModel, String>((ref, userId) async {
// //   final firestore = ref.read(firestoreProvider);

// // });

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gharelu/src/chat/data_source/chat_data_source.dart';
import 'package:gharelu/src/chat/models/message_model.dart';
import 'package:gharelu/src/chat/models/room_model.dart';
import 'package:gharelu/src/core/constant/app_constant.dart';
import 'package:gharelu/src/core/extensions/list_extension.dart';
import 'package:gharelu/src/core/providers/firbease_provider.dart';
import 'package:gharelu/src/core/state/app_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatListNotifier extends StateNotifier<AppState<List<RoomModel>>> {
  ChatListNotifier(this._firestore, this._firebaseAuth, this.ref) : super(const AppState.initial());

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final Ref ref;

  String? get userId => _firebaseAuth.currentUser?.uid;

  void getChatList({required bool isMerchant}) async {
    state = const AppState.loading();
    List<RoomModel> rooms = [];
    MessageModel? lastMessage;
    await _firestore.collection(AppConstant.rooms).where(isMerchant ? 'merchant_id' : 'user_id', isEqualTo: userId)
      ..snapshots().listen((event) async {
        rooms = List<RoomModel>.from(event.docs.map((e) => RoomModel.fromJson(e.data())));
        for (var i = 0; i < rooms.length; i++) {
          final room = rooms[i];
          final user = await getUserInfo(ref, room.userId);
          final merchant = await getMerchantInfo(ref, room.merchantId);
          final product = await getProductInfo(ref, room.productId);
          final _room = rooms[i].copyWith(user: user, merchant: merchant, product: product);
          rooms.update(i, _room);
          state = AppState.success(data: rooms);
        }
      });
  }
}

final chatListNotifierProvider = StateNotifierProvider.family<ChatListNotifier, AppState<List<RoomModel>>, bool>((ref, isMerchant) {
  return ChatListNotifier(ref.read(firestoreProvider), ref.read(firebaseAuthProvider), ref)..getChatList(isMerchant: isMerchant);
});
