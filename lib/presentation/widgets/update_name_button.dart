import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/enum.dart';
import '../../utils/styles.dart';

class UpdateNameUserButton extends StatefulWidget {
  const UpdateNameUserButton({
    super.key,
    required this.ref,
    required this.status,
    this.onPressed,
  });

  final WidgetRef ref;
  final UpdateNameUserStatus status;
  final VoidCallback? onPressed;

  @override
  State<UpdateNameUserButton> createState() => _UpdateNameUserButtonState();
}

class _UpdateNameUserButtonState extends State<UpdateNameUserButton> {
  List<Widget> _buildButton() {
    List<Widget> result = [];
    switch (widget.status) {
      case UpdateNameUserStatus.success:
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
            'Nombre actualizado!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ];
        break;

      case UpdateNameUserStatus.loading:
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

      case UpdateNameUserStatus.update:
        result = const [
          FaIcon(
            FontAwesomeIcons.userAstronaut,
            size: 20.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            'Actualizar nombre',
            style: Styles.textStyleTittle2,
          )
        ];
        break;
      default:
        result = const [
          Text('Actualizar nombre', style: Styles.textStyleTittle)
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
              Styles.backgroundColor,
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
