import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_e_shop/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_e_shop/models/user.dart' as model;
import 'package:firebase_e_shop/providers/user_provider.dart';
import 'package:firebase_e_shop/resources/firestore_methods.dart';
import 'package:firebase_e_shop/screens/comments_screen.dart';
import 'package:firebase_e_shop/utils/colors.dart';
import 'package:firebase_e_shop/utils/global_variable.dart';
import 'package:firebase_e_shop/widgets/like_animation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialMedia { facebook, twitter }

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColor : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST

          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                //投稿画像
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                //LikeButtonAnimation
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ),
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                      //投稿ユーザー画像
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          widget.snap['profImage'].toString(),
                        ),
                      ),

                      LikeAnimation(
                        isAnimating: widget.snap['likes'].contains(user.uid),
                        smallLike: true,
                        child: IconButton(
                          icon: widget.snap['likes'].contains(user.uid)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 50,
                                )
                              : const Icon(
                                  Icons.favorite_border,
                                  size: 50,
                                ),
                          onPressed: () => FireStoreMethods().likePost(
                            widget.snap['postId'].toString(),
                            user.uid,
                            widget.snap['likes'],
                          ),
                        ),
                      ),
                      DefaultTextStyle(
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(fontWeight: FontWeight.w800),
                          child: Text(
                            '${widget.snap['likes'].length}',
                            style: Theme.of(context).textTheme.bodyText2,
                          )),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              postId: widget.snap['postId'].toString(),
                            ),
                          ),
                        ),
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$commentLen",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),

                      // buildSocialButton(
                      //     icon: FontAwesomeIcons.twitter,
                      //     color: Color(0xFF0075fc),
                      //     onClicked: () => share(SocialMedia.twitter)),
                      IconButton(
                          icon: const Icon(
                            Icons.share,
                            size: 50,
                          ),
                          onPressed: () {
                            Share.share("こんな出品があるよ");
                          }),
                      widget.snap['uid'].toString() == user.uid
                          //Delete Button
                          ? IconButton(
                              onPressed: () {
                                showDialog(
                                  useRootNavigator: false,
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: ListView(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          shrinkWrap: true,
                                          children: [
                                            'Delete',
                                          ]
                                              .map(
                                                (e) => InkWell(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 12,
                                                          horizontal: 16),
                                                      child: Text(e),
                                                    ),
                                                    onTap: () {
                                                      deletePost(
                                                        widget.snap['postId']
                                                            .toString(),
                                                      );
                                                      // remove the dialog box
                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                              )
                                              .toList()),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                size: 50,
                              ),
                            )
                          : Container(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: Row(
                    children: [
                      //投稿ユーザーネーム
                      Text(
                        "@${widget.snap['username'].toString()}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat(
                          'yyyy.MM.dd.kk:mm',
                        )
                            .format(widget.snap['datePublished'].toDate())
                            .toString(),
                        style: const TextStyle(
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: Text(' ${widget.snap['description']}'))
              ],
            ),
          )
        ],
      ),
    );
  }

  Future share(SocialMedia socialPlatform) async {
    final subject = "Best Flutter Video Ever!";
    final text = "Watch this awesome video about sharing data with Flutter";
    final urlShare = Uri.encodeComponent('https://youtu.be/bWehAFTFc9o');

    final urls = {
      SocialMedia.facebook:
          'https://www.facebook.com/sharer/sharer.php?u=$urlShare&t=$text',
      SocialMedia.twitter:
          'https://twitter.com/intent/tweet?url=$urlShare&text=$text',
    };
    final url = urls[socialPlatform]!;

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget buildSocialButton(
          {required IconData icon,
          Color? color,
          required VoidCallback onClicked}) =>
      InkWell(
        child: Container(
          width: 64,
          height: 64,
          child: Center(
            child: FaIcon(
              icon,
              color: color,
              size: 30,
            ),
          ),
        ),
        onTap: onClicked,
      );
}
