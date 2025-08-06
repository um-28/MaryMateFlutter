// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class AddServiceDataPage extends StatefulWidget {
//   const AddServiceDataPage({super.key});

//   @override
//   State<AddServiceDataPage> createState() => _AddServiceDataPageState();
// }

// class _AddServiceDataPageState extends State<AddServiceDataPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final List<File> _images = [];
//   final ImagePicker _picker = ImagePicker();
//   bool isLoading = false;

//   Future<void> pickImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.length <= 4) {
//       setState(() {
//         _images.clear();
//         _images.addAll(pickedFiles.map((file) => File(file.path)));
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select up to 4 images only")),
//       );
//     }
//   }

//   Future<void> submitService() async {
//     setState(() {
//       isLoading = true;
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('user_id');

//     if (userId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//       return;
//     }

//     var uri = Uri.parse('http://yourdomain.com/api/ServiceStore');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['user_id'] = userId;
//     request.fields['service_name'] = nameController.text;
//     request.fields['description'] = descController.text;
//     request.fields['price'] = priceController.text;

//     for (int i = 0; i < _images.length; i++) {
//       request.files.add(
//         await http.MultipartFile.fromPath('images[$i]', _images[i].path),
//       );
//     }

//     var response = await request.send();

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Service added successfully")),
//       );
//       Navigator.pop(context);
//     } else {
//       final responseData = await response.stream.bytesToString();
//       final error = json.decode(responseData);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed: ${error['message']}")));
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Add Service")),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(
//                 labelText: "Service Name",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: descController,
//               maxLines: 4,
//               decoration: const InputDecoration(
//                 labelText: "Description",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: priceController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(
//                 labelText: "Price",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             ElevatedButton(
//               onPressed: pickImages,
//               child: const Text("Pick Images (Max 4)"),
//             ),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               children:
//                   _images.map((image) {
//                     return Image.file(
//                       image,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     );
//                   }).toList(),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: isLoading ? null : submitService,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 14,
//                 ),
//               ),
//               child:
//                   isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Submit Service"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class AddServiceDataPage extends StatefulWidget {
//   const AddServiceDataPage({super.key});

//   @override
//   State<AddServiceDataPage> createState() => _AddServiceDataPageState();
// }

// class _AddServiceDataPageState extends State<AddServiceDataPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final List<XFile> _images = [];
//   final List<String> _imageNames = [];
//   final ImagePicker _picker = ImagePicker();
//   bool isLoading = false;

//   Future<void> pickImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       if (pickedFiles.length <= 4) {
//         setState(() {
//           _images.clear();
//           _images.addAll(pickedFiles);
//           _imageNames.clear();
//           _imageNames.addAll(pickedFiles.map((file) => file.name));
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select up to 4 images only")),
//         );
//       }
//     }
//   }

//   Future<void> submitService() async {
//     setState(() {
//       isLoading = true;
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userId = prefs.getString('user_id');

//     if (userId == null) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//       return;
//     }

//     var uri = Uri.parse('http://yourdomain.com/api/ServiceStore');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['user_id'] = userId;
//     request.fields['service_name'] = nameController.text;
//     request.fields['description'] = descController.text;
//     request.fields['price'] = priceController.text;

//     for (int i = 0; i < _images.length; i++) {
//       request.files.add(
//         await http.MultipartFile.fromPath('images[$i]', _images[i].path),
//       );
//     }

