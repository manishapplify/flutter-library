import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    required this.onQueryChanged,
    required this.isSearchBarOpenNotifier,
    Key? key,
  }) : super(key: key);

  final Function(String query) onQueryChanged;
  final ValueNotifier<bool> isSearchBarOpenNotifier;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  final double _searchBarHeight = kToolbarHeight * 0.65;
  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;
  late final ValueNotifier<bool> _notifier = widget.isSearchBarOpenNotifier;
  double _searchBarWidth = 0.0;
  double _maxWidth = 0.0;

  @override
  void initState() {
    _notifier.addListener(_onNotifierValue);
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _maxWidth = MediaQuery.of(context).size.width - 100;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    _notifier.removeListener(_onNotifierValue);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _searchBarWidth),
      builder: (BuildContext context, double widthDx, Widget? _child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: _searchBarHeight,
              width: widthDx,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                left: 10,
              ),
              child: _child,
              decoration: BoxDecoration(
                color: widthDx > 0 ? Colors.white : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(3)),
              ),
            ),
            IconButton(
              onPressed: () {
                // Clear the input.
                if (_notifier.value && _textEditingController.text.isNotEmpty) {
                  _textEditingController.value = TextEditingValue.empty;
                  widget.onQueryChanged('');
                }
                // Input is empty, close the search bar.
                else if (_notifier.value) {
                  _notifier.value = false;
                }
                // Open the search bar.
                else {
                  _notifier.value = true;
                }
              },
              icon: Icon(
                widthDx > 0 ? Icons.cancel_outlined : Icons.search,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        );
      },
      child: TextField(
        focusNode: _focusNode,
        controller: _textEditingController,
        onChanged: widget.onQueryChanged,
        style: Theme.of(context).textTheme.headline2,
        cursorWidth: 1,
        textAlignVertical: TextAlignVertical.top,
        decoration: const InputDecoration(
          filled: false,
          focusedBorder: InputBorder.none,
          hintText: 'Search a user...',
          contentPadding: EdgeInsets.only(bottom: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black45,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.black45,
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
          ),
          labelStyle: TextStyle(
            color: Colors.black87,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        onSubmitted: (_) => _notifier.value = false,
      ),
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onNotifierValue() {
    // true -> request focus, open search bar
    // false -> unfocus, clear text input, close search bar
    if (_notifier.value) {
      _focusNode.requestFocus();
      _openSearchBar();
    } else {
      _focusNode.unfocus();
      _textEditingController.value = TextEditingValue.empty;
      _closeSearchBar();
    }
  }

  void _closeSearchBar() {
    setState(() {
      _searchBarWidth = 0;
    });
  }

  void _openSearchBar() {
    setState(() {
      _searchBarWidth = _maxWidth;
    });
  }
}
