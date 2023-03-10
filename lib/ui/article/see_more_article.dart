import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moneyger/common/app_theme_data.dart';
import 'package:moneyger/common/color_value.dart';
import 'package:moneyger/model/article_model.dart';
import 'package:moneyger/ui/widget/artikel/artikel_card.dart';
import 'package:provider/provider.dart';

class SeeMoreArticle extends StatefulWidget {
  final List<ArticleModel> article;

  const SeeMoreArticle({Key? key, required this.article}) : super(key: key);

  @override
  State<SeeMoreArticle> createState() => _SeeMoreArticleState();
}

class _SeeMoreArticleState extends State<SeeMoreArticle> {
  List<ArticleModel> _article = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _article = widget.article;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          'Artikel',
          style: TextStyle(
            color: provider.isDarkMode
                ? Colors.white
                : ColorValueDark.backgroundColor,
          ),
        ),
        backgroundColor:
            provider.isDarkMode ? ColorValueDark.backgroundColor : Colors.white,
        iconTheme: IconThemeData(
          color: provider.isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          IconButton(
            splashRadius: 30,
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchArticle(article: _article),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Column(
            children: [
              _article.isEmpty
                  ? Container()
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 16),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _article.length,
                      itemBuilder: (context, index) {
                        return ArtikelCard(
                          judul: _article[index].judul ?? '-',
                          subjudul: _article[index].subjudul ?? '-',
                          tanggalPosting: _article[index].tanggalPosting ?? '-',
                          penulis: _article[index].penulis ?? '-',
                          foto: _article[index].foto ?? '-',
                          isiArtikel: _article[index].isiArtikel ?? '-',
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchArticle extends SearchDelegate {
  final List<ArticleModel> article;

  SearchArticle({required this.article});

  @override
  String get searchFieldLabel => 'Cari';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    final provider = Provider.of<ThemeProvider>(context);

    return [
      IconButton(
        splashRadius: 30,
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: Icon(
          Icons.clear_rounded,
          color: provider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    final provider = Provider.of<ThemeProvider>(context);

    return IconButton(
      splashRadius: 30,
      onPressed: () {
        close(context, null);
      },
      icon: Icon(
        Icons.arrow_back,
        color: provider.isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    List<ArticleModel> data = article.where((element) {
      final result = element.judul!.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return data.isEmpty
        ? Center(
            child: Text(
              'Artikel tidak ditemukan',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ArtikelCard(
                    judul: data[index].judul ?? '-',
                    subjudul: data[index].subjudul ?? '-',
                    tanggalPosting: data[index].tanggalPosting ?? '-',
                    penulis: data[index].penulis ?? '-',
                    foto: data[index].foto ?? '-',
                    isiArtikel: data[index].isiArtikel ?? '-',
                  );
                },
              ),
            ),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<ArticleModel> data = article.where((element) {
      final result = element.judul!.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return data.isEmpty
        ? Center(
            child: Text(
              'Artikel tidak ditemukan',
              style: GoogleFonts.poppins(
                fontSize: 14,
              ),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ArtikelCard(
                    judul: data[index].judul ?? '-',
                    subjudul: data[index].subjudul ?? '-',
                    tanggalPosting: data[index].tanggalPosting ?? '-',
                    penulis: data[index].penulis ?? '-',
                    foto: data[index].foto ?? '-',
                    isiArtikel: data[index].isiArtikel ?? '-',
                  );
                },
              ),
            ),
          );
  }
}
