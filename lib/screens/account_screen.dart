import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Guest',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
                Text(
                  'Welcome to Bimlinkz',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )
              ],
            )
          ],
        ),
        toolbarHeight: 150,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              shape: Border(bottom: BorderSide(width: 1.0, color: Colors.grey)),
              leading: Icon(
                Icons.add_box_outlined,
                color: Theme.of(context).copyWith().primaryColor,
              ),
              title: Text(
                'Join Bimlinkz',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).copyWith().primaryColor),
              ),
            ),
            const ListTile(
              leading: const Icon(Icons.login),
              title: Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// Row(
//               children: [
//                 const Icon(Icons.add_box_outlined),
//                 TextButton(
//                     onPressed: () {},
//                     child: const Text(
//                       'Join Bimlinkz ',
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//                     ))
//               ],
//             ),