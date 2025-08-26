import 'package:flutter/material.dart';
import '../constants/sizes.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: false,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, 
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
         
          Icon(
            Icons.language,
            size: Sizes.size28,
            color: Colors.black,
          ),
          
         
          Row(
            children: [
              
              GestureDetector(
                onTap: () => print('Instagram icon pressed'),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: Sizes.size28,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: Sizes.size16),
              
              GestureDetector(
                onTap: () => print('Menu icon pressed'),
                child: Icon(
                  Icons.menu,
                  size: Sizes.size28,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}