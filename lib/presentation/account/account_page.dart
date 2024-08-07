import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:talent_seek/utils/styles.dart';

import '../widgets/circular_account_avatar.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  String getInitials({required String name}) {
    List<String> nameParts = name.split(' ');
    String initials = '';

    for (var part in nameParts) {
      if (part.isNotEmpty) {
        initials += part[0].toUpperCase();
      }
    }

    return initials;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.sizeOf(context).width;
    var height = MediaQuery.sizeOf(context).height;
    var userLogged = ref.watch(userAuthProvider);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          alignment: Alignment.center,
          decoration: Styles.backgroundGradient,
          child: Image.asset(
            'assets/images/icon.png',
            width: 40.0,
            height: 40.0,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: SizedBox.expand(
        child: ListView(
          padding: const EdgeInsets.all(15.0),
          children: [
            SizedBox(
              width: width,
              height: height * 0.18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: CircularAccountAvatar(
                      initials:
                          getInitials(name: userLogged?.name ?? 'Unknow User'),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: AutoSizeText(
                        userLogged?.name ?? 'Unknow User',
                        maxLines: 2,
                        softWrap: true,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.edit,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