//     var response = await request.send();

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Service added successfully")),
//       );
//       Navigator.pop(context);
//     } else {
//       final responseData = await response.stream.bytesToString();
//       final error = json.decode(responseData);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed: \${error['message']}")));
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       appBar: AppBar(
//         title: const Text("Add Service"),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             constraints: const BoxConstraints(maxWidth: 500),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Text(
//                     "Add Your Service",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText: "Service Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.design_services),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 TextField(
//                   controller: descController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     labelText: "Description",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.description),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 TextField(
//                   controller: priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Price",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.attach_money),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 ElevatedButton.icon(
//                   onPressed: pickImages,
//                   icon: const Icon(Icons.image),
//                   label: const Text("Pick Images (Max 4)"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 if (_images.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children:
//                             _images.map((image) {
//                               return FutureBuilder<Uint8List>(
//                                 future: image.readAsBytes(),
//                                 builder: (context, snapshot) {
//                                   if (snapshot.connectionState ==
//                                           ConnectionState.done &&
//                                       snapshot.hasData) {
//                                     return ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.memory(
//                                         snapshot.data!,
//                                         width: 80,
//                                         height: 80,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     );
//                                   } else {
//                                     return const SizedBox(
//                                       width: 80,
//                                       height: 80,
//                                       child: Center(
//                                         child: CircularProgressIndicator(),
//                                       ),
//                                     );
//                                   }
//                                 },
//                               );
//                             }).toList(),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Selected: \${_imageNames.join(', ')}",
//                         style: const TextStyle(
//                           fontStyle: FontStyle.italic,
//                           color: Colors.black54,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ],
//                   ),

//                 const SizedBox(height: 30),

//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : submitService,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       textStyle: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child:
//                         isLoading
//                             ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                             : const Text("Submit Service"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class AddServiceDataPage extends StatefulWidget {
//   const AddServiceDataPage({super.key});

//   @override
//   State<AddServiceDataPage> createState() => _AddServiceDataPageState();
// }

// class _AddServiceDataPageState extends State<AddServiceDataPage> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   final List<XFile> _images = [];
//   final ImagePicker _picker = ImagePicker();
//   bool isLoading = false;

//   Future<void> pickImages() async {
//     try {
//       final pickedFiles = await _picker.pickMultiImage();

//       if (pickedFiles.length <= 4) {
//         setState(() {
//           _images.clear();
//           _images.addAll(pickedFiles);
//         });
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please select up to 4 images only")),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error picking images: $e")));
//     }
//   }

//   Future<void> submitService() async {
//     setState(() {
//       isLoading = true;
//     });

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String userId = prefs.getInt('user_id')?.toString() ?? '';

//     if (userId.isEmpty) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(const SnackBar(content: Text("User not logged in")));
//       setState(() {
//         isLoading = false;
//       });
//       return;
//     }

//     var uri = Uri.parse('http://192.168.1.3:8000/api/ServiceStore');
//     var request = http.MultipartRequest('POST', uri);
//     request.fields['user_id'] = userId;
//     request.fields['service_name'] = nameController.text;
//     request.fields['description'] = descController.text;
//     request.fields['price'] = priceController.text;

//     for (int i = 0; i < _images.length; i++) {
//       final image = _images[i];

//       if (kIsWeb) {
//         final bytes = await image.readAsBytes();
//         request.files.add(
//           http.MultipartFile.fromBytes(
//             'images[$i]',
//             bytes,
//             filename: image.name,
//           ),
//         );
//       } else {
//         request.files.add(
//           await http.MultipartFile.fromPath('images[$i]', image.path),
//         );
//       }
//     }

//     var response = await request.send();

//     if (response.statusCode == 201) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Service added successfully")),
//       );
//       Navigator.pop(context);
//     } else {
//       final responseData = await response.stream.bytesToString();
//       final error = json.decode(responseData);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Failed: ${error['message']}")));
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       appBar: AppBar(
//         title: const Text("Add Service"),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Center(
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             constraints: const BoxConstraints(maxWidth: 500),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Center(
//                   child: Text(
//                     "Add Your Service",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Service Name
//                 TextField(
//                   controller: nameController,
//                   decoration: InputDecoration(
//                     labelText: "Service Name",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.design_services),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Description
//                 TextField(
//                   controller: descController,
//                   maxLines: 4,
//                   decoration: InputDecoration(
//                     labelText: "Description",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.description),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Price
//                 TextField(
//                   controller: priceController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Price",
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.attach_money),
//                   ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Pick Images
//                 ElevatedButton.icon(
//                   onPressed: pickImages,
//                   icon: const Icon(Icons.image),
//                   label: const Text("Pick Images (Max 4)"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     foregroundColor: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 12),

//                 // Show selected images
//                 if (_images.isNotEmpty)
//                   Wrap(
//                     spacing: 8,
//                     runSpacing: 8,
//                     children:
//                         _images.map((image) {
//                           return kIsWeb
//                               ? ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.network(
//                                   image.path,
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                               )
//                               : ClipRRect(
//                                 borderRadius: BorderRadius.circular(8),
//                                 child: Image.file(
//                                   File(image.path),
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                               );
//                         }).toList(),
//                   ),

