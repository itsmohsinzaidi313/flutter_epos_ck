part of 'order_info_page.dart';

class DeliveryLayout extends StatelessWidget {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final addressController = TextEditingController();
  final orderType = ORDERTYPE.DELIVERY;
  static Key nameKey = GlobalKey();
  static Key contactKey = GlobalKey();
  static Key addressKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderInfoBloc, OrderInfoState>(
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.orderType == orderType) {
            nameController.text = state.customer.name;
            contactController.text = state.customer.contact;
            addressController.text = state.customer.address;
            AppTheme.snackbar(context, state.message);
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
                        onChanged: (value) => passEvent(context,
                            ContactChanged(type: orderType, contact: value)),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.dialpad,
                              size: 20,
                            ),
                            label: Text('Contact'),
                            hintText: 'e.g. 03121234567',
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
                            context,
                            CustomerChanged(
                                type: orderType, customerName: value)),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              size: 20,
                            ),
                            hintText: 'e.g. Najam',
                            label: Text('Name'),
                            border: InputBorder.none,
                            errorText: null),
                      ),
                    ),
                  ],
                ),
                const Divider(thickness: 1),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        key: addressKey,
                        controller: addressController,
                        onChanged: (value) => passEvent(context,
                            AddressChanged(type: orderType, address: value)),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.home,
                              size: 20,
                            ),
                            hintText: 'e.g. H#1, Floor# 2, Building xyz',
                            label: Text('Address'),
                            border: InputBorder.none,
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
                  'Delivery-Orders'.toUpperCase(),
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
