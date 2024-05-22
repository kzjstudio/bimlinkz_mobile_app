import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PopularSelectionScreen extends StatefulWidget {
  const PopularSelectionScreen({super.key, required this.id});

  final String id;

  @override
  State<PopularSelectionScreen> createState() => _PopularSelectionScreenState();
}

var selectedCollection = FirebaseFirestore.instance.collection('categories');
bool _isLoaded = false;
late List<Map<String, dynamic>> items;
var categories = {};

class _PopularSelectionScreenState extends State<PopularSelectionScreen> {
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
                    children: <Widget>[CircularProgressIndicator()])));
  }
}