//                 const SizedBox(height: 30),

//                 // Submit Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: isLoading ? null : submitService,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.deepPurple,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       textStyle: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child:
//                         isLoading
//                             ? const CircularProgressIndicator(
//                               color: Colors.white,
//                             )
//                             : const Text("Submit Service"),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import 'package:another_flushbar/flushbar.dart';

class AddServiceDataPage extends StatefulWidget {
  const AddServiceDataPage({super.key});

  @override
  State<AddServiceDataPage> createState() => _AddServiceDataPageState();
}

class _AddServiceDataPageState extends State<AddServiceDataPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<PlatformFile> _selectedFiles = [];
  bool isLoading = false;

  // ✅ Pick Multiple Images
  Future<void> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg', 'gif', 'webp'],
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      if (result.files.length > 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select up to 4 images only")),
        );
        return;
      }

      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  // ✅ Submit service to Laravel API
  Future<void> submitService() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getInt('user_id')?.toString() ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      setState(() {
        isLoading = false;
      });
      return;
    }

    var uri = Uri.parse('http://192.168.1.3:8000/api/ServiceStore');
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = userId;
    request.fields['service_name'] = nameController.text;
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

    var response = await request.send();

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service added successfully")),
      );
      Navigator.pop(context);
    } else {
      final responseData = await response.stream.bytesToString();
      final error = json.decode(responseData);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: ${error['message']}")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Add Service"),
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
                    "Add Your Service",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Service Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Service Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.design_services),
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
                    prefixIcon: const Icon(Icons.attach_money),
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

                const SizedBox(height: 6),
                // const Text(
                //   "💡 Tip: Hold Ctrl (Cmd on Mac) to select multiple images",
                //   style: TextStyle(fontSize: 12, color: Colors.black54),
                // ),
                const SizedBox(height: 12),

                // Preview selected images
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
                    onPressed: isLoading ? null : submitService,
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
                            : const Text("Submit Service"),
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

// class EditServiceDataPage extends StatefulWidget {
//   final String serviceId;
//   final String serviceName;
//   final String description;
//   final String price;
//   final List<String>
//   existingImages; // Comma-separated list as ["img1.jpg,img2.jpg"]

//   const EditServiceDataPage({
//     super.key,
//     required this.serviceId,
//     required this.serviceName,
//     required this.description,
//     required this.price,
//     required this.existingImages,
//   });

//   @override
//   State<EditServiceDataPage> createState() => _EditServiceDataPageState();
// }

// class _EditServiceDataPageState extends State<EditServiceDataPage> {
//   late TextEditingController nameController;
//   late TextEditingController descriptionController;
//   late TextEditingController priceController;

//   List<File> newImages = [];
//   List<String> imageList = [];
//   final ImagePicker picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.serviceName);
//     descriptionController = TextEditingController(text: widget.description);
//     priceController = TextEditingController(text: widget.price);

//     // ✅ Convert comma-separated image string(s) into clean list
//     if (widget.existingImages.isNotEmpty) {
//       imageList =
//           widget.existingImages
//               .expand((e) => e.split(','))
//               .map((e) => e.trim())
//               .where((e) => e.isNotEmpty)
//               .toList();
//     }
//   }

//   Future<void> pickImages() async {
//     final picked = await picker.pickMultiImage(imageQuality: 70);
//     if (picked.isNotEmpty && newImages.length + picked.length <= 4) {
//       setState(() {
//         newImages.addAll(picked.map((e) => File(e.path)));
//       });
//     } else {
//       Flushbar(
//         title: "Max 4 Images Allowed",
//         message: "You can upload a total of 4 images only.",
//         backgroundColor: Colors.orange,
//         duration: const Duration(seconds: 3),
//       ).show(context);
//     }
//   }

//   Future<void> updateService() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     int? userId = prefs.getInt('user_id');
//     if (userId == null) return;

//     var url = Uri.parse(
//       'http://192.168.1.3:8000/api/ServiceUpdate/${widget.serviceId}',
//     );
//     var request = http.MultipartRequest('POST', url);
//     request.fields['user_id'] = userId.toString();
//     request.fields['service_name'] = nameController.text;
//     request.fields['description'] = descriptionController.text;
//     request.fields['price'] = priceController.text;

