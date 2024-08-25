import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PaginationService {
  PaginationService._privateConstructor();

  static PaginationService? _instance;

  static PaginationService get instance {
    _instance ??= PaginationService._privateConstructor();
    return _instance!;
  }

  /// Write Firebase Query with orderBy

  Stream<
          (
            List<QueryDocumentSnapshot<Object?>>,
            DocumentSnapshot? documentSnapshot
          )>
      fetchPaginateDoc(
          {required Query firebaseQuery,
          DocumentSnapshot? lastDocument,
          int limit = 5}) {
    try {
      Query query = firebaseQuery.limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }
      return query.snapshots().map((documents) {
        log("paginate Documents lenth = ${documents.docs.length}");
        DocumentSnapshot? lstDoc =
            documents.docs.isNotEmpty ? documents.docs.last : null;
        return (documents.docs, lstDoc);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<
          (
            List<QueryDocumentSnapshot<Object?>>,
            DocumentSnapshot? documentSnapshot
          )>
      getPaginateDoc(
          {required Query firebaseQuery,
          DocumentSnapshot? lastDocument,
          int limit = 5}) async {
    try {
      Query query = firebaseQuery.limit(limit);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      QuerySnapshot snapshots = await query.get();
      DocumentSnapshot? lastDoc =
          snapshots.docs.isNotEmpty ? snapshots.docs.last : null;

      return (snapshots.docs, lastDoc);
    } catch (e) {
      throw Exception(e);
    }
  }

  void scrollListener(
      {required ScrollController scrollController,
      required Function() bottomScrollMethod,
      required Function() topScrollMethod,

      }) {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      bottomScrollMethod();
      print("Reached the bottom of the list");
      // Reached the bottom of the list
    } else if (scrollController.offset <=
            scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {

      topScrollMethod();
      // Reached the top of the list
      print("Reached the top of the list");
    }
  }
}
