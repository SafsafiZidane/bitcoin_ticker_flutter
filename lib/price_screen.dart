import 'dart:io' show Platform;

import 'package:bitcoin_ticker_flutter/Networking.dart';
import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


final String apiKey = dotenv.env['API_KEY'] ?? 'Key not found';


class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI();

  }


  String ?selectedCurrency = currenciesList.first;
  String bitcoin = '?';
  String ethereum = '?';
  String litecoin = '?';




  Future<void> updateUI() async {
    // 1. Construct URL with lowercase currency
    var url = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,litecoin&vs_currencies=$selectedCurrency&x_cg_demo_api_key=$apiKey';
    String requestCurrency = selectedCurrency?.toLowerCase() ?? 'usd';
    // 2. Fix NetworkHelper call
    NetworkHelper networkHelper = NetworkHelper(url: url);
    var data = await networkHelper.getData();
    print(selectedCurrency);
    print(data);

    setState(() {
      if (data != null && data['bitcoin'] != null) {
        // .toDouble() fixes the 'int is not a subtype of double' error
        // .toStringAsFixed(2) makes it look like a price (e.g. 50000.00)
        bitcoin = data['bitcoin'][requestCurrency].toDouble().toStringAsFixed(2);
        ethereum = data['ethereum'][requestCurrency].toDouble().toStringAsFixed(2);
        litecoin = data['litecoin'][requestCurrency].toDouble().toStringAsFixed(2);
      }
    });



  }


  Widget card (String coin, String coinValue){

    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child:  Text(
            '1 $coin = $coinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }


  CupertinoPicker iOSPicker(){
    List<Text> pickItems = [];
    for (String currency in currenciesList) {
      pickItems.add(Text(currency));
    }

    return CupertinoPicker(
        itemExtent: 30.0,
        onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickItems,
    );
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(value: currency, child: Text(currency));
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
      hint: Text('select currency'),
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          updateUI();
        });
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🤑 Coin Ticker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Column(children: [
              Row(children: [Expanded(child: card('bitcoin',bitcoin))],),
              Row(children: [Expanded(child: card('ethereum',ethereum))],),
              Row(children: [Expanded(child: card('litecoin',litecoin))],),
            ],),
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
