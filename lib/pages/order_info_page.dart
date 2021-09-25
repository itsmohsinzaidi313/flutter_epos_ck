import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pos_app/bloc/order_info_bloc/order_info_bloc.dart';
import 'package:pos_app/models/objects/member.dart';
import 'package:pos_app/repositories/members_repository.dart';
import '../shared/app_theme.dart';
import '../shared/config.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/app_widgets.dart';

class OrderInfoPage extends StatelessWidget {
  final String radioGroupValue = 'By Code';
  final TextEditingController _autoCompleteController = TextEditingController();
  final controller = FloatingSearchBarController();
  InputDecoration inputDecoration(Icon icon, String label, String helperText) =>
      InputDecoration(
        icon: icon,
        labelText: label,
        helperText: helperText,
        helperMaxLines: 2,
      );
  bool ranOnce = false;

  void init(BuildContext context) {
    passEvent(context, OrderInfoBuild());
    ranOnce = !ranOnce;
  }

  @override
  Widget build(BuildContext context) {
    if (!ranOnce) init(context);
    double textFieldWidth = Config.getDeviceWidth(context) * 0.3;
    return Scaffold(
      body: BlocListener<OrderInfoBloc, OrderInfoState>(
        listener: (context, state) {
          if (state is OrderInfoError) {
            AppTheme.snackbar(context, state.message);
          } else if (state is OrderInfoValid) {
            Navigator.of(context).pushNamed('/pos', arguments: state.order);
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: Config.getDeviceWidth(context),
            height: Config.getDeviceHeight(context),
            child: Column(
              children: [
                CustomAppBar(
                  appBarTitle: 'Order Info Screen',
                  searchBar: autoCompleteSearchBar(context),
                  radioButtons: SizedBox(),
                  onBackPressed: () => Navigator.pop(context),
                ),
                BlocBuilder<OrderInfoBloc, OrderInfoState>(
                  buildWhen: (previous, current) {
                    if (current is OrderInfoStateMembers) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  builder: (context, state) {
                    if (state is OrderInfoStateMembers) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomLabelledTextView(
                                labelName: 'Member Name',
                                text: state.members.length > 0
                                    ? state.members.last?.memberName
                                    : '...',
                              ),
                              CustomLabelledTextView(
                                labelName: 'Member Code',
                                text: state.members.length > 0
                                    ? state.members.last?.memberCode
                                    : '...',
                              ),
                              CustomLabelledTextView(
                                labelName: 'Member Status',
                                text: state.members.length > 0
                                    ? state.members.last?.memberStatus
                                    : '...',
                              ),
                            ],
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          BlocBuilder<OrderInfoBloc, OrderInfoState>(
                            buildWhen: (previous, current) {
                              if (current is OrderInfoStateSession) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              if (state is OrderInfoStateSession) {
                                return SessionDropdown(
                                  sessions: state.sessions,
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          BlocBuilder<OrderInfoBloc, OrderInfoState>(
                            buildWhen: (previous, current) {
                              if (current is OrderInfoStateVenues) {
                                return true;
                              } else {
                                return false;
                              }
                            },
                            builder: (context, state) {
                              if (state is OrderInfoStateVenues) {
                                return VenueDropdown(
                                  venues: state.venues,
                                );
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: textFieldWidth,
                      child: TextField(
                          decoration: inputDecoration(const Icon(Icons.person),
                              'Waiter', 'Please enter valid waiter'),
                          onChanged: (value) => passEvent(context,
                              OrderInfoWaiterNoChanged(waiterNo: value))),
                    ),
                    Container(
                      width: textFieldWidth,
                      child: TextField(
                          decoration: inputDecoration(
                              const Icon(Icons.wine_bar),
                              'Table',
                              'Please enter valid table no'),
                          onChanged: (value) => passEvent(context,
                              OrderInfoTableNoChanged(tableNo: value))),
                    ),
                    Container(
                      width: textFieldWidth,
                      child: TextField(
                        decoration: inputDecoration(const Icon(Icons.dialpad),
                            'Cover', 'Please enter valid cover no'),
                        onChanged: (value) => passEvent(
                            context, OrderInfoCoversChanged(covers: value)),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IsPartyCheckBox(
                      isChecked: false,
                    ),
                  ],
                ),
                Container(
                  child: BlocBuilder<OrderInfoBloc, OrderInfoState>(
                    buildWhen: (previous, current) =>
                        current is OrderInfoStateMembers,
                    builder: (context, state) {
                      if (state is OrderInfoStateMembers) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            seeMultipleMembers(
                                context: context, member: state.members),
                            submitButton(),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return BlocBuilder<OrderInfoBloc, OrderInfoState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(right: 5.0),
          child: SizedBox(
            width: Config.getDeviceWidth(context) * 0.4,
            height: Config.getDeviceHeight(context) * 0.08,
            child: ElevatedButton.icon(
              onPressed: () => passEvent(context, OrderInfoSubmit()),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppTheme.listTextColor)),
              label: Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SUBMIT',
                      style: GoogleFonts.ubuntuCondensed(
                        color: Colors.white,
                        letterSpacing: 1.0,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
              icon: Icon(
                Icons.check,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget autoCompleteSearchBar(BuildContext context) {
    return TypeAheadField(
      getImmediateSuggestions: true,
      textFieldConfiguration: TextFieldConfiguration(
        controller: _autoCompleteController,
        autofocus: false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search a Member..',
          prefixIcon: Icon(
            Icons.search_sharp,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear_rounded),
            onPressed: () {
              this._autoCompleteController.text = "";
            },
          ),
        ),
      ),
      suggestionsCallback: (pattern) async {
        if (pattern != '') {
          return await MembersRepo.repo.searchingMember(phrase: pattern);
        } else {
          return <Member>[];
        }
      },
      suggestionsBoxDecoration: SuggestionsBoxDecoration(),
      itemBuilder: (BuildContext context, Member suggestion) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(suggestion.memberName),
            subtitle: Text(
              'Code: ${suggestion.memberCode}',
            ),
          ),
        );
      },
      keepSuggestionsOnLoading: false,
      hideOnLoading: true,
      hideOnEmpty: false,
      noItemsFoundBuilder: (context) {
        // if (_autoCompleteController.text.isNotEmpty) {
        return ListTile(
          title: Text('No Member Found!'),
        );
        // } else {
        //   return null;
        // }
      },
      hideOnError: true,
      onSuggestionSelected: (Member suggestion) {
        passEvent(context, OrderInfoMemberAdded(member: suggestion));
      },
    );
  }

  Widget seeMultipleMembers({BuildContext context, List<Member> member}) {
    return Material(
      child: InkWell(
        onTap: () async {
          await selectedMembersDialog(context, member);
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            color: Colors.green,
          ),
          child: Row(
            children: [
              Text(
                member.length > 1 ? 'Multiple Members' : '...',
                style: GoogleFonts.ubuntuCondensed(
                  fontSize: 25,
                  color: Colors.green[50],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.touch_app_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void passEvent(BuildContext context, event) =>
      context.read<OrderInfoBloc>().add(event);
}

class CustomLabelledTextView extends StatelessWidget {
  final String labelName, text;

  CustomLabelledTextView({this.labelName, this.text});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.all(3.0),
        margin: EdgeInsets.all(5.0),
        height: Config.getDeviceHeight(context) * 0.1,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$labelName: ',
              style: GoogleFonts.ubuntuCondensed(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.ubuntu(
                      color: Colors.grey[800],
                      fontSize: 22,
                      letterSpacing: 1.5,
                      wordSpacing: 1.0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
