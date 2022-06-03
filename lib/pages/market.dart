import 'package:cryptotracker/models/Crrptocurrency.dart';
import 'package:cryptotracker/providers/market_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'detailsPage.dart';

class Markets extends StatefulWidget {
  const Markets({Key? key}) : super(key: key);

  @override
  State<Markets> createState() => _MarketsState();
}

class _MarketsState extends State<Markets> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MarketProvider>(builder: (context, marketProvider, child) {
      if (marketProvider.isLoading == true) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        if (marketProvider.markets.length > 0) {
          return RefreshIndicator(
            onRefresh: () async {
              await marketProvider.fetchData();
            },
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemCount: marketProvider.markets.length,
              itemBuilder: (context, index) {
                CryptoCurrency curentCypto = marketProvider.markets[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsPage(
                          id: curentCypto.id!,
                        ),
                      ),
                    );
                  },
                  contentPadding: EdgeInsets.all(0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(curentCypto.image!),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          curentCypto.name! + " #${curentCypto.marketCapRank!}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      (curentCypto.isFavorite == false)
                          ? GestureDetector(
                              onTap: () {
                                marketProvider.addFavorite(curentCypto);
                              },
                              child: Icon(
                                CupertinoIcons.heart,
                                size: 18,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                marketProvider.removeFavorite(curentCypto);
                              },
                              child: Icon(
                                CupertinoIcons.heart_fill,
                                size: 18,
                                color: Colors.red,
                              ),
                            ),
                    ],
                  ),
                  subtitle: Text(curentCypto.symbol!.toUpperCase()),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "₹ " + curentCypto.currentPrice!.toStringAsFixed(4),
                        style: TextStyle(
                          color: Color(
                            0xff0395eb,
                          ),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          double priceChange = curentCypto.priceChange24!;
                          double priceChangePercentage =
                              curentCypto.priceChangePercentage24!;
                          if (priceChange < 0) {
                            //-
                            return Text(
                              "${priceChangePercentage.toStringAsFixed(2)}% (${priceChange.toStringAsFixed(4)})",
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            //+
                            return Text(
                              "+${priceChangePercentage.toStringAsFixed(2)}% (+${priceChange.toStringAsFixed(4)})",
                              style: TextStyle(color: Colors.green),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        } else {
          return Text("Data Not Found");
        }
      }
    });
  }
}
