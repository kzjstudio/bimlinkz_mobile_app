import 'package:bimlinkz_mobile_app/screens/mobile/popular_selection_screen.dart';
import 'package:bimlinkz_mobile_app/theme.dart';
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
            builder: (context) => PopularSelectionScreen(id: widget.catText),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 130,
        margin: const EdgeInsets.all(8), // Add some margin around the card
        decoration: BoxDecoration(
          color: const Color(0xff5664F5), // Card background color
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text(
                widget.catText,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
