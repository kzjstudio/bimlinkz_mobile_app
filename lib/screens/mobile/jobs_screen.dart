import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/models/jobs.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

enum Post { yourJobs, allJobs }

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  _JobScreenState createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Post selectedpostType = Post.yourJobs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SegmentedButton(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor:
                      AppColors.primary, // Ensure this is a valid Color
                ),
                segments: const <ButtonSegment<Post>>[
                  ButtonSegment<Post>(
                      value: Post.yourJobs, label: Text('Your Jobs')),
                  ButtonSegment(value: Post.allJobs, label: Text('All Jobs')),
                ],
                selected: <Post>{selectedpostType},
                onSelectionChanged: (Set<Post> newSelection) {
                  setState(() {
                    selectedpostType = newSelection.first;
                    print(selectedpostType.toString());
                  });
                },
              ),
            )
          ],
          title: const Text('Job Listings'),
        ),
        body: JobList(
          tab: selectedpostType.toString(),
        ));
  }
}

class JobList extends StatefulWidget {
  final String tab;

  const JobList({super.key, required this.tab});

  @override
  _JobListState createState() => _JobListState();
}

class _JobListState extends State<JobList> {
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      var collection =
          await FirebaseFirestore.instance.collection('categories').get();
      List<String> categories =
          collection.docs.map((doc) => doc['id'] as String).toList();
      setState(() {
        _categories.addAll(categories);
        _isLoadingCategories = false;
      });
    } catch (e) {
      print('Error fetching categories: $e');
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by Job Type',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          _isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonHideUnderline(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        iconSize: 24,
                        isExpanded: true,
                        value: _selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCategory = newValue!;
                          });
                        },
                        items: _categories
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getJobStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    return ListView(
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Job job = Job.fromFirestore(document);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Card(
                            color: AppColors.secondary,
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    job.description,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text('In the ${job.parish} area.'),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Posted on ${job.formattedDate}.",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ), // Display formatted date

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: const ButtonStyle(
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColors.lightBackground),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColors.primary)),
                                        onPressed: () {},
                                        child: Text('View Details')),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getJobStream() {
    CollectionReference jobs =
        FirebaseFirestore.instance.collection('posted jobs');
    try {
      if (widget.tab == 'Post.yourJobs') {
        if (_selectedCategory == 'All') {
          return jobs
              .where('userId',
                  isEqualTo: AuthController.instance.auth.currentUser!.uid)
              .snapshots();
        } else {
          return jobs
              .where('userId',
                  isEqualTo: AuthController.instance.auth.currentUser!.uid)
              .where('jobCategory', isEqualTo: _selectedCategory)
              .snapshots();
        }
      } else {
        if (_selectedCategory == 'All') {
          return jobs.snapshots();
        } else {
          return jobs
              .where('jobCategory', isEqualTo: _selectedCategory)
              .snapshots();
        }
      }
    } catch (e) {
      print("Error fetching job stream: $e");
      return const Stream.empty(); // Return an empty stream on error
    }
  }
}
