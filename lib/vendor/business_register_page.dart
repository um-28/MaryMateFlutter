// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

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
//   XFile? aadhaarCard;
//   XFile? panCard;
//   XFile? otherDoc;
//   List<XFile>? businessImages = [];

//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickFile(Function(XFile) setFile) async {
//     final picked = await _picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       setState(() => setFile(picked));
//     }
//   }

//   Future<void> _pickMultipleImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.isNotEmpty) {
//       setState(() => businessImages = pickedFiles);
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
//                 items: ['Venue', 'Catering', 'Decorator', 'Photography']
//                     .map((type) => DropdownMenuItem(value: type, child: Text(type)))
//                     .toList(),
//                 onChanged: (value) => setState(() => selectedBusinessType = value),
//                 validator: (value) => value == null ? 'Please select business type' : null,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? 'Enter your name' : null,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(labelText: "Email"),
//                 validator: (value) => value!.isEmpty ? 'Enter your email' : null,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _contactController,
//                 decoration: const InputDecoration(labelText: "Contact"),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) => value!.isEmpty ? 'Enter contact number' : null,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _businessNameController,
//                 decoration: const InputDecoration(labelText: "Business Name"),
//                 validator: (value) => value!.isEmpty ? 'Enter business name' : null,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(labelText: "Description"),
//                 maxLines: 3,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 maxLines: 2,
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _stateController,
//                 decoration: const InputDecoration(labelText: "State"),
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _cityController,
//                 decoration: const InputDecoration(labelText: "City"),
//               ),

//               const SizedBox(height: 12),
//               TextFormField(
//                 controller: _pincodeController,
//                 decoration: const InputDecoration(labelText: "Pincode"),
//                 keyboardType: TextInputType.number,
//               ),

//               const SizedBox(height: 16),
//               const Text("Upload Aadhaar Card"),
//               ElevatedButton(
//                 onPressed: () => _pickFile((file) => aadhaarCard = file),
//                 child: Text(aadhaarCard == null ? "Select File" : "Change File"),
//               ),

//               const SizedBox(height: 16),
//               const Text("Upload PAN Card"),
//               ElevatedButton(
//                 onPressed: () => _pickFile((file) => panCard = file),
//                 child: Text(panCard == null ? "Select File" : "Change File"),
//               ),

//               const SizedBox(height: 16),
//               const Text("Upload Other Document"),
//               ElevatedButton(
//                 onPressed: () => _pickFile((file) => otherDoc = file),
//                 child: Text(otherDoc == null ? "Select File" : "Change File"),
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
//                 children: businessImages?.map((img) {
//                   return Image.file(
//                     File(img.path),
//                     width: 80,
//                     height: 80,
//                     fit: BoxFit.cover,
//                   );
//                 }).toList() ?? [],
//               ),

//               const SizedBox(height: 30),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.black,
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
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
// }
