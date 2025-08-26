import 'package:flutter/material.dart';
import 'package:landifymobile/screens/notification/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.orange.shade700,
      expandedHeight: 180.0,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/header.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () {}),
                    const Text('Bất động sản', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.white),
                      // THAY ĐỔI 2: Thêm hành động điều hướng khi nhấn nút
                      onPressed: () {
                        Navigator.of(context).pushNamed(NotificationScreen.routeName);
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text('Mua thì hời, bán thì lời', style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.orange.shade700, shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(horizontal: 24)),
                        child: const Text('Mua bán'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, foregroundColor: Colors.white, elevation: 0, shape: const StadiumBorder(side: BorderSide(color: Colors.white)), padding: const EdgeInsets.symmetric(horizontal: 24)),
                        child: const Text('Cho thuê'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}