import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';

class AddPackageDataPage extends StatefulWidget {
  const AddPackageDataPage({super.key});

  @override
  State<AddPackageDataPage> createState() => _AddPackageDataPageState();
}

class _AddPackageDataPageState extends State<AddPackageDataPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController serviceTypeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<PlatformFile> _selectedFiles = [];
  bool isLoading = false;

  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'webp'],
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      if (result.files.length > 4) {
        showFlushMessage("Please select up to 4 images only");
        return;
      }
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  Future<void> submitPackage() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getInt('user_id')?.toString() ?? '';

    if (userId.isEmpty) {
      showFlushMessage("User not logged in");
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var uri = Uri.parse('http://192.168.1.9:8000/api/PackageStore');
      var request = http.MultipartRequest('POST', uri);
      request.fields['user_id'] = userId;
      request.fields['name'] = nameController.text;
      request.fields['service_types'] = serviceTypeController.text;
      request.fields['description'] = descController.text;
      request.fields['price'] = priceController.text;

      for (int i = 0; i < _selectedFiles.length; i++) {
        final file = _selectedFiles[i];
        if (file.bytes != null) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'images[$i]',
              file.bytes!,
              filename: file.name,
            ),
          );
        } else if (file.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath('images[$i]', file.path!),
          );
        }
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        showFlushMessage("Package added successfully", success: true);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true); // for refresh
      } else {
        final error = json.decode(responseData);
        showFlushMessage("Failed: ${error['message']}");
      }
    } catch (e) {
      showFlushMessage("Error: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void showFlushMessage(String message, {bool success = false}) {
    Flushbar(
      message: message,
      backgroundColor: success ? Colors.green : Colors.red,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Add Package"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 500),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Add Package",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Package Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Package Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.inventory),
                  ),
                ),
                const SizedBox(height: 16),

                // Service Types
                TextField(
                  controller: serviceTypeController,
                  decoration: InputDecoration(
                    labelText: "Service Types",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextField(
                  controller: descController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                ),
                const SizedBox(height: 16),

                // Price
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Price",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.currency_rupee),
                  ),
                ),
                const SizedBox(height: 16),

                // Pick Images Button
                ElevatedButton.icon(
                  onPressed: pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text("Pick Images (Max 4)"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),

                // Image Preview
                if (_selectedFiles.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        _selectedFiles.map((file) {
                          return kIsWeb
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  file.bytes!,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                              : ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(file.path!),
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              );
                        }).toList(),
                  ),

                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitPackage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text("Submit"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditPackageDataPage extends StatefulWidget {
  final String packageId;
  final String packageName;
  final String serviceTypes;
  final String description;
  final String price;
  final List<String> existingImages;

  const EditPackageDataPage({
    super.key,
    required this.packageId,
    required this.packageName,
    required this.serviceTypes,
    required this.description,
    required this.price,
    required this.existingImages,
  });

  @override
  State<EditPackageDataPage> createState() => _EditPackageDataPageState();
}

class _EditPackageDataPageState extends State<EditPackageDataPage> {
  late TextEditingController nameController;
  late TextEditingController serviceTypeController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  List<PlatformFile> newImages = [];
  List<String> imageList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.packageName);
    serviceTypeController = TextEditingController(text: widget.serviceTypes);
    descriptionController = TextEditingController(text: widget.description);
    priceController = TextEditingController(text: widget.price);

    if (widget.existingImages.isNotEmpty) {
      imageList =
          widget.existingImages
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
    }
  }

  Future<void> pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      int total = imageList.length + newImages.length + result.files.length;
      if (total > 4) {
        showFlushMessage("Image Limit", "Max 4 images allowed", Colors.red);
        return;
      }

      setState(() {
        newImages.addAll(result.files);
      });
    }
  }

  Future<void> updatePackage() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      showFlushMessage("Error", "User ID not found", Colors.red);
      setState(() => isLoading = false);
      return;
    }

    var url = Uri.parse(
      'http://192.168.1.9:8000/api/PackageUpdate/${widget.packageId}',
    );
    var request = http.MultipartRequest('POST', url);

    request.fields['user_id'] = userId.toString();
    request.fields['name'] = nameController.text;
    request.fields['service_types'] = serviceTypeController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['price'] = priceController.text;

    try {
      for (int i = 0; i < newImages.length; i++) {
        final file = newImages[i];
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'images[$i]',
              file.bytes!,
              filename: file.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('images[$i]', file.path!),
          );
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final resData = json.decode(response.body);

      if (resData['status'] == true) {
        showFlushMessage("Success", resData['message'], Colors.green);
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.pop(context, true);
      } else {
        showFlushMessage("Failed", resData['message'], Colors.red);
      }
    } catch (e) {
      showFlushMessage("Error", "Update failed: $e", Colors.red);
    }

    setState(() => isLoading = false);
  }

  void showFlushMessage(String title, String message, Color color) {
    Flushbar(
      title: title,
      message: message,
      backgroundColor: color,
      margin: const EdgeInsets.all(12),
      borderRadius: BorderRadius.circular(8),
      duration: const Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [
      ...imageList.map(
        (e) => Image.network(
          "http://192.168.1.9:8000/package-image/$e",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        ),
      ),
      ...newImages.map((file) {
        if (kIsWeb) {
          return Image.memory(
            file.bytes!,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          );
        } else {
          return Image.file(
            File(file.path!),
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          );
        }
      }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Package'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 500),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Package Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: serviceTypeController,
                decoration: InputDecoration(
                  labelText: 'Service Types',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Images (max 4):",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(spacing: 8, runSpacing: 8, children: allImages),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Add Images"),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updatePackage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
