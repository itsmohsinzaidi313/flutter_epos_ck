part of 'order_info_page.dart';

class _TablesList extends StatelessWidget {
  final List<Tables> listTables;
  final void Function(BuildContext context, Tables table) onTap;
  const _TablesList({Key key, this.listTables, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        title: Text(listTables[index].name.toUpperCase()),
        trailing: Checkbox(
          value: listTables[index].selected,
          onChanged: (value) => onTap(context, listTables[index]),
        ),
        subtitle: Text(
          listTables[index].reserved ? 'Table is reserved' : 'Table is open',
          style: TextStyle(
            color: listTables[index].reserved ? Colors.red : Colors.green,
          ),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: listTables.length,
    );
  }
}
