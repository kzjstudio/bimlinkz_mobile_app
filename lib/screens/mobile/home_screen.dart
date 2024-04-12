import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/widgets/category_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

var collection = FirebaseFirestore.instance.collection('categories');
bool _isLoaded = false;
late List<Map<String, dynamic>> items;
var categories = {};
final AuthController c = Get.find();

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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Hello,'),
              Text(
                c.userName.value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ]),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
                iconSize: 20,
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {},
                      ),
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular searches',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton(onPressed: () {}, child: const Text('See all'))
                    ],
                  ),
                  const SizedBox(height: 20),
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
                        : const Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey.shade300,
                    child: Center(child: Text('Feature Area')),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
