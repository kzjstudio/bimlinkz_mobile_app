import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var recentContractors = <Map<String, dynamic>>[].obs;
  var dataFetched = false.obs;

  Future<void> fetchAndCacheData(BuildContext context) async {
    if (!dataFetched.value) {
      await _fetchCategories(context);
      await _fetchRecentContractors(context);
      dataFetched.value = true;
    }
  }

  Future<void> _fetchCategories(BuildContext context) async {
    var collection =
        await FirebaseFirestore.instance.collection('categories').get();
    var fetchedCategories = collection.docs.map((doc) => doc.data()).toList();

    // Cache all category images
    await Future.wait(fetchedCategories.map((category) {
      return precacheImage(
        NetworkImage(category['imageUrl']),
        context,
      );
    }));

    categories.value = fetchedCategories;
  }

  Future<void> _fetchRecentContractors(BuildContext context) async {
    var collection = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('Date_joined')
        .limit(6)
        .get();
    var fetchedRecentContractors =
        collection.docs.map((doc) => doc.data()).toList();

    if (fetchedRecentContractors.isEmpty) {
      var getUsers = await FirebaseFirestore.instance.collection('users').get();
      var users = getUsers.docs.map((doc) => doc.data()).toList();

      await Future.wait(users.map((contractor) {
        return precacheImage(
          NetworkImage(contractor['imageUrl']),
          context,
        );
      }));

      recentContractors.value = users;
    }

    // Cache all contractor images
    await Future.wait(fetchedRecentContractors.map((contractor) {
      return precacheImage(
        NetworkImage(contractor['imageUrl']),
        context,
      );
    }));

    recentContractors.value = fetchedRecentContractors;
  }

  void clearData() {
    categories.clear();
    recentContractors.clear();
    dataFetched.value = false;
  }
}
