import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneyger/common/app_theme_data.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/common/navigate.dart';
import 'package:moneyger/main.dart';
import 'package:moneyger/model/article_model.dart';
import 'package:moneyger/service/api_service.dart';
import 'package:moneyger/ui/article/see_more_article.dart';
import 'package:moneyger/ui/budget/add_budget.dart';
import 'package:moneyger/ui/chat/chat.dart';
import 'package:moneyger/ui/transaction/add_transaction.dart';
import 'package:moneyger/ui/widget/artikel/artikel_card.dart';
import 'package:moneyger/ui/widget/chart/chart_widget.dart';
import 'package:moneyger/ui/widget/detail_transaction_item.dart';
import 'package:moneyger/ui/widget/headline_item.dart';
import 'package:moneyger/ui/widget/transaction/transaction_history_item.dart';
import 'package:moneyger/ui/widget/user_item/user_item.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ArticleModel> _article = [];
  final ValueNotifier<bool> isDialOpen = ValueNotifier<bool>(false);

  Future _getArtikel() async {
    await ApiService().getArticle().then((value) {
      setState(() {
        _article = value;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getArtikel();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<ThemeProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: _speedDial(provider.isDarkMode),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeNameItem(),
                  Text(
                    'Pendapatan dan Pengeluaran kamu bulan ini',
                    style: textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                    decoration: BoxDecoration(
                      color: provider.isDarkMode
                          ? ColorValueDark.darkColor
                          : const Color(0XFFF9F9F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Saldo',
                                style: textTheme.bodyText2!.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TotalBalanceItem(
                                textStyle: TextStyle(
                                  color: provider.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const AspectRatio(
                          aspectRatio: 1.8,
                          child: ChartWidget(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      DetailTransactionItem(),
                      DetailTransactionItem(isIncome: false),
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  HeadlineItem(
                    image: provider.isDarkMode
                        ? 'transaction_dark'
                        : 'transaction',
                    title: 'Transaksi',
                    desc: 'Beberapa transaksi kamu akhir-akhir ini',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const TransactionHistoryItem(
                    isHome: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  HeadlineItem(
                    image: provider.isDarkMode ? 'consultation_dark' : 'info',
                    title: 'Konsultasi Keuangan',
                    desc: 'Konsultasikan keuanganmu!',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    height: 136,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    padding: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: ColorValue.secondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Image.asset('assets/images/konsultasi.png'),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ingin Konsultasi?',
                                style: textTheme.headline3!.copyWith(
                                  color: provider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Bingung dengan Keuangan kamu sekarang? Konsultasi aja!',
                                style: textTheme.bodyText2!.copyWith(
                                  color: provider.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: provider.isDarkMode
                                      ? ColorValueDark.darkColor
                                      : Colors.white,
                                  minimumSize: const Size(74, 24),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const ChatPage(),
                                      )).whenComplete(() => Future.delayed(
                                          const Duration(milliseconds: 250))
                                      .then((value) => statusBarStyle()));
                                },
                                child: Text(
                                  'Konsultasi',
                                  style: textTheme.bodyText2!.copyWith(
                                    color: ColorValue.secondaryColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  HeadlineItem(
                    image: provider.isDarkMode ? 'article_dark' : 'article',
                    title: 'Artikel',
                    desc: 'Artikel mengenai ekonomi',
                  ),
                  _article.isEmpty
                      ? Container()
                      : ListView.builder(
                          padding: const EdgeInsets.only(top: 16),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return ArtikelCard(
                              judul: _article[index].judul ?? '-',
                              subjudul: _article[index].subjudul ?? '-',
                              tanggalPosting:
                                  _article[index].tanggalPosting ?? '-',
                              penulis: _article[index].penulis ?? '-',
                              foto: _article[index].foto ?? '-',
                              isiArtikel: _article[index].isiArtikel ?? '-',
                            );
                          },
                        ),
                  TextButton(
                    onPressed: () {
                      Navigate.navigatorPush(
                        context,
                        SeeMoreArticle(
                          article: _article,
                        ),
                      );
                    },
                    child: const Text('Lebih banyak Artikel'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _speedDial(bool isDarkMode) {
    return SpeedDial(
      icon: Icons.add_rounded,
      activeIcon: Icons.close_rounded,
      backgroundColor: isDarkMode
          ? ColorValueDark.secondaryColor
          : ColorValue.secondaryColor,
      renderOverlay: true,
      overlayColor: isDarkMode ? ColorValueDark.backgroundColor : Colors.white,
      overlayOpacity: 0.5,
      childrenButtonSize: const Size(60, 60),
      spacing: 5,
      spaceBetweenChildren: 5,
      openCloseDial: isDialOpen,
      children: [
        SpeedDialChild(
          child: SvgPicture.asset(
            'assets/icons/transaction.svg',
            color: isDarkMode ? ColorValueDark.backgroundColor : Colors.white,
            width: 18,
            height: 18,
          ),
          backgroundColor: isDarkMode
              ? ColorValueDark.secondaryColor
              : ColorValue.secondaryColor,
          foregroundColor: Colors.white,
          label: 'Transaksi',
          labelStyle:
              TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          onTap: () => Navigate.navigatorPush(
              context,
              const AddTransactionPage(
                isFromHome: true,
              )),
        ),
        SpeedDialChild(
          child: SvgPicture.asset(
            'assets/icons/budget.svg',
            color: isDarkMode ? ColorValueDark.backgroundColor : Colors.white,
            width: 18,
            height: 18,
          ),
          backgroundColor: isDarkMode
              ? ColorValueDark.secondaryColor
              : ColorValue.secondaryColor,
          foregroundColor: Colors.white,
          label: 'Anggaran',
          labelStyle:
              TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          onTap: () => Navigate.navigatorPush(
              context,
              const AddBudgetPage(
                isFromHome: true,
              )),
        ),
      ],
    );
  }
}
