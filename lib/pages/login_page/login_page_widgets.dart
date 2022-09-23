part of 'login_page.dart';

class _TextFields extends StatelessWidget {
  final TextEditingController ipAddress;
  final TextEditingController username;
  final TextEditingController password;
  final void Function(BuildContext context) onTap;
  final void Function(BuildContext context) onSubmitted;
  const _TextFields({
    Key? key,
    required this.ipAddress,
    required this.username,
    required this.password,
    required this.onTap,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: [
            Flexible(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return TextField(
                    controller: ipAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.computer),
                      labelText: 'Ip Address',
                      errorText: Lib.validateIpAddress(ipAddress.text)
                          ? null
                          : 'Invalid address',
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.url,
                    onChanged: (value) => setState(() => null),
                  );
                },
              ),
            ),
            TextButton(
              child: Text('SUBMIT'),
              onPressed: () => context
                  .read<LoginBloc>()
                  .add(IpAddressChanged(ipaddress: ipAddress.text)),
            )
          ],
        ),
        Row(
          children: [
            StatefulBuilder(builder: (context, setState) {
              return Flexible(
                child: TextField(
                  controller: username,
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: 'Username',
                      errorText: (username.text).isEmpty ? 'Required' : null),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => setState(() => null),
                ),
              );
            }),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: StatefulBuilder(builder: (context, setState) {
                return TextField(
                  controller: password,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: 'Password',
                    errorText: (password.text).isEmpty ? 'Required' : null,
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  onSubmitted: (value) => onSubmitted(context),
                  onChanged: (value) => setState(() => null),
                );
              }),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => onTap(context),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
