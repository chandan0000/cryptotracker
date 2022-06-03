import 'package:cryptotracker/models/Crrptocurrency.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  final String id;
  const DetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Widget titleAndDetail(
      String title, String detail, CrossAxisAlignment crossAxisAlignment) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        Text(
          detail,
          style: TextStyle(fontSize: 17),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 2, right: 20),
          child: Consumer<MarketProvider>(
            builder: (context, marketProvider, child) {
              CryptoCurrency cureentCrypto =
                  marketProvider.fetchCryptoById(widget.id);
              return RefreshIndicator(
                onRefresh: () async {
                  await marketProvider.fetchData();
                },
                child: ListView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(cureentCrypto.image!),
                      ),
                      title: Text(
                        cureentCrypto.name! +
                            "(${cureentCrypto.symbol!.toUpperCase()})",
                        style: TextStyle(fontSize: 30),
                      ),
                      subtitle: Text(
                        "₹ " + cureentCrypto.currentPrice!.toStringAsFixed(4),
                        style: TextStyle(
                            color: Color(0xff0395eb),
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price Change (24h)",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Builder(
                          builder: (context) {
                            double priceChange = cureentCrypto.priceChange24!;
                            double priceChangePercentage =
                                cureentCrypto.priceChangePercentage24!;

                            if (priceChange < 0) {
                              // negative
                              return Text(
                                "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 23),
                              );
                            } else {
                              // positive
                              return Text(
                                "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 23),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        titleAndDetail(
                            "Market Cap",
                            "₹ " + cureentCrypto.marketCap!.toStringAsFixed(4),
                            CrossAxisAlignment.start),
                        titleAndDetail(
                            "Market Cap Rank",
                            "#" + cureentCrypto.marketCapRank.toString(),
                            CrossAxisAlignment.end),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail(
                            "Low 24h",
                            "₹ " + cureentCrypto.low24!.toStringAsFixed(4),
                            CrossAxisAlignment.start),
                        titleAndDetail(
                            "High 24h",
                            "₹ " + cureentCrypto.high24!.toStringAsFixed(4),
                            CrossAxisAlignment.end),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail(
                            "Circulating Supply",
                            cureentCrypto.circulatingSupply!.toInt().toString(),
                            CrossAxisAlignment.start),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        titleAndDetail(
                            "All Time Low",
                            cureentCrypto.atl!.toStringAsFixed(4),
                            CrossAxisAlignment.start),
                        titleAndDetail(
                            "All Time High",
                            cureentCrypto.ath!.toStringAsFixed(4),
                            CrossAxisAlignment.start),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
