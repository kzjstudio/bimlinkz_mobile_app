import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String catText;
  const CategoryCard({super.key, required this.catText});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      width: 100,
      height: 130,
      child: Card(
        elevation: 20,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.catText,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
