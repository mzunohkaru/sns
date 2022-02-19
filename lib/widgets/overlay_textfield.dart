import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController sController;
  final FocusNode focusNodes;
  final bool submit;

  const TextFieldWidget(
      {Key? key,
      required this.sController,
      required this.focusNodes,
      required this.submit})
      : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  // final focusNode = FocusNode();
  late FocusNode focusNode = widget.focusNodes;
  final layerLink = LayerLink();
  late TextEditingController controller = widget.sController;
  OverlayEntry? entry;
  late bool isShow = widget.submit;

  @override
  void initState() {
    super.initState();
    // controller = TextEditingController();

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
    return CompositedTransformTarget(
      link: layerLink,
      child: TextFormField(
        onFieldSubmitted: (String _) {
          setState(() {
            isShow = true;
          });
          print(_);
        },
        focusNode: focusNode,
        controller: controller,
        decoration: InputDecoration(
            label: Text("Username"),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
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
                controller.text = "Name";
                hideOverlay();
                focusNode.unfocus();
                setState(() {
                  isShow = true;
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
                controller.text = "N";
                hideOverlay();
                focusNode.unfocus();
                setState(() {
                  isShow = true;
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
                controller.text = "m";
                hideOverlay();
                focusNode.unfocus();
                setState(() {
                  isShow = true;
                });
              },
            ),
          ],
        ),
      );
}
