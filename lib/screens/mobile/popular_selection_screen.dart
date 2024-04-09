import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PopularSelectionScrren extends StatefulWidget {
  const PopularSelectionScrren({super.key, required this.id});

  final String id;

  @override
  State<PopularSelectionScrren> createState() => _PopularSelectionScrrenState();
}

var selectedCollection = FirebaseFirestore.instance.collection('categories');
bool _isLoaded = false;
late List<Map<String, dynamic>> items;
var categories = {};

class _PopularSelectionScrrenState extends State<PopularSelectionScrren> {
  void getData() async {
    List<Map<String, dynamic>> dataList = [];
    var data = await selectedCollection
        .doc(widget.id)
        .collection("${widget.id} list")
        .get();
    for (var element in data.docs) {
      dataList.add(element.data());
    }

    setState(() {
      items = dataList;
      _isLoaded = true;
      print(items);
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.id.toUpperCase()),
        ),
        body: _isLoaded
            ? ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]["name"]),
                  );
                })
            : const Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    LoadingIndicator(indicatorType: Indicator.ballPulse)
                  ])));
  }
}
