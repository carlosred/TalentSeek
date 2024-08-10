import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:talent_seek/data/providers/data_providers.dart';
import 'package:talent_seek/presentation/camera/camera_page.dart';

import 'package:talent_seek/utils/styles.dart';

import '../../domain/video/video.dart';
import '../providers/presentation_providers.dart';

class CreateVideoDialog extends ConsumerStatefulWidget {
  const CreateVideoDialog({super.key, required this.isChallenge});
  final bool isChallenge;
  @override
  ConsumerState<CreateVideoDialog> createState() => _CreateVideoDialogState();
}

class _CreateVideoDialogState extends ConsumerState<CreateVideoDialog> {
  var tittleController = TextEditingController();
  var objectiveController = TextEditingController();
  var roolSeekedController = TextEditingController();
  var descriptionController = TextEditingController();
  var _buttonVisible = false;
  void _canStartRecording() {
    if (tittleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        roolSeekedController.text.isNotEmpty &&
        objectiveController.text.isNotEmpty) {
      _buttonVisible = true;
      setState(() {});
    } else if (tittleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty) {
      _buttonVisible = true;
      setState(() {});
    }
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
                    'Crea tu Pitch',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    onChanged: (value) {
                      _canStartRecording();
                    },
                    controller: tittleController,
                    decoration: const InputDecoration(
                      labelText: 'Título',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  if (widget.isChallenge) ...[
                    TextFormField(
                      onChanged: (value) {
                        _canStartRecording();
                      },
                      controller: objectiveController,
                      decoration: const InputDecoration(
                        labelText: 'Objetivo',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      onChanged: (value) {
                        _canStartRecording();
                      },
                      controller: roolSeekedController,
                      decoration: const InputDecoration(
                        labelText: 'Rol a buscar',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                  TextFormField(
                    onChanged: (value) {
                      _canStartRecording();
                    },
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 30.0),
                  _buttonVisible
                      ? Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () async {
                              var userLogged = ref.read(userAuthProvider);
                              var idUserLogged = await ref
                                  .read(authRepositoryProvider)
                                  .getIdUserLogged(
                                      registeredEmail:
                                          userLogged!.registeredEmail!);

                              var newVideo = Video(
                                creatorUser: idUserLogged,
                                description: descriptionController.text.trim(),
                                label: tittleController.text.trim(),
                                objectChallenge:
                                    objectiveController.text.trim(),
                                roleSeeked: roolSeekedController.text.trim(),
                              );

                              ref.read(videoObjectProvider.notifier).state =
                                  newVideo;

                              // ignore: use_build_context_synchronously

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CameraPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.backgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 30.0),
                              child: Text(
                                'Iniciar a grabar',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
