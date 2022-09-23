part of 'order_info_page.dart';

class TakeAwayLayout extends StatelessWidget {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final orderType = OrderType.takeAway;
  static Key nameKey = GlobalKey();
  static Key contactKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.order.orderType == orderType) {
            nameController.text = state.order.customer.name;
            contactController.text = state.order.customer.contact;
          }
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        key: nameKey,
                        controller: contactController,
                        onChanged: (value) =>
                            passEvent(context, ContactChanged(contact: value)),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              size: 20,
                            ),
                            hintText: 'e.g. 03121234567',
                            label: Text('Contact'),
                            border: InputBorder.none,
                            errorText: null),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 20,
                        ),
                        onPressed: () =>
                            passEvent(context, SearchCustomer(type: orderType)),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        key: contactKey,
                        controller: nameController,
                        onChanged: (value) => passEvent(
                            context, CustomerChanged(customerName: value)),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                            ),
                            border: InputBorder.none,
                            hintText: 'e.g. Najam',
                            label: Text('Name'),
                            errorText: null),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(),
                ),
              ),
              child: Center(
                child: Text(
                  'TakeAway-Orders'.toUpperCase(),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void passEvent(BuildContext c, OrderInfoEvent event) =>
      c.read<OrderInfoBloc>().add(event);
}
