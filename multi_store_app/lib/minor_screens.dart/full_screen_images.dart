import 'package:flutter/material.dart';

class FullScreenImages extends StatefulWidget {
  const FullScreenImages({
    super.key,
    required this.imageList,
  });

  final List<dynamic> imageList;

  @override
  State<FullScreenImages> createState() => _FullScreenImagesState();
}

class _FullScreenImagesState extends State<FullScreenImages> {
  final PageController _controller = PageController(); 
  int index = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Center(
              child: Text(
            ('${index + 1}') + ('/') + ('${images().length}'),
            style: const TextStyle(
              fontSize: 24,
              letterSpacing: 1.5,
            ),
          )),
          SizedBox(
            height: size.height * 0.5,
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              controller: _controller,
              children: images(),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            child: imageView(),
          ),
        ],
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
        itemCount: widget.imageList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller.jumpToPage(index);
            },
            child: Container(
                width: 120,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(width: 4, color: Colors.yellow),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.imageList[index],
                    fit: BoxFit.cover,
                  ),
                )),
          );
        });
  }

  List<Widget> images() {
    return List.generate(widget.imageList.length, (index) {
      return InteractiveViewer(
          transformationController: TransformationController(),
          child: Image.network(widget.imageList[index].toString()));
    });
  }
}
