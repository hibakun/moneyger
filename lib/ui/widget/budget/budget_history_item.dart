import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moneyger/common/app_theme_data.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/common/shared_code.dart';
import 'package:moneyger/ui/budget/detail_budget.dart';
import 'package:moneyger/ui/widget/loading/shimmer_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class BudgetHistoryItem extends StatefulWidget {
  const BudgetHistoryItem({Key? key}) : super(key: key);

  @override
  State<BudgetHistoryItem> createState() => _BudgetHistoryItemState();
}

class _BudgetHistoryItemState extends State<BudgetHistoryItem> {
  final _collection = FirebaseFirestore.instance
      .collection('users')
      .doc(SharedCode().uid)
      .collection('budget');

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<ThemeProvider>(context);

    return StreamBuilder<QuerySnapshot>(
        stream: _collection.orderBy('updated_at', descending: true).snapshots(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/not_found.json',
                      repeat: false,
                    ),
                    Text(
                      'Data masih kosong',
                      style: textTheme.headline3!.copyWith(
                        color: ColorValue.greyColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                final data = snapshot.data!.docs[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailBudgetPage(
                            docId: data.id,
                          ),
                        ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorValue.borderColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.only(bottom: 15),
                    margin: const EdgeInsets.only(top: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: const Color(0xFFF9F9F9),
                                child: SvgPicture.asset(
                                  'assets/budget/${data['category'].toString().toLowerCase()}.svg',
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['category'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: provider.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    data['desc'],
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 16,
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: ColorValue.borderColor,
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Anggaran',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    SharedCode()
                                        .convertToIdr(data['budget'], 0),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: provider.isDarkMode
                                          ? ColorValueDark.secondaryColor
                                          : ColorValue.secondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Sisa',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    SharedCode()
                                        .convertToIdr(data['remain'], 0),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: provider.isDarkMode
                                          ? ColorValueDark.secondaryColor
                                          : ColorValue.secondaryColor,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 63,
                          animation: true,
                          lineHeight: 15.0,
                          animationDuration: 750,
                          percent: SharedCode().getPercentDouble(
                              data['budget'] ?? 0, data['used'] ?? 0),
                          center: Text(
                            SharedCode()
                                .getPercentString(data['budget'], data['used']),
                            style: const TextStyle(color: Colors.black),
                          ),
                          barRadius: const Radius.circular(16),
                          progressColor: provider.isDarkMode
                              ? ColorValueDark.secondaryColor
                              : ColorValue.secondaryColor,
                          backgroundColor: const Color(0xFFEDF0F4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ShimmerWidget(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    radius: 8,
                  ),
                );
              },
            );
          }
        });
  }
}
