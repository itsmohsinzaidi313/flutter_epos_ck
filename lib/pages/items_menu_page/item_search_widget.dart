part of 'items_menu_page.dart';

class _ItemsSearchBar extends StatelessWidget {
  final TextEditingController? autoCompleteController;
  final Function(String value)? suggestionsCallback;
  final Function(dynamic value)? onSuggestionSelected;

  const _ItemsSearchBar({
    Key? key,
    this.autoCompleteController,
    this.suggestionsCallback,
    this.onSuggestionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: autoCompleteController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Search by item name here',
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () => autoCompleteController!.text = '',
          ),
        ),
      ),
      suggestionsCallback:
          suggestionsCallback as Future<List<Item>> Function(String),
      itemBuilder: (context, dynamic itemData) => ListTile(
        title: Text(itemData.name),
        subtitle: Text(
          'PKR: ${itemData.price}/=\nCode: ${itemData.id}',
        ),
      ),
      onSuggestionSelected: onSuggestionSelected!,
      noItemsFoundBuilder: (context) => ListTile(
        title: Text('No Item Found!'),
      ),
    );
  }
}
