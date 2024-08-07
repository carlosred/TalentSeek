import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/constants.dart';
import '../../utils/enum.dart';
import '../../utils/styles.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({
    super.key,
    required this.ref,
    required this.status,
    this.onPressed,
  });

  final WidgetRef ref;
  final LoginStatus status;
  final VoidCallback? onPressed;

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  List<Widget> _buildButton() {
    List<Widget> result = [];
    switch (widget.status) {
      case LoginStatus.success:
        result = const [
          Icon(
            Icons.done,
            color: Colors.white,
            size: 20,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            Constants.successfulLogin,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ];
        break;

      case LoginStatus.loading:
        result = const [
          SizedBox(
            height: 20,
            width: 20,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(
                  Colors.white,
                ),
                strokeWidth: 3,
              ),
            ),
          )
        ];
        break;

      case LoginStatus.login:
        result = const [
          FaIcon(
            FontAwesomeIcons.google,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            Constants.loginTxt,
            style: Styles.textStyleTittle2,
          )
        ];
        break;
      default:
        result = const [
          Text(Constants.loginTxt, style: Styles.textStyleTittle)
        ];
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: AspectRatio(
        aspectRatio: 27 / 3,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Styles.mainAppColor,
            ),
          ),
          onPressed: widget.onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildButton(),
          ),
        ),
      ),
    );
  }
}
