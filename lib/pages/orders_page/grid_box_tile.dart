part of 'orders_page.dart';

class _GridBoxTile extends StatelessWidget {
  final String title;
  final String description;
  final FontWeight fontWeight;
  const _GridBoxTile(
      {Key key,
      this.title,
      this.description,
      this.fontWeight = FontWeight.normal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridTextStyle = TextStyle(fontSize: 12, fontWeight: fontWeight);
    return Row(
      children: [
        Text(
          title,
          style: gridTextStyle ?? '',
        ),
        Expanded(child: SizedBox()),
        Text(
          description ?? '',
          style: gridTextStyle,
        ),
      ],
    );
  }
}
