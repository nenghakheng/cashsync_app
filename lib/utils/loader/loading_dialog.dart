import 'dart:async';

import 'package:cashsyncapp/constant/config_constant.dart';
import 'package:cashsyncapp/utils/loader/loading_controller.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  LoadingDialog._shardedInstance();
  static final LoadingDialog _shared = LoadingDialog._shardedInstance();
  factory LoadingDialog.instance() => _shared;
  LoadingController? _controller;

  void show({required BuildContext context, required String text}) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = _showOverlay(context: context, message: text);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingController _showOverlay({
    required BuildContext context,
    required String message,
  }) {
    final _text = StreamController<String>();
    _text.add(message);
    final state = Overlay.of(context);
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overLay = OverlayEntry(
      builder: (context) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF5264BE).withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(ConfigConstant.radius2),
                ),
                padding: EdgeInsets.all(ConfigConstant.padding2),
                constraints: BoxConstraints(
                  maxHeight: size.width * 0.5,
                  maxWidth: size.height * 0.8,
                  minWidth: size.width * 0.5,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConfigConstant.sizedBoxH2,
                      CircularProgressIndicator(color: Colors.white),
                      ConfigConstant.sizedBoxH3,
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    state.insert(overLay);
    return LoadingController(
      close: () {
        _text.close();
        overLay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
