import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  Function searchItem;
  TextEditingController searchController;
  SearchBarWidget(this.searchItem,this.searchController);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
        child: SearchBar(
          controller: widget.searchController,
          hintText: "Search Recorded Meeting by title ",
          onSubmitted: (value){

            widget.searchItem();
          },
          leading: IconButton(icon: Icon(Icons.search),onPressed: (){

            widget.searchItem();
          },),
        ),
      ),
    );
  }
}

