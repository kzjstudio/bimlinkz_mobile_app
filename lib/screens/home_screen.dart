import 'package:bimlinkz_mobile_app/screens/become_a_tradesman_landing_screen.dart';
import 'package:bimlinkz_mobile_app/widgets/category_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var collection = FirebaseFirestore.instance.collection('categories');
bool _isLoaded = false;
late List<Map<String, dynamic>> items;
var categories = {};

class _HomeScreenState extends State<HomeScreen> {
  void getData() async {
    List<Map<String, dynamic>> tempList = [];
    var data = await collection.get();
    for (var element in data.docs) {
      tempList.add(element.data());
    }

    setState(() {
      items = tempList;
      _isLoaded = true;
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
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BecomeATradesManScreen()));
            },
            icon: const Icon(Icons.link_rounded),
            iconSize: 40,
            color: Colors.green.shade800,
          )
        ],
        title: Text(
          "Bimlinkz",
          style: GoogleFonts.inter(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(
              height: 14,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 5)
                ],
                color: const Color(0xFFFFFFFF),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: TextField(
                decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {},
                    ),
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular searches',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                TextButton(onPressed: () {}, child: const Text('See all'))
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              height: 130,
              child: _isLoaded
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          catText: items[index]["id"],
                          imageUrl: items[index]['imageUrl'],
                        );
                      })
                  : Container(child: const Text("no data")),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: 338,
              height: 316,
              color: Colors.grey,
            ),
          ],
        ),
      )),
    );
  }
}
