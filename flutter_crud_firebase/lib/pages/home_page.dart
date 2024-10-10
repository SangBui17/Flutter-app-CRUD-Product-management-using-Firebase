import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_crud_firebase/services/firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductService productService = ProductService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  void openProductDialog(
      {String? docID,
      String? currentName,
      String? currentType,
      double? currentPrice}) {
    if (docID != null) {
      nameController.text = currentName!;
      typeController.text = currentType!;
      priceController.text = currentPrice.toString();
    } else {
      nameController.clear();
      typeController.clear();
      priceController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            docID == null ? 'Nhập thông tin sản phẩm' : 'Cập nhật sản phẩm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên sản phẩm')),
            TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Loại sản phẩm')),
            TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Giá'),
                keyboardType: TextInputType.number),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _imageFile =
                    await _picker.pickImage(source: ImageSource.gallery);
              },
              child: Text('Chọn hình ảnh'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                productService.addProduct(nameController.text,
                    typeController.text, double.parse(priceController.text));
              } else {
                productService.updateProduct(docID, nameController.text,
                    typeController.text, double.parse(priceController.text));
              }
              Navigator.pop(context);
            },
            child: Text(docID == null ? 'Thêm' : 'Cập nhật'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(title: const Text("Quản lý sản phẩm")),
      body: StreamBuilder<QuerySnapshot>(
        stream: productService.getProductsStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> productsList = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = productsList[index];
                String docID = document.id;
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(data['imageUrl'] ?? 'default_image_url'),
                    ),
                    title: Text(data['name']),
                    subtitle:
                        Text('Loại: ${data['type']} - Giá: ${data['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openProductDialog(
                            docID: docID,
                            currentName: data['name'],
                            currentType: data['type'],
                            currentPrice: data['price'],
                          ),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => productService.deleteProduct(docID),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openProductDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class _HomePageState extends State<HomePage> {
//   // firestore
//   final FirestoreService firestoreService = FirestoreService();
//   // text controller
//   final TextEditingController textController = TextEditingController();

//   // open a dialog vox to add a note
//   void openNoteBox({String? docID}) {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               content: TextField(
//                 controller: textController,
//               ),
//               actions: [
//                 // button to save
//                 ElevatedButton(
//                     onPressed: () {
//                       // add a new note
//                       if (docID == null) {
//                         firestoreService.addNote(textController.text);
//                       }
//                       // update a existing note
//                       else {
//                         firestoreService.updateNote(docID, textController.text);
//                       }

//                       // clear the text controller
//                       textController.clear();

//                       // close the box
//                       Navigator.pop(context);
//                     },
//                     child: Text('Add'))
//               ],
//             ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Notes")),
//       floatingActionButton: FloatingActionButton(
//         onPressed: openNoteBox,
//         child: const Icon(Icons.add),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: firestoreService.getNotesStream(),
//         builder: (context, snapshot) {
//           // if we have a data get all a docs
//           if (snapshot.hasData) {
//             List notesList = snapshot.data!.docs;

//             // display a list
//             return ListView.builder(
//               itemCount: notesList.length,
//               itemBuilder: (context, index) {
//                 // get each individual doc
//                 DocumentSnapshot document = notesList[index];
//                 String docID = document.id;

//                 // get note from each doc
//                 Map<String, dynamic> data =
//                     document.data() as Map<String, dynamic>;
//                 String noteText = data['note'];

//                 // display as a list title
//                 return ListTile(
//                     title: Text(noteText),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         // update
//                         IconButton(
//                             onPressed: () => openNoteBox(docID: docID),
//                             icon: const Icon(Icons.settings)),
//                         // delete    
//                         IconButton(
//                           onPressed: () => firestoreService.deleteNote(docID), 
//                           icon: const Icon(Icons.delete) 
//                           ),
//                       ],
//                     ));
//               },
//             );
//           } else {
//             return const Text('No note..');
//           }
//         },
//       ),
//     );
//   }
// }
