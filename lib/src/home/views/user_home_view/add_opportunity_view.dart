import 'dart:io';

import 'package:YELO/src/core/providers/location_provider.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:YELO/src/core/widgets/widgets.dart';
import 'package:YELO/src/home/providers/add_opportunity_provider.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class AddOpportunityView extends HookConsumerWidget {
  const AddOpportunityView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final image = useState<File?>(null);
    final location = useState<Position?>(null);

    return ScaffoldWrapper(
      appBar: AppBar(
        title: const Text('Add Opportunity'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              title: 'Title',
              controller: titleController,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              title: 'Description',
              controller: descriptionController,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            image.value == null
                ? const Text('No image selected.')
                : Image.file(image.value!),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  image.value = File(pickedFile.path);
                }
              },
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            location.value == null
                ? const Text('No location selected.')
                : Text(
                    'Lat: ${location.value!.latitude}, Lon: ${location.value!.longitude}'),
            ElevatedButton(
              onPressed: () async {
                location.value =
                    await ref.read(locationProvider.notifier).determinePosition();
              },
              child: const Text('Get Current Location'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty &&
                    image.value != null &&
                    location.value != null) {
                  ref.read(addOpportunityProvider).addOpportunity(
                        title: titleController.text,
                        description: descriptionController.text,
                        image: image.value!,
                        location: GeoPoint(
                          location.value!.latitude,
                          location.value!.longitude,
                        ),
                      );
                  context.router.pop();
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
