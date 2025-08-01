// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// class BusinessRegisterPage extends StatefulWidget {
//   const BusinessRegisterPage({super.key});

//   @override
//   State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
// }

// class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();

//   String? selectedBusinessType;
//   PlatformFile? aadhaarCard;
//   PlatformFile? panCard;
//   PlatformFile? otherDoc;
//   List<PlatformFile>? businessImages = [];

//   Future<void> _pickFile(Function(PlatformFile) setFile) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//     );

//     if (result != null && result.files.isNotEmpty) {
//       setState(() => setFile(result.files.first));
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//     );

//     if (result != null) {
//       setState(() => businessImages = result.files);
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // You can handle form submission here
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Business Registration Submitted")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Business Registration"),
//         backgroundColor: Colors.black,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: "Business Type"),
//                 value: selectedBusinessType,
//                 items:
//                     ['Venue', 'Catering', 'Decorator', 'Photography']
//                         .map(
//                           (type) =>
//                               DropdownMenuItem(value: type, child: Text(type)),
//                         )
//                         .toList(),
//                 onChanged:
//                     (value) => setState(() => selectedBusinessType = value),
//                 validator:
//                     (value) =>
//                         value == null ? 'Please select business type' : null,
//               ),

//               const SizedBox(height: 12),
//               _buildTextField(_nameController, "Name"),
//               _buildTextField(_emailController, "Email"),
//               _buildTextField(
//                 _contactController,
//                 "Contact",
//                 keyboardType: TextInputType.phone,
//               ),
//               _buildTextField(_businessNameController, "Business Name"),
//               _buildTextField(
//                 _descriptionController,
//                 "Description",
//                 maxLines: 3,
//               ),
//               _buildTextField(_addressController, "Address", maxLines: 2),
//               _buildTextField(_stateController, "State"),
//               _buildTextField(_cityController, "City"),
//               _buildTextField(
//                 _pincodeController,
//                 "Pincode",
//                 keyboardType: TextInputType.number,
//               ),

//               const SizedBox(height: 16),
//               _buildFilePicker(
//                 "Upload Aadhaar Card",
//                 aadhaarCard,
//                 (file) => aadhaarCard = file,
//               ),
//               _buildFilePicker(
//                 "Upload PAN Card",
//                 panCard,
//                 (file) => panCard = file,
//               ),
//               _buildFilePicker(
//                 "Upload Other Document",
//                 otherDoc,
//                 (file) => otherDoc = file,
//               ),

//               const SizedBox(height: 16),
//               const Text("Upload Business Images"),
//               ElevatedButton(
//                 onPressed: _pickMultipleImages,
//                 child: const Text("Pick Images"),
//               ),

//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 children:
//                     businessImages?.map((file) {
//                       return Image.file(
//                         File(file.path!),
//                         width: 80,
//                         height: 80,
//                         fit: BoxFit.cover,
//                       );
//                     }).toList() ??
//                     [],
//               ),

