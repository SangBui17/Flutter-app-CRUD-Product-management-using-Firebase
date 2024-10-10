import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class ProductService {
  final CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(String name, String type, double price) {
    return products.add({'name': name, 'type': type, 'price': price});
  }

  Stream<QuerySnapshot> getProductsStream() {
    return products.snapshots();
  }

  Future<void> updateProduct(String docID, String name, String type, double price) {
    return products.doc(docID).update({'name': name, 'type': type, 'price': price});
  }

  Future<void> deleteProduct(String docID) {
    return products.doc(docID).delete();
  } 
}

// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   // get collection of note
//   final CollectionReference notes =
//       FirebaseFirestore.instance.collection('notes');
//   // CREATE
//   Future<void> addNote(String note) {
//     return notes.add({'note': note, 'timestamp': Timestamp.now()});
//   }

//   // READ
//   Stream<QuerySnapshot> getNotesStream() {
//     final notesStream =
//         notes.orderBy('timestamp', descending: true).snapshots();

//     return notesStream;
//   }

//   // UPDATE
//   Future<void> updateNote(String docID, String newNote) {
//     return notes
//         .doc(docID)
//         .update({'note': newNote, 'timestamp': Timestamp.now()});
//   }

//   // DELETE
//   Future<void> deleteNote(String docID) {
//     return notes.doc(docID).delete();
//   }
// }