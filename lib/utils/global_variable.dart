import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_e_shop/screens/add_post_screen.dart';
import 'package:firebase_e_shop/screens/feed_screen.dart';
import 'package:firebase_e_shop/screens/profile_screen.dart';
import 'package:firebase_e_shop/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
