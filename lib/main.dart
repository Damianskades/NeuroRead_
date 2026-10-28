import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

import 'app/neuroread_app.dart';
import 'app/pantalla_error.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      webPersistentTabManager: WebPersistentMultipleTabManager(),
    );
  } catch (error, pila) {
    debugPrint('$error\n$pila');
    runApp(AppError(texto: '$error\n\n$pila'));
    return;
  }
  runApp(const NeuroReadApp());
}
