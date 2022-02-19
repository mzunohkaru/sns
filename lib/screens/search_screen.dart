import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_e_shop/widgets/overlay_textfield.dart';
import 'package:firebase_e_shop/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:firebase_e_shop/screens/profile_screen.dart';
import 'package:firebase_e_shop/utils/colors.dart';
import 'package:firebase_e_shop/utils/global_variable.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final focusNode = FocusNode();
  late TextEditingController searchController = TextEditingController();
  final layerLink = LayerLink();
  OverlayEntry? entry;

  bool isShowUsers = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    WidgetsBinding.instance!.addPostFrameCallback((_) => showOverlay());

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        hideOverlay();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void showOverlay() {
    final overlay = Overlay.of(context)!;
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    // final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
        builder: (context) => Positioned(
              // left: offset.dx,
              // top: offset.dy + size.height + 8,
              width: size.width,
              child: CompositedTransformFollower(
                  link: layerLink,
                  showWhenUnlinked: false,
                  offset: Offset(0, size.height + 8),
                  child: buildOverlay()),
            ));
    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: CompositedTransformTarget(
          link: layerLink,
          child: TextFormField(
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
            focusNode: focusNode,
            controller: searchController,
            decoration: InputDecoration(
                label: const Text("Username"),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12))),
          ),
        ),
        // title: Form(
        //   child: TextFormField(
        //     controller: searchController,
        //     decoration:
        //         const InputDecoration(labelText: 'Search for a user...'),
        //     onFieldSubmitted: (String _) {
        //       setState(() {
        //         isShowUsers = true;
        //       });
        //       print(_);
        //     },
        //   ),
        // ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                final width = MediaQuery.of(context).size.width;
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: PostCard(
                        snap: (snapshot.data! as dynamic).docs[index].data(),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                    (snapshot.data! as dynamic).docs[index]['postUrl'],
                    fit: BoxFit.cover,
                  ),
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }

  Widget buildOverlay() => Material(
        elevation: 8,
        child: Column(
          children: [
            ListTile(
              leading: Image.network(
                "https://i1.wp.com/soramimiescargot.com/wp-content/uploads/2020/12/dtI7XPN.jpg?resize=900%2C900&ssl=1",
                fit: BoxFit.cover,
              ),
              title: Text('Name'),
              onTap: () {
                searchController.text = "Name";
                hideOverlay();
                focusNode.unfocus();
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
            ListTile(
              leading: Image.network(
                "https://keyakizaka46.antena-kun.com/wp-content/uploads/2020/06/538bf70d-s.png",
                fit: BoxFit.cover,
              ),
              title: Text('N'),
              onTap: () {
                searchController.text = "N";
                hideOverlay();
                focusNode.unfocus();
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
            ListTile(
              leading: Image.network(
                "https://contents.oricon.co.jp/upimg/news/20200919/2171959_202009190072477001600460106c.jpg",
                fit: BoxFit.cover,
              ),
              title: Text('m'),
              onTap: () {
                searchController.text = "m";
                hideOverlay();
                focusNode.unfocus();
                setState(() {
                  isShowUsers = true;
                });
              },
            ),
          ],
        ),
      );
}