//               const SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 40,
//                       vertical: 14,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: const Text(
//                     "Register Business",
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String labelText, {
//     int maxLines = 1,
//     TextInputType keyboardType = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: keyboardType,
//         decoration: InputDecoration(labelText: labelText),
//         validator: (value) => value!.isEmpty ? 'Enter $labelText' : null,
//       ),
//     );
//   }

//   Widget _buildFilePicker(
//     String label,
//     PlatformFile? file,
//     Function(PlatformFile) onPick,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label),
//         ElevatedButton(
//           onPressed: () => _pickFile(onPick),
//           child: Text(file == null ? "Select File" : file.name),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// class BusinessRegisterPage extends StatefulWidget {
//   const BusinessRegisterPage({super.key});

//   @override
//   State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
// }

// class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();

//   String? selectedBusinessType;
//   PlatformFile? aadhaarCard;
//   PlatformFile? panCard;
//   PlatformFile? otherDoc;
//   List<PlatformFile> businessImages = [];
//   bool _isSubmitting = false;

//   Future<void> _pickFile(Function(PlatformFile) setFile) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//     );
//     if (result != null && result.files.isNotEmpty) {
//       setState(() => setFile(result.files.first));
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//       withData: true,
//     );
//     if (result != null) {
//       setState(() => businessImages = result.files);
//     }
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isSubmitting = true);
//       Future.delayed(const Duration(seconds: 1), () {
//         setState(() => _isSubmitting = false);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Business Registration Submitted")),
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Column(
//                   children: [
//                     Image.asset('assets/images/marrymate.png', height: 100),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Register Your Business',
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple[700],
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Join MarryMate and grow your wedding services',
//                       style: TextStyle(color: Colors.grey[700], fontSize: 15),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),

//                 // Business Type Dropdown
//                 DropdownButtonFormField<String>(
//                   decoration: _inputDecoration(
//                     "Business Type",
//                     icon: Icons.category,
//                   ).copyWith(filled: true, fillColor: Colors.white),
//                   dropdownColor: Colors.white,
//                   value: selectedBusinessType,
//                   iconEnabledColor: Colors.black,
//                   style: const TextStyle(color: Colors.black, fontSize: 16),
//                   items:
//                       [
//                         'Wedding Hall',
//                         'Catering',
//                         'Decorator',
//                         'DJ & Sound System',
//                         'Saloon',
//                         'Pandit',
//                         'Transpottation',
//                       ].map((type) {
//                         return DropdownMenuItem(
//                           value: type,
//                           child: Text(
//                             type,
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged:
//                       (value) => setState(() => selectedBusinessType = value),
//                   validator:
//                       (value) =>
//                           value == null ? 'Please select business type' : null,
//                 ),
//                 const SizedBox(height: 20),

//                 // Text Fields
//                 _buildTextField(_nameController, 'Full Name', Icons.person),
//                 _buildTextField(
//                   _emailController,
//                   'Email',
//                   Icons.email,
//                   type: TextInputType.emailAddress,
//                 ),
//                 _buildTextField(
//                   _contactController,
//                   'Contact',
//                   Icons.phone,
//                   type: TextInputType.phone,
//                 ),
//                 _buildTextField(
//                   _businessNameController,
//                   'Business Name',
//                   Icons.business,
//                 ),
//                 _buildTextField(
//                   _descriptionController,
//                   'Description',
//                   Icons.description,
//                   maxLines: 3,
//                 ),
//                 _buildTextField(
//                   _addressController,
//                   'Address',
//                   Icons.location_on,
//                 ),
//                 _buildTextField(_stateController, 'State', Icons.map),
//                 _buildTextField(_cityController, 'City', Icons.location_city),
//                 _buildTextField(
//                   _pincodeController,
//                   'Pincode',
//                   Icons.pin,
//                   type: TextInputType.number,
//                 ),

//                 // File Pickers
//                 _buildFilePicker(
//                   'Upload Aadhaar Card',
//                   aadhaarCard,
//                   (file) => aadhaarCard = file,
//                 ),
//                 _buildFilePicker(
//                   'Upload PAN Card',
//                   panCard,
//                   (file) => panCard = file,
//                 ),
//                 _buildFilePicker(
//                   'Other Documents',
//                   otherDoc,
//                   (file) => otherDoc = file,
//                 ),

//                 // Business Images Picker (same style as above)
//                 _buildMultipleFilePicker(
//                   'Upload Business Images',
//                   businessImages,
//                   _pickMultipleImages,
//                 ),

//                 // Optional image previews
//                 if (businessImages.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children:
//                           businessImages.map((file) {
//                             return ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.memory(
//                                 file.bytes!,
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                             );
//                           }).toList(),
//                     ),
//                   ),

//                 const SizedBox(height: 35),

