import 'package:flutter/material.dart';

class PageParaCoisar extends StatefulWidget {
  const PageParaCoisar({super.key});

  @override
  State<PageParaCoisar> createState() => _PageParaCoisarState();
}

class _PageParaCoisarState extends State<PageParaCoisar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}