part of 'order_info_page.dart';

class _WaitersList extends StatelessWidget {
  final List<Waiter> waitersList;
  final void Function(
    BuildContext context,
    Waiter waiter,
  ) onTap;

  const _WaitersList({
    Key key,
    this.waitersList,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => ListTile(
        title: Text(waitersList[index].name.toUpperCase()),
        trailing: Checkbox(
          value: waitersList[index].selected,
          onChanged: (value) => onTap(context, waitersList[index]),
        ),
      ),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: waitersList.length,
    );
  }
}