//                 // Submit Button
//                 InkWell(
//                   borderRadius: BorderRadius.circular(50),
//                   onTap: _submitForm,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.deepPurple.withOpacity(0.4),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child:
//                           _isSubmitting
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : const Text(
//                                 'Register Business',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                   letterSpacing: 1.1,
//                                 ),
//                               ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   InputDecoration _inputDecoration(String label, {IconData? icon}) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     IconData icon, {
//     int maxLines = 1,
//     TextInputType type = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: type,
//         decoration: _inputDecoration(label, icon: icon),
//         validator:
//             (val) =>
//                 val == null || val.trim().isEmpty
//                     ? 'Please enter $label'
//                     : null,
//       ),
//     );
//   }

//   Widget _buildFilePicker(
//     String label,
//     PlatformFile? file,
//     Function(PlatformFile) onPick,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade400),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.08),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 file == null ? label : file.name,
//                 style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//               onPressed: () => _pickFile(onPick),
//               icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMultipleFilePicker(
//     String label,
//     List<PlatformFile> files,
//     VoidCallback onPick,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade400),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.08),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 files.isEmpty ? label : '${files.length} image(s) selected',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//               onPressed: onPick,
//               icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';

// class BusinessRegisterPage extends StatefulWidget {
//   const BusinessRegisterPage({super.key});

//   @override
//   State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
// }

// class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();

//   String? selectedBusinessType;
//   PlatformFile? aadhaarCard;
//   PlatformFile? panCard;
//   PlatformFile? otherDoc;
//   List<PlatformFile> businessImages = [];
//   bool _isSubmitting = false;

//   Future<void> _pickFile(Function(PlatformFile) setFile) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//     );
//     if (result != null && result.files.isNotEmpty) {
//       setState(() => setFile(result.files.first));
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//       withData: true,
//     );
//     if (result != null) {
//       setState(() => businessImages = result.files);
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (aadhaarCard == null || panCard == null || otherDoc == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload all required documents')),
//       );
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     var uri = Uri.parse("http://192.168.1.6:8000/api/VendorRegister");

//     var request = http.MultipartRequest('POST', uri);

//     request.fields['name'] = _nameController.text;
//     request.fields['email'] = _emailController.text;
//     request.fields['contact'] = _contactController.text;
//     request.fields['business_type'] = selectedBusinessType!;
//     request.fields['business_name'] = _businessNameController.text;
//     request.fields['description'] = _descriptionController.text;
//     request.fields['address'] = _addressController.text;
//     request.fields['state'] = _stateController.text;
//     request.fields['city'] = _cityController.text;
//     request.fields['pincode'] = _pincodeController.text;

//     Future<void> addFileField(String name, PlatformFile file) async {
//       if (kIsWeb) {
//         request.files.add(
//           http.MultipartFile.fromBytes(name, file.bytes!, filename: file.name),
//         );
//       } else {
//         request.files.add(await http.MultipartFile.fromPath(name, file.path!));
//       }
//     }

//     await addFileField('AadharCard', aadhaarCard!);
//     await addFileField('PanCard', panCard!);
//     await addFileField('othdoc', otherDoc!);

//     if (businessImages.isNotEmpty) {
//       for (int i = 0; i < businessImages.length; i++) {
//         final image = businessImages[i];
//         final _ = 'image[$i]';
//         if (kIsWeb) {
//           request.files.add(
//             http.MultipartFile.fromBytes(
//               'image',
//               image.bytes!,
//               filename: image.name,
//             ),
//           );
//         } else {
//           request.files.add(
//             await http.MultipartFile.fromPath('image', image.path!),
//           );
//         }
//       }
//     }

//     try {
//       final response = await request.send();

//       final respStr = await response.stream.bytesToString();
//       final data = json.decode(respStr);

//       setState(() => _isSubmitting = false);

//       if (response.statusCode == 201) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Registration Successful ✅")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error: ${data['errors'] ?? 'Something went wrong'}"),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isSubmitting = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   InputDecoration _inputDecoration(String label, {IconData? icon}) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     IconData icon, {
//     int maxLines = 1,
//     TextInputType type = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: type,
//         decoration: _inputDecoration(label, icon: icon),
//         validator:
//             (val) =>
//                 val == null || val.trim().isEmpty
//                     ? 'Please enter $label'
//                     : null,
//       ),
//     );
//   }

//   Widget _buildFilePicker(
//     String label,
//     PlatformFile? file,
//     Function(PlatformFile) onPick,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade400),
//           boxShadow: [
//             BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 file == null ? label : file.name,
//                 style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//               onPressed: () => _pickFile(onPick),
//               icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMultipleFilePicker(
//     String label,
//     List<PlatformFile> files,
//     VoidCallback onPick,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade400),
//           boxShadow: [
//             BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 files.isEmpty ? label : '${files.length} image(s) selected',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//               onPressed: onPick,
//               icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Column(
//                   children: [
//                     Image.asset('assets/images/marrymate.png', height: 100),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Register Your Business',
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple[700],
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Join MarryMate and grow your wedding services',
//                       style: TextStyle(color: Colors.grey[700], fontSize: 15),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 DropdownButtonFormField<String>(
//                   decoration: _inputDecoration(
//                     "Business Type",
//                     icon: Icons.category,
//                   ).copyWith(filled: true, fillColor: Colors.white),
//                   dropdownColor: Colors.white,
//                   value: selectedBusinessType,
//                   iconEnabledColor: Colors.black,
//                   style: const TextStyle(color: Colors.black, fontSize: 16),
//                   items:
//                       [
//                         'Wedding Hall',
//                         'Catering',
//                         'Decorator',
//                         'DJ & Sound System',
//                         'Saloon',
//                         'Pandit',
//                         'Transpottation',
//                       ].map((type) {
//                         return DropdownMenuItem(
//                           value: type,
//                           child: Text(
//                             type,
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged:
//                       (value) => setState(() => selectedBusinessType = value),
//                   validator:
//                       (value) =>
//                           value == null ? 'Please select business type' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 _buildTextField(_nameController, 'Full Name', Icons.person),
//                 _buildTextField(
//                   _emailController,
//                   'Email',
//                   Icons.email,
//                   type: TextInputType.emailAddress,
//                 ),
//                 _buildTextField(
//                   _contactController,
//                   'Contact',
//                   Icons.phone,
//                   type: TextInputType.phone,
//                 ),
//                 _buildTextField(
//                   _businessNameController,
//                   'Business Name',
//                   Icons.business,
//                 ),
//                 _buildTextField(
//                   _descriptionController,
//                   'Description',
//                   Icons.description,
//                   maxLines: 3,
//                 ),
//                 _buildTextField(
//                   _addressController,
//                   'Address',
//                   Icons.location_on,
//                 ),
//                 _buildTextField(_stateController, 'State', Icons.map),
//                 _buildTextField(_cityController, 'City', Icons.location_city),
//                 _buildTextField(
//                   _pincodeController,
//                   'Pincode',
//                   Icons.pin,
//                   type: TextInputType.number,
//                 ),
//                 _buildFilePicker(
//                   'Upload Aadhaar Card',
//                   aadhaarCard,
//                   (file) => aadhaarCard = file,
//                 ),
//                 _buildFilePicker(
//                   'Upload PAN Card',
//                   panCard,
//                   (file) => panCard = file,
//                 ),
//                 _buildFilePicker(
//                   'Other Documents',
//                   otherDoc,
//                   (file) => otherDoc = file,
//                 ),
//                 _buildMultipleFilePicker(
//                   'Upload Business Images',
//                   businessImages,
//                   _pickMultipleImages,
//                 ),
//                 if (businessImages.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children:
//                           businessImages
//                               .map(
//                                 (file) => ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.memory(
//                                     file.bytes!,
//                                     width: 80,
//                                     height: 80,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                     ),
//                   ),
//                 const SizedBox(height: 35),
//                 InkWell(
//                   borderRadius: BorderRadius.circular(50),
//                   onTap: _submitForm,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.deepPurple.withOpacity(0.4),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child:
//                           _isSubmitting
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : const Text(
//                                 'Submit',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                   letterSpacing: 1.1,
//                                 ),
//                               ),
//                     ),
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
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:file_picker/file_picker.dart';
// import 'package:another_flushbar/flushbar.dart';

// class BusinessRegisterPage extends StatefulWidget {
//   const BusinessRegisterPage({super.key});

//   @override
//   State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
// }

// class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
//   final _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _contactController = TextEditingController();
//   final TextEditingController _businessNameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _pincodeController = TextEditingController();

//   String? selectedBusinessType;
//   PlatformFile? aadhaarCard;
//   PlatformFile? panCard;
//   PlatformFile? otherDoc;
//   List<PlatformFile> businessImages = [];
//   bool _isSubmitting = false;

//   Future<void> _pickFile(Function(PlatformFile) setFile) async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
//     );
//     if (result != null && result.files.isNotEmpty) {
//       setState(() => setFile(result.files.first));
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//       allowMultiple: true,
//       withData: true,
//     );
//     if (result != null) {
//       setState(() => businessImages = result.files);
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (aadhaarCard == null || panCard == null || otherDoc == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload all required documents')),
//       );
//       return;
//     }

//     setState(() => _isSubmitting = true);

//     var uri = Uri.parse("http://192.168.1.6:8000/api/VendorRegister");
//     var request = http.MultipartRequest('POST', uri);

//     request.fields['name'] = _nameController.text;
//     request.fields['email'] = _emailController.text;
//     request.fields['contact'] = _contactController.text;
//     request.fields['business_type'] = selectedBusinessType!;
//     request.fields['business_name'] = _businessNameController.text;
//     request.fields['description'] = _descriptionController.text;
//     request.fields['address'] = _addressController.text;
//     request.fields['state'] = _stateController.text;
//     request.fields['city'] = _cityController.text;
//     request.fields['pincode'] = _pincodeController.text;

//     Future<void> addFileField(String name, PlatformFile file) async {
//       if (kIsWeb) {
//         request.files.add(
//           http.MultipartFile.fromBytes(name, file.bytes!, filename: file.name),
//         );
//       } else {
//         request.files.add(await http.MultipartFile.fromPath(name, file.path!));
//       }
//     }

//     await addFileField('AadharCard', aadhaarCard!);
//     await addFileField('PanCard', panCard!);
//     await addFileField('othdoc', otherDoc!);

//     if (businessImages.isNotEmpty) {
//       for (int i = 0; i < businessImages.length; i++) {
//         final image = businessImages[i];
//         if (kIsWeb) {
//           request.files.add(
//             http.MultipartFile.fromBytes(
//               'image',
//               image.bytes!,
//               filename: image.name,
//             ),
//           );
//         } else {
//           request.files.add(
//             await http.MultipartFile.fromPath('image', image.path!),
//           );
//         }
//       }
//     }

//     try {
//       final response = await request.send();
//       final respStr = await response.stream.bytesToString();
//       final data = json.decode(respStr);

//       setState(() => _isSubmitting = false);

//       if (response.statusCode == 201) {
//         Flushbar(
//           margin: const EdgeInsets.all(16),
//           borderRadius: BorderRadius.circular(12),
//           backgroundColor: Colors.green.shade600,
//           duration: const Duration(seconds: 3),
//           message: data['messsage'] ?? 'Registration Successful ✅',
//           flushbarPosition: FlushbarPosition.TOP,
//           icon: const Icon(Icons.check_circle, color: Colors.white),
//         ).show(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error: ${data['errors'] ?? 'Something went wrong'}"),
//           ),
//         );
//       }
//     } catch (e) {
//       setState(() => _isSubmitting = false);
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("Error: $e")));
//     }
//   }

//   InputDecoration _inputDecoration(String label, {IconData? icon}) {
//     return InputDecoration(
//       labelText: label,
//       prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
//       ),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     IconData icon, {
//     int maxLines = 1,
//     TextInputType type = TextInputType.text,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         keyboardType: type,
//         decoration: _inputDecoration(label, icon: icon),
//         validator:
//             (val) =>
//                 val == null || val.trim().isEmpty
//                     ? 'Please enter $label'
//                     : null,
//       ),
//     );
//   }

//   Widget _buildFilePicker(
//     String label,
//     PlatformFile? file,
//     Function(PlatformFile) onPick,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade400),
//           boxShadow: [
//             // ignore: deprecated_member_use
//             BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 file == null ? label : file.name,
//                 style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//               onPressed: () => _pickFile(onPick),
//               icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMultipleFilePicker(
//     String label,
//     List<PlatformFile> files,
//     VoidCallback onPick,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade400),
//           boxShadow: [
//             // ignore: deprecated_member_use
//             BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 files.isEmpty ? label : '${files.length} image(s) selected',
//                 style: TextStyle(fontSize: 16, color: Colors.grey[800]),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             IconButton(
//               onPressed: onPick,
//               icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Column(
//                   children: [
//                     Image.asset('assets/images/marrymate.png', height: 100),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Register Your Business',
//                       style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.deepPurple[700],
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Join MarryMate and grow your wedding services',
//                       style: TextStyle(color: Colors.grey[700], fontSize: 15),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 30),
//                 DropdownButtonFormField<String>(
//                   decoration: _inputDecoration(
//                     "Business Type",
//                     icon: Icons.category,
//                   ).copyWith(filled: true, fillColor: Colors.white),
//                   dropdownColor: Colors.white,
//                   value: selectedBusinessType,
//                   iconEnabledColor: Colors.black,
//                   style: const TextStyle(color: Colors.black, fontSize: 16),
//                   items:
//                       [
//                         'Wedding Hall',
//                         'Catering',
//                         'Decorator',
//                         'DJ & Sound System',
//                         'Saloon',
//                         'Pandit',
//                         'Transpottation',
//                       ].map((type) {
//                         return DropdownMenuItem(
//                           value: type,
//                           child: Text(
//                             type,
//                             style: const TextStyle(color: Colors.black),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged:
//                       (value) => setState(() => selectedBusinessType = value),
//                   validator:
//                       (value) =>
//                           value == null ? 'Please select business type' : null,
//                 ),
//                 const SizedBox(height: 20),
//                 _buildTextField(_nameController, 'Full Name', Icons.person),
//                 _buildTextField(
//                   _emailController,
//                   'Email',
//                   Icons.email,
//                   type: TextInputType.emailAddress,
//                 ),
//                 _buildTextField(
//                   _contactController,
//                   'Contact',
//                   Icons.phone,
//                   type: TextInputType.phone,
//                 ),
//                 _buildTextField(
//                   _businessNameController,
//                   'Business Name',
//                   Icons.business,
//                 ),
//                 _buildTextField(
//                   _descriptionController,
//                   'Description',
//                   Icons.description,
//                   maxLines: 3,
//                 ),
//                 _buildTextField(
//                   _addressController,
//                   'Address',
//                   Icons.location_on,
//                 ),
//                 _buildTextField(_stateController, 'State', Icons.map),
//                 _buildTextField(_cityController, 'City', Icons.location_city),
//                 _buildTextField(
//                   _pincodeController,
//                   'Pincode',
//                   Icons.pin,
//                   type: TextInputType.number,
//                 ),
//                 _buildFilePicker(
//                   'Upload Aadhaar Card',
//                   aadhaarCard,
//                   (file) => aadhaarCard = file,
//                 ),
//                 _buildFilePicker(
//                   'Upload PAN Card',
//                   panCard,
//                   (file) => panCard = file,
//                 ),
//                 _buildFilePicker(
//                   'Other Documents',
//                   otherDoc,
//                   (file) => otherDoc = file,
//                 ),
//                 _buildMultipleFilePicker(
//                   'Upload Business Images',
//                   businessImages,
//                   _pickMultipleImages,
//                 ),
//                 if (businessImages.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 20),
//                     child: Wrap(
//                       spacing: 10,
//                       runSpacing: 10,
//                       children:
//                           businessImages
//                               .map(
//                                 (file) => ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: Image.memory(
//                                     file.bytes!,
//                                     width: 80,
//                                     height: 80,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               )
//                               .toList(),
//                     ),
//                   ),
//                 const SizedBox(height: 35),
//                 InkWell(
//                   borderRadius: BorderRadius.circular(50),
//                   onTap: _submitForm,
//                   child: Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(vertical: 18),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(50),
//                       gradient: const LinearGradient(
//                         colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           // ignore: deprecated_member_use
//                           color: Colors.deepPurple.withOpacity(0.4),
//                           blurRadius: 12,
//                           offset: const Offset(0, 6),
//                         ),
//                       ],
//                     ),
//                     child: Center(
//                       child:
//                           _isSubmitting
//                               ? const CircularProgressIndicator(
//                                 color: Colors.white,
//                               )
//                               : const Text(
//                                 'Submit',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                   letterSpacing: 1.1,
//                                 ),
//                               ),
//                     ),
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:another_flushbar/flushbar.dart';

class BusinessRegisterPage extends StatefulWidget {
  const BusinessRegisterPage({super.key});

  @override
  State<BusinessRegisterPage> createState() => _BusinessRegisterPageState();
}

class _BusinessRegisterPageState extends State<BusinessRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  String? selectedBusinessType;
  PlatformFile? aadhaarCard;
  PlatformFile? panCard;
  PlatformFile? otherDoc;
  List<PlatformFile> businessImages = [];
  bool _isSubmitting = false;

  Future<void> _pickFile(Function(PlatformFile) setFile) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => setFile(result.files.first));
    }
  }

  Future<void> _pickMultipleImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true,
    );
    if (result != null) {
      setState(() => businessImages = result.files);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (aadhaarCard == null || panCard == null || otherDoc == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload all required documents')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    var uri = Uri.parse("http://192.168.1.6:8000/api/VendorRegister");
    var request = http.MultipartRequest('POST', uri);

    request.fields['name'] = _nameController.text;
    request.fields['email'] = _emailController.text;
    request.fields['contact'] = _contactController.text;
    request.fields['business_type'] = selectedBusinessType!;
    request.fields['business_name'] = _businessNameController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['address'] = _addressController.text;
    request.fields['state'] = _stateController.text;
    request.fields['city'] = _cityController.text;
    request.fields['pincode'] = _pincodeController.text;

    Future<void> addFileField(String name, PlatformFile file) async {
      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(name, file.bytes!, filename: file.name),
        );
      } else {
        request.files.add(await http.MultipartFile.fromPath(name, file.path!));
      }
    }

    await addFileField('AadharCard', aadhaarCard!);
    await addFileField('PanCard', panCard!);
    await addFileField('othdoc', otherDoc!);

    if (businessImages.isNotEmpty) {
      for (int i = 0; i < businessImages.length; i++) {
        final image = businessImages[i];
        if (kIsWeb) {
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              image.bytes!,
              filename: image.name,
            ),
          );
        } else {
          request.files.add(
            await http.MultipartFile.fromPath('image', image.path!),
          );
        }
      }
    }

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      final data = json.decode(respStr);

      setState(() => _isSubmitting = false);

      if (response.statusCode == 201) {
        Flushbar(
          margin: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(12),
          backgroundColor: Colors.green.shade600,
          duration: const Duration(seconds: 3),
          message: data['messsage'] ?? 'Registration Successful ✅',
          flushbarPosition: FlushbarPosition.TOP,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ).show(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${data['errors'] ?? 'Something went wrong'}"),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  InputDecoration _inputDecoration(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon, color: Colors.deepPurple) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: type,
        decoration: _inputDecoration(label, icon: icon),
        validator:
            (val) =>
                val == null || val.trim().isEmpty
                    ? 'Please enter $label'
                    : null,
      ),
    );
  }

  Widget _buildFilePicker(
    String label,
    PlatformFile? file,
    Function(PlatformFile) onPick,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                file == null ? label : file.name,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: () => _pickFile(onPick),
              icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultipleFilePicker(
    String label,
    List<PlatformFile> files,
    VoidCallback onPick,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade400),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.08), blurRadius: 8),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                files.isEmpty ? label : '${files.length} image(s) selected',
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              onPressed: onPick,
              icon: const Icon(Icons.upload_file, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Image.asset('assets/images/marrymate.png', height: 100),
                    const SizedBox(height: 16),
                    Text(
                      'Register Your Business',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[700],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Join MarryMate and grow your wedding services',
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration(
                    "Business Type",
                    icon: Icons.category,
                  ).copyWith(filled: true, fillColor: Colors.white),
                  dropdownColor: Colors.white,
                  value: selectedBusinessType,
                  iconEnabledColor: Colors.black,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  items:
                      [
                        'Wedding Hall',
                        'Catering',
                        'Decorator',
                        'DJ & Sound System',
                        'Saloon',
                        'Pandit',
                        'Transpottation',
                      ].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                  onChanged:
                      (value) => setState(() => selectedBusinessType = value),
                  validator:
                      (value) =>
                          value == null ? 'Please select business type' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(_nameController, 'Full Name', Icons.person),
                _buildTextField(
                  _emailController,
                  'Email',
                  Icons.email,
                  type: TextInputType.emailAddress,
                ),
                _buildTextField(
                  _contactController,
                  'Contact',
                  Icons.phone,
                  type: TextInputType.phone,
                ),
                _buildTextField(
                  _businessNameController,
                  'Business Name',
                  Icons.business,
                ),
                _buildTextField(
                  _descriptionController,
                  'Description',
                  Icons.description,
                  maxLines: 3,
                ),
                _buildTextField(
                  _addressController,
                  'Address',
                  Icons.location_on,
                ),
                _buildTextField(_stateController, 'State', Icons.map),
                _buildTextField(_cityController, 'City', Icons.location_city),
                _buildTextField(
                  _pincodeController,
                  'Pincode',
                  Icons.pin,
                  type: TextInputType.number,
                ),
                _buildFilePicker(
                  'Upload Aadhaar Card',
                  aadhaarCard,
                  (file) => aadhaarCard = file,
                ),
                _buildFilePicker(
                  'Upload PAN Card',
                  panCard,
                  (file) => panCard = file,
                ),
                _buildFilePicker(
                  'Other Documents',
                  otherDoc,
                  (file) => otherDoc = file,
                ),
                _buildMultipleFilePicker(
                  'Upload Business Images',
                  businessImages,
                  _pickMultipleImages,
                ),
                if (businessImages.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children:
                          businessImages.map((file) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.memory(
                                file.bytes!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                const SizedBox(height: 35),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: _submitForm,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                          _isSubmitting
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  letterSpacing: 1.1,
                                ),
                              ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
