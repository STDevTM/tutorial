library tutorial;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tutorial/src/models/tutorial_itens.dart';
import 'package:tutorial/src/painter/painter.dart';

class Tutorial {
  final Stream<void> onTapStream;

  int count = 0;
  List<OverlayEntry> entrys = [];
  OverlayState overlayState;

  Tutorial({this.onTapStream}) {
    onTapStream.listen((event) {
      entrys[count].remove();
      count++;
      if (count != entrys.length) {
        overlayState.insert(entrys[count]);
      }
    });
  }

  showTutorial(BuildContext context, List<TutorialItens> children) async {
    var size = MediaQuery.of(context).size;
    overlayState = Overlay.of(context);
    children.forEach((element) async {
      var offset = _capturePositionWidget(element.globalKey);
      var sizeWidget = _getSizeWidget(element.globalKey);

      final wrapperContainer = size.height - (offset.dy + sizeWidget.height);
      print(offset.dy);
      print(sizeWidget.height);
      print(size.height);
      print(wrapperContainer);

      entrys.add(
        OverlayEntry(
          builder: (context) {
            return GestureDetector(
              onTap: element.touchScreen == true
                  ? () {
                      entrys[count].remove();
                      count++;
                      if (count != entrys.length) {
                        overlayState.insert(entrys[count]);
                      }
                    }
                  : () {},
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: [
                    CustomPaint(
                      size: size,
                      painter: HolePainter(
                          shapeFocus: element.shapeFocus,
                          dx: offset.dx + (sizeWidget.width / 2),
                          dy: offset.dy + (sizeWidget.height / 2),
                          width: sizeWidget.width,
                          height: sizeWidget.height),
                    ),
                    Positioned(
                      top: offset.dy + sizeWidget.height,
                      bottom: element.bottom,
                      left: element.left,
                      right: element.right,
                      child: Container(
                        width: size.width * 0.8,
                        color: Colors.red,
                        height: wrapperContainer,
                        child: Column(
                          crossAxisAlignment: element.crossAxisAlignment,
                          mainAxisAlignment: element.mainAxisAlignment,
                          children: [
                            ...element.children,
                            if (element.widgetNext != null)
                              GestureDetector(
                                child: element.widgetNext ??
                                    Text(
                                      "NEXT",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                onTap: () {
                                  entrys[count].remove();
                                  count++;
                                  if (count != entrys.length) {
                                    overlayState.insert(entrys[count]);
                                  }
                                },
                              ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    });

    overlayState.insert(entrys[0]);
  }

  static Offset _capturePositionWidget(GlobalKey key) {
    RenderBox renderPosition = key.currentContext.findRenderObject();

    return renderPosition.localToGlobal(Offset.zero);
  }

  static Size _getSizeWidget(GlobalKey key) {
    RenderBox renderSize = key.currentContext.findRenderObject();
    return renderSize.size;
  }
}
