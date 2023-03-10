import 'package:flutter/material.dart';
import 'package:moneyger/common/app_theme_data.dart';
import 'package:moneyger/service/firebase_service.dart';
import 'package:provider/provider.dart';

class CustomPopMenuTransaction extends PopupMenuEntry<int> {
  final List data;
  final String isSelectedIncome;

  const CustomPopMenuTransaction(
      {super.key, required this.data, required this.isSelectedIncome});

  @override
  final double height = 100;

  @override
  bool represents(int? value) => value == 1 || value == -1;

  @override
  PlusMinusEntryState createState() => PlusMinusEntryState();
}

class PlusMinusEntryState extends State<CustomPopMenuTransaction> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final provider = Provider.of<ThemeProvider>(context);

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _buildPopupDialog(context),
        ).then(
          (value) => Navigator.pop(context),
        );
      },
      borderRadius: BorderRadius.circular(4),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            'Hapus',
            style: textTheme.bodyText1!.copyWith(
              color: provider.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      elevation: 0,
      title: const Text('Peringatan'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Apakah anda yakin ingin menghapus ${widget.data[1]}?'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Kembali'),
        ),
        TextButton(
          onPressed: () async {
            var data = widget.data;
            await FirebaseService()
                .deleteTransaction(
                  context,
                  docId: data[4],
                  type: widget.isSelectedIncome,
                  total: data[0],
                  day: data[2],
                  week: data[3],
                )
                .then(
                  (value) => value ? Navigator.pop(context) : null,
                );
          },
          child: const Text('Hapus'),
        ),
      ],
    );
  }
}
