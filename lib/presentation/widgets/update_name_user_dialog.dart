// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/controllers/account/account_page_controller.dart';
import 'package:talent_seek/presentation/widgets/update_name_button.dart';

import '../../domain/user/user.dart';
import '../../utils/enum.dart';

class UpdateNameUserDialog extends ConsumerStatefulWidget {
  final String userName;
  const UpdateNameUserDialog({
    super.key,
    required this.userName,
  });

  @override
  ConsumerState<UpdateNameUserDialog> createState() =>
      _UpdateNameUserDialogState();
}

class _UpdateNameUserDialogState extends ConsumerState<UpdateNameUserDialog> {
  var nameController = TextEditingController();
  User? _userUpdated;
  bool _isLoading = false;
  var _buttonVisible = false;

  @override
  void initState() {
    nameController.text = widget.userName;
    super.initState();
  }

  void _canUpdateName() {
    if (nameController.text.isNotEmpty) {
      _buttonVisible = true;
      setState(() {});
    } else {
      _buttonVisible = false;
      setState(() {});
    }
  }

  void _uploadUser() async {
    setState(() {
      _isLoading = true;
    });
    await ref
        .read(accountPageControllerProvider.notifier)
        .updateUser(newName: nameController.text.trim());
    _userUpdated = ref.read(userAuthProvider);
    setState(() {});

    Navigator.pop(context);
  }

  Widget _buildUpdateButton() {
    var result = UpdateNameUserButton(
      ref: ref,
      status: UpdateNameUserStatus.update,
      onPressed: () async {
        _uploadUser();
      },
    );

    if (_isLoading == true && _userUpdated == null) {
      return UpdateNameUserButton(
        ref: ref,
        status: UpdateNameUserStatus.loading,
        onPressed: () async {},
      );
    }
    if (_isLoading == true && _userUpdated != null) {
      return UpdateNameUserButton(
        ref: ref,
        status: UpdateNameUserStatus.success,
        onPressed: () async {},
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.5),
        body: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: width * 0.80,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10.0),
                  const Text(
                    'Actualiza tu nombre',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (value) {
                      _canUpdateName();
                    },
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del usuario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  _buttonVisible
                      ? _buildUpdateButton()
                      : const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
