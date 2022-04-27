part of 'order_info_page.dart';

class _TablesGrid extends StatelessWidget {
  final List<Tables> listTables;
  final void Function(BuildContext context, Tables table) onTap;
  const _TablesGrid({Key key, this.listTables, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: listTables.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) => Card(
        elevation: 10,
        color: listTables[index].selected
            ? Colors.redAccent[200]
            : Colors.grey.shade100,
        child: InkWell(
          child: Stack(
            children: [
              Positioned(
                top: 2,
                left: 2,
                child: Text(
                  listTables[index].name,
                  style: GoogleFonts.ubuntuCondensed(
                    color: Colors.grey.shade900,
                    fontSize: 16,
                    letterSpacing: 1.0,
                    wordSpacing: 1.0,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Image(
                    image: AssetImage('assets/table.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(-1, -1),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: listTables[index].reserved
                      ? Icon(Icons.lock, color: Colors.black)
                      : Icon(Icons.check,
                          color: listTables[index].selected
                              ? Colors.green
                              : Colors.white),
                ),
              ),
            ],
          ),
          onTap: () {
            onTap(context, listTables[index]);
          },
        ),
      ),
    );
  }
}