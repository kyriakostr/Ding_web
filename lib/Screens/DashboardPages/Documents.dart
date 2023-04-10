import 'package:ding_web/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:provider/provider.dart';

class Documents extends StatelessWidget {
  const Documents({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final futurefiles = FirebaseStorage.instance.ref().child('${user?.displayName}/').listAll();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('QR CODES',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.amberAccent,
              borderRadius: BorderRadius.circular(20)
            ),
            child: IconButton(icon: Icon(Icons.file_copy),onPressed: () {
              futurefiles.then((value) { 
                
                return value.items.forEach((element) {
                 
                  download(element);});});
            },),
          ),
        ],
      ),
    );
  }
}
Future download(Reference ref) async{
    final url =await ref.getDownloadURL();
    final WebImageDownloader _webImageDownloader = WebImageDownloader();
    await _webImageDownloader.downloadImageFromWeb(url,name:ref.name);
    Utils().showSnackBar('Download files');
  }