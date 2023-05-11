import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({super.key});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      width: 100,
      height: 130,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Carpenter',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
            Image.network(
              'https://media.istockphoto.com/id/481628382/photo/carpenter-taking-measurement.jpg?s=612x612&w=0&k=20&c=l2cAPfJL2bGltBasmnqUlsz2OHv6H6bUzjzhx0feOJg=',
              fit: BoxFit.fill,
              height: 87,
            )
          ],
        ),
      ),
    );
  }
}
