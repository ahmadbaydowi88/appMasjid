import 'package:flutter/material.dart';
import 'package:apppengelolaan/src/view/animatedSearchBar.dart.bak';

class AppbarMain extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final showBackButton;
  final onPressBackButton;
  final Widget leadingWidget;
  final bool showSearchIcon;
  final Function onSearch;
  final Function onOpenSearchBar;
  final Function onCloseSearchBar;
  final bool showOnlySearchIcon;
  final Color backgroundColor;
  AppbarMain(
      {Key key,
      this.title,
      this.showBackButton = false,
      this.onPressBackButton,
      this.leadingWidget,
      this.showSearchIcon = false,
      this.onSearch(String query),
      this.onOpenSearchBar,
      this.onCloseSearchBar,
      this.backgroundColor,
      this.showOnlySearchIcon = false})
      : super(key: key);

  @override
  AppbarMainState createState() => AppbarMainState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class AppbarMainState extends State<AppbarMain> {
  GlobalKey<AnimatedSearchBarState> _ks = GlobalKey();

  // static Color get backgroundColor => backgroundColor;

  void openSearch({String initialValue}) {
    _ks.currentState.openSearch(initialValue: initialValue);
    if (widget.onOpenSearchBar != null) widget.onOpenSearchBar();
  }

  void closeSearch() {
    _ks.currentState.closeSearch();
    if (widget.onCloseSearchBar != null) widget.onCloseSearchBar();
  }

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: widget.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: true,
      leading: widget.showBackButton
          ? BackButton(
              onPressed: () {
                if (widget.onPressBackButton != null) {
                  widget.onPressBackButton();
                }
              },
            )
          : widget.leadingWidget,
      title: widget.showSearchIcon
          ? Text("")
          : widget.title == ""
              ? Text("")
              : FittedBox(fit: BoxFit.fitWidth, child: Text(widget.title)),
      actions: <Widget>[
        //seacrh
        Visibility(
          visible: widget.showSearchIcon,
          child: AnimatedSearchBar(
              key: _ks,
              onClose: widget.onCloseSearchBar,
              onOpen: widget.onOpenSearchBar,
              margin: EdgeInsets.only(left: 60),
              label: widget.title,
              labelStyle: TextStyle()
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 22),
              searchStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 22),
              cursorColor: Colors.white,
              searchDecoration: InputDecoration(
                hintText: "Cari",
                alignLabelWithHint: true,
                fillColor: Colors.white,
                focusColor: Colors.white,
                hintStyle: TextStyle(color: Colors.white70),
                border: InputBorder.none,
              ),
              onSubmited: (x) {
                widget.onSearch(x);
              }),
        ),
        //histori sudah disposisi surat masuk
      ],
    );
  }
}
