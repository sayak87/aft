import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flag/flag.dart';
import '../models/AUser.dart';
import '../provider/AUserProvider.dart';
import 'AAddPost.dart';
import 'ACountriesValues.dart';
import 'ACountries.dart';
import 'APostCard.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({Key? key}) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  String oneValue = 'United States of America';
  var global = 'true';
  String flag = 'us';
  @override
  void initState() {
    super.initState();
    getValue();
    getValueG();

  }

  Future<void> getValueG() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('selected_radio3') != null) {
      setState(() {
        global = prefs.getString('selected_radio3')!;

      });
    }
  }

  Future<void> setValueG(String valueg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      global = valueg.toString();
      prefs.setString('selected_radio3', global);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ));
    }
    flag=user.country;
    print(">>>>$flag");

    var countryIndex1 = long.indexOf(oneValue);
    if (countryIndex1 >= 0) {
      flag = short[countryIndex1];
      print(">>>>2$flag");
    }





    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 360,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  color: Colors.white,
                  child: TextButton(
                    child:
                        Text('Add Post', style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPost()),
                      );
                    },
                  ),
                ),
                //

                Column(
                  children: [
                    global == 'true'
                        ? Text(
                            'Global',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              letterSpacing: 1,
                            ),
                          )
                        : Text(
                            'National',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                              letterSpacing: 1,
                            ),
                          ),
                    AnimatedToggleSwitch<String>.rollingByHeight(
                        height: 34,
                        current: global,
                        values: const [
                          'true',
                          'false',
                        ],
                        onChanged: (valueg) => setValueG(valueg.toString()),
                        iconBuilder: rollingIconBuilderStringThree,
                        borderRadius: BorderRadius.circular(75.0),
                        indicatorSize: const Size.square(1.8),
                        innerColor: Color.fromARGB(255, 203, 203, 203),
                        indicatorColor: Colors.black,
                        borderColor: Colors.white,
                        iconOpacity: 1),
                  ],
                ),

                //
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      TextButton(
                        child: Text('Countries',
                            style: TextStyle(color: Colors.black)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Countries()),
                          ).then((value) => {getValue()});
                        },
                      ),
                      flag == ''
                          ? Container()
                          : Image.asset('icons/flags/png/${flag}.png',
                              package: 'country_icons', height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),



      //changes by Suman Nandi
      body: global=="true"?
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where("global", isEqualTo: global).orderBy("score", descending: true).orderBy("datePublished", descending: false).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCardTest(
                snap: snapshot.data!.docs[index].data(),
                indexPlacement: index,
              );
            },
          );
        },
      ):
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where("global", isEqualTo: global).where("country", isEqualTo: flag).orderBy("score", descending: true).orderBy("datePublished", descending: false).snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return PostCardTest(
                snap: snapshot.data!.docs[index].data(),
                indexPlacement: index,
              );
            },
          );
        },
      ),
    );

/////////////////





  }

  Widget rollingIconBuilderStringThree(
      String global, Size iconSize, bool foreground) {
    IconData data = Icons.flag;
    if (global == 'true') data = Icons.circle;
    return Icon(data, size: iconSize.shortestSide, color: Colors.white);
  }

  getValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      oneValue = prefs.getString('selected_radio') ?? '';
    });
  }


}
