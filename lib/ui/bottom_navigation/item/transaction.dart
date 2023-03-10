import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyger/common/app_theme_data.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/common/navigate.dart';
import 'package:moneyger/ui/transaction/add_transaction.dart';
import 'package:moneyger/ui/widget/detail_transaction_item.dart';
import 'package:moneyger/ui/widget/headline_item.dart';
import 'package:moneyger/ui/widget/transaction/transaction_history_item.dart';
import 'package:moneyger/ui/widget/user_item/user_item.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigate.navigatorPush(context, const AddTransactionPage());
        },
        backgroundColor: provider.isDarkMode
            ? ColorValueDark.secondaryColor
            : ColorValue.secondaryColor,
        child: const Icon(Icons.add_rounded),
      ),
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              height: 264,
              width: MediaQuery.of(context).size.width,
              color: ColorValue.secondaryColor,
              child: SafeArea(
                child: Column(
                  children: [
                    // remove selamat pagi
                    const SizedBox(
                      height: 80,
                    ),
                    TotalBalanceItem(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "Total Saldo",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFC7C7C7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 264(tinggi container biru) - 65 (tinggi pengeluaran) / 2(maksudnya setengah dari tinggi pengeluaran)
            Container(
              margin: const EdgeInsets.only(top: 264 - 65 / 2),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        DetailTransactionItem(),
                        DetailTransactionItem(
                          isIncome: false,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 32),
                    child: Column(
                      children: [
                        HeadlineItem(
                          image: provider.isDarkMode
                              ? 'transaction_dark'
                              : 'transaction',
                          title: 'Transaksi',
                          desc: 'Transaksi anda selama ini',
                        ),
                        //
                        const SizedBox(
                          height: 16,
                        ),
                        const TransactionHistoryItem(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
