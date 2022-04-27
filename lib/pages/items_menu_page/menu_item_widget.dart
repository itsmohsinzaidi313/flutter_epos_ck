part of 'items_menu_page.dart';

class _ItemButton extends StatefulWidget {
  final Item item;
  final String subtitle;
  final bool showSubtitle;
  final bool isSelectable;
  final FutureOr<bool> Function(FutureOr<bool> selected) onSelected;
  final void Function() onTap;
  _ItemButton(
      {Key key,
      this.item,
      this.subtitle,
      this.showSubtitle = false,
      this.isSelectable = false,
      this.onSelected,
      this.onTap})
      : super(key: key);

  @override
  _ItemButtonState createState() => _ItemButtonState();
}

class _ItemButtonState extends State<_ItemButton> {
  FutureOr<bool> _selected = false;
  void onSelected() {
    if (widget.isSelectable) {
      setState(() {
        _selected = widget.onSelected(_selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: InkWell(
        onTap: widget.isSelectable ? onSelected : widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 10,
                right: 10,
                child: widget.isSelectable
                    ? Center(
                        child: _selected
                            ? Icon(Icons.check_circle_rounded)
                            : Icon(Icons.check_circle_outline_outlined),
                      )
                    : Container(),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      widget.item.name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntuCondensed(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0,
                        wordSpacing: 0.5,
                      ),
                    ),
                  ),
                  widget.showSubtitle
                      ? Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.subtitle,
                                style: GoogleFonts.ubuntuCondensed(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Divider(),
                  Expanded(
                    child: Text(
                      'PKR ${widget.item.price}',
                      style: GoogleFonts.ubuntuCondensed(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        wordSpacing: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
