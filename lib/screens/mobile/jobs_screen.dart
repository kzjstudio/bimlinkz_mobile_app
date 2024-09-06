import 'package:bimlinkz_mobile_app/Controllers/auth_controller.dart';
import 'package:bimlinkz_mobile_app/screens/mobile/job_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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
            SegmentedButton<Post>(
              segments: const <ButtonSegment<Post>>[
                ButtonSegment<Post>(
                    value: Post.yourJobs, label: Text('Your Jobs')),
                ButtonSegment(value: Post.allJobs, label: Text('All Jobs'))
              ],
              selected: <Post>{selectedpostType},
              onSelectionChanged: (Set<Post> newSelection) {
                setState(() {
                  selectedpostType = newSelection.first;
                  print(selectedpostType.toString());
                });
              },
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
          const Text('Filter by Job Type'),
          _isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: ListTile(
                            title: Text(
                              job.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.description,
                                  style: const TextStyle(fontSize: 18),
                                ),
                                Text('in the ${job.parish} area'),
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Looking for ${job.jobCategory}'),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text('In the range of'),
                                Text(
                                    '\$${job.lowerBudget} to \$${job.upperBudget}')
                              ],
                            ),
                            onTap: () {
                              Get.to(() => JobDetailScreen(job: job),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(milliseconds: 200));
                            },
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Stream<QuerySnapshot> _getJobStream() {
    CollectionReference jobs =
        FirebaseFirestore.instance.collection('posted jobs');
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
  }
}

class Job {
  final String title;
  final String description;
  final String parish;
  final String jobCategory;
  final String lowerBudget;
  final String upperBudget;

  Job(this.title, this.description, this.parish, this.jobCategory,
      this.lowerBudget, this.upperBudget);

  factory Job.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Job(
        data['title'] ?? '',
        data['description'] ?? '',
        data['parish'] ?? '',
        data['jobCategory'] ?? '',
        data['lowerBudget'] ?? '',
        data['upperBudget'] ?? '');
  }
}
