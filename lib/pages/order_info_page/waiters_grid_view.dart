part of 'order_info_page.dart';

class _WaitersGrid extends StatelessWidget {
  final List<Waiter> listWaiters;
  final void Function(BuildContext context, Waiter waiter) onTap;
  const _WaitersGrid({
    Key? key,
    required this.listWaiters,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: listWaiters.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
      ),
      itemBuilder: (context, index) => Container(
        child: Card(
          color: listWaiters[index].selected
              ? Colors.redAccent[200]
              : Colors.white,
          child: InkWell(
            child: Stack(
              children: [
                Positioned(
                  bottom: 2,
                  left: 2,
                  child: Text(
                    listWaiters[index].name.toUpperCase(),
                    style: GoogleFonts.ubuntuCondensed(
                      color: listWaiters[index].selected
                          ? Colors.black
                          : Colors.grey[800],
                      fontSize: 14,
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
                    margin: EdgeInsets.all(20),
                    child: Image(
                      image: AssetImage('assets/waiter.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              onTap(context, listWaiters[index]);
            },
          ),
        ),
      ),
    );
  }
}