//     for (int i = 0; i < newImages.length; i++) {
//       request.files.add(
//         await http.MultipartFile.fromPath('images[$i]', newImages[i].path),
//       );
//     }

//     var streamedResponse = await request.send();
//     var response = await http.Response.fromStream(streamedResponse);
//     final resData = json.decode(response.body);

//     if (resData['status'] == true) {
//       Navigator.pop(context, true);
//     } else {
//       Flushbar(
//         title: "Update Failed",
//         message: resData['message'] ?? "Something went wrong.",
//         duration: const Duration(seconds: 3),
//         backgroundColor: Colors.red,
//         flushbarPosition: FlushbarPosition.TOP,
//         icon: const Icon(Icons.error, color: Colors.white),
//         margin: const EdgeInsets.all(8),
//         borderRadius: BorderRadius.circular(8),
//       ).show(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final allImages = [
//       ...imageList.map(
//         (e) => Image.network(
//           "http://192.168.1.3:8000/service-image/$e",
//           width: 70,
//           height: 70,
//           fit: BoxFit.cover,
//           errorBuilder:
//               (context, error, stackTrace) => const Icon(Icons.broken_image),
//         ),
//       ),
//       ...newImages.map(
//         (e) => Image.file(e, width: 70, height: 70, fit: BoxFit.cover),
//       ),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Your Service'),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           constraints: const BoxConstraints(maxWidth: 500),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 10,
//                 spreadRadius: 2,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   labelText: 'Service Name',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                   labelText: 'Description',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 maxLines: 3,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: priceController,
//                 decoration: InputDecoration(
//                   labelText: 'Price',
//                   prefixIcon: const Icon(Icons.currency_rupee),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 "Images (max 4):",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Wrap(spacing: 8, runSpacing: 8, children: allImages),
//               const SizedBox(height: 10),
//               OutlinedButton.icon(
//                 onPressed: pickImages,
//                 icon: const Icon(Icons.add_photo_alternate),
//                 label: const Text("Add Images"),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: updateService,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.deepPurple,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text('Save'),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class EditServiceDataPage extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  final String description;
  final String price;
  final List<String> existingImages;

  const EditServiceDataPage({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.description,
    required this.price,
    required this.existingImages,
  });

  @override
  State<EditServiceDataPage> createState() => _EditServiceDataPageState();
}

class _EditServiceDataPageState extends State<EditServiceDataPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;

  List<File> newImages = [];
  List<String> imageList = [];
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.serviceName);
    descriptionController = TextEditingController(text: widget.description);
    priceController = TextEditingController(text: widget.price);

    if (widget.existingImages.isNotEmpty) {
      imageList =
          widget.existingImages
              .expand((e) => e.split(','))
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
    }
  }

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage(imageQuality: 70);

    if (pickedFiles.isNotEmpty) {
      int totalCount = imageList.length + newImages.length + pickedFiles.length;

      if (totalCount > 4) {
        Flushbar(
          title: "Image Limit Exceeded",
          message: "Maximum 4 images are allowed (including existing ones).",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ).show(context);
        return;
      }

      setState(() {
        newImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> updateService() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');
    if (userId == null) return;

    var url = Uri.parse(
      'http://192.168.1.3:8000/api/ServiceUpdate/${widget.serviceId}',
    );
    var request = http.MultipartRequest('POST', url);

    request.fields['user_id'] = userId.toString();
    request.fields['service_name'] = nameController.text;
    request.fields['description'] = descriptionController.text;
    request.fields['price'] = priceController.text;

    try {
      for (int i = 0; i < newImages.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('images[$i]', newImages[i].path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      final resData = json.decode(response.body);

      if (resData['status'] == true) {
        Navigator.pop(context, true);
      } else {
        Flushbar(
          title: "Update Failed",
          message: resData['message'] ?? "Something went wrong.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    } catch (e) {
      Flushbar(
        title: "Error",
        message: "Failed to update service: $e",
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [
      ...imageList.map(
        (e) => Image.network(
          "http://192.168.1.3:8000/service-image/$e",
          width: 70,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => const Icon(Icons.broken_image),
        ),
      ),
      ...newImages.map(
        (e) => Image.file(e, width: 70, height: 70, fit: BoxFit.cover),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Your Service'),
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
                  labelText: 'Service Name',
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
                  onPressed: updateService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
