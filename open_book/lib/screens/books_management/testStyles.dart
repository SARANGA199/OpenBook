import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:styled_widget/styled_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 50, 73, 113),
      body: <Widget>[
        appBar(),
        titleWidget("Open Book"),
        faeturedProducts(),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).padding(all: 18),
    );
  }

  Widget faeturedProducts() => <Widget>[
        <Widget>[
          const Text('WSD- 006').textColor(Colors.brown),
          const Text('WISHDOIT').textColor(Colors.black).fontSize(20),
          const Text('Wishdoit is a new way to make your wishes come true.')
              .textColor(Colors.black)
              .fontSize(15)
              .width(200),
          const SizedBox(height: 10),
          const Text('Buy Now')
              .textColor(Colors.black)
              .fontSize(15)
              .padding(horizontal: 10, vertical: 2)
              .decorated(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
        ]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .padding(vertical: 20, left: 20),
        Image.asset(
          'assets/wishdoit.png',
          width: 200,
          height: 200,
          fit: BoxFit.cover,
        ),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween).decorated(
          color: Color.fromARGB(255, 252, 217, 149),
          borderRadius: BorderRadius.circular(20));

  Widget titleWidget(String title) => <Widget>[
        Text(title.toUpperCase()).letterSpacing(5).padding(top: 10),
        Text("Products".toUpperCase())
            .letterSpacing(5)
            .fontSize(20)
            .textColor(Colors.white)
            .padding(top: 10),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);

  Widget appBar() => <Widget>[
        const Icon(Icons.menu),
        <Widget>[
          //add two icons to the right of the app bar
          const Icon(Icons.search),
          const SizedBox(width: 20),
          const Icon(Icons.shopping_cart),
        ].toRow()
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
}
