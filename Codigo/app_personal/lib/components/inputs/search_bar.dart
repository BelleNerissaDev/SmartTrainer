import 'package:SmartTrainer_Personal/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:SmartTrainer_Personal/fonts.dart';

class SearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;

  const SearchBar({Key? key, this.onSearchChanged}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var colorTheme = Provider.of<ThemeProvider>(context).colorTheme;
    return Container(
      margin: const EdgeInsets.all(8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Pesquisar',
          hintStyle: Theme.of(context).textTheme.body14px!.copyWith(
                color: colorTheme.grey_font_500,
                fontWeight: FontWeight.w700,
              ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colorTheme.grey_font_500),
          ),
          suffixIcon: const Icon(Icons.search),
        ),
        onChanged: widget.onSearchChanged,
      ),
    );
  }
}
