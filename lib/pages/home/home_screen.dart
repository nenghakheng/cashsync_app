import 'package:cashsyncapp/pages/home/local_widgets.dart/strategy_list.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: StrategyList());
  }
}
