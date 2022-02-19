import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_e_shop/resources/auth_methods.dart';
import 'package:firebase_e_shop/responsive/mobile_screen_layout.dart';
import 'package:firebase_e_shop/responsive/responsive_layout.dart';
import 'package:firebase_e_shop/responsive/web_screen_layout.dart';
import 'package:firebase_e_shop/screens/Authentication/login.dart';
import 'package:firebase_e_shop/utils/colors.dart';
import 'package:firebase_e_shop/utils/utils.dart';
import 'package:firebase_e_shop/widgets/text_field_input.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      showSnackBar(context, res);
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                _image != null
                    ? Image(
                        image: MemoryImage(_image!),
                        height: 150,
                        width: 220,
                      )
                    : Container(
                        height: 150,
                        width: 220,
                        color: Colors.grey,
                        child: Image.network(
                          "https://www.kanazawa-it.ac.jp/campus_guide/2021/chapter_2/list_3/img/img_1_1.png",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                IconButton(
                  onPressed: selectImage,
                  icon: const Icon(
                    Icons.photo_camera,
                    color: Colors.black45,
                    size: 70,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'お名前',
              textInputType: TextInputType.text,
              textEditingController: _usernameController,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'メールアドレス',
              textInputType: TextInputType.emailAddress,
              textEditingController: _emailController,
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: 'パスワード',
              textInputType: TextInputType.text,
              textEditingController: _passwordController,
              isPass: true,
              
            ),
            const SizedBox(
              height: 24,
            ),
            TextFieldInput(
              hintText: '自己紹介',
              textInputType: TextInputType.text,
              textEditingController: _bioController,
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              child: Container(
                child: !_isLoading
                    ? const Text(
                        '新規登録',
                      )
                    : const CircularProgressIndicator(
                        color: primaryColor,
                      ),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  color: blueColor,
                ),
              ),
              onTap: signUpUser,
            ),
          ],
        ),
      ),
    );
  }
}
