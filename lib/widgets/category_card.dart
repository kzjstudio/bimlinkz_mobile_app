import 'package:bimlinkz_mobile_app/screens/popular_selection_screen.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String catText;
  final String imageUrl;
  const CategoryCard({
    super.key,
    required this.catText,
    required this.imageUrl,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PopularSelectionScrren(
                      id: widget.catText,
                    )));
      },
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        width: 100,
        height: 130,
        child: Card(
          shadowColor: Colors.white,
          elevation: 5,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.catText,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: Container(
                  child: Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
