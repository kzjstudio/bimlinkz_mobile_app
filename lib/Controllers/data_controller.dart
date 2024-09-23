import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs;
  var recentContractors = <Map<String, dynamic>>[].obs;
  var dataFetched = false.obs;

  Future<void> fetchAndCacheData(BuildContext context) async {
    if (!dataFetched.value) {
      // Fetch categories and recent contractors in parallel
      await Future.wait([
        _fetchCategories(context),
        _fetchRecentContractors(context),
      ]);

      dataFetched.value = true;
    }
  }

  Future<void> _fetchCategories(BuildContext context) async {
    var collection =
        await FirebaseFirestore.instance.collection('categories').get();
    var fetchedCategories = collection.docs.map((doc) => doc.data()).toList();

    // Update categories immediately
    categories.value = fetchedCategories;

    // Cache images in the background
    Future.wait(fetchedCategories.map((category) {
      return precacheImage(
        NetworkImage(category['imageUrl']),
        context,
      );
    }));
  }

  Future<void> _fetchRecentContractors(BuildContext context) async {
    var collection = await FirebaseFirestore.instance
        .collection('users')
        .where('is_Contractor', isEqualTo: true)
        .orderBy('Became_Contractor_Date', descending: true)
        .limit(4)
        .get();
    var fetchedRecentContractors =
        collection.docs.map((doc) => doc.data()).toList();

    // Update recent contractors immediately
    recentContractors.value = fetchedRecentContractors;

    // Cache images in the background
    Future.wait(fetchedRecentContractors.map((contractor) {
      return precacheImage(
        NetworkImage(contractor['imageUrl']),
        context,
      );
    }));
  }

  void clearData() {
    categories.clear();
    recentContractors.clear();
    dataFetched.value = false;
  }
}
