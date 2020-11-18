import 'package:flutter/material.dart';
import 'package:live_chat/components/common/container_column.dart';
import 'package:live_chat/components/common/container_row.dart';

class SearchUserPage extends StatefulWidget {
  @override
  _SearchUserPageState createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  @override
  Widget build(BuildContext context) {
    double marginWithoutWidth = MediaQuery.of(context).size.width - 20;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search User'),
        elevation: 0,
      ),

      body: ContainerColumn(
        padding: EdgeInsets.all(10),
        children: [

          ContainerRow(
            children: [
              Container(
                height: 50,
                width: marginWithoutWidth * 0.7,
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  color: Colors.grey.shade300.withOpacity(0.8),
                ),

                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(5),
                    hintText: 'Kullanıcı adı giriniz.'
                  ),
                ),
              ),

              Container(
                height: 50,
                width: marginWithoutWidth * 0.3,
                child: InkWell(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),

                  onTap: () {
                    
                  },
                  
                  child: ContainerRow(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                    ),

                    children: [
                      Text('Ara', style: TextStyle(fontSize: 16),),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              )
            ],
          ),

          SizedBox(height: 10),

          Expanded(
            child: ListView(
              children: [

                ListTile(
                  onTap: () {

                  },

                  leading: Icon(Icons.ac_unit),
                  title: Text('Title'),
                  subtitle: Text('Subtitle'),
                  trailing: Icon(Icons.add),
                )

              ],
            ),
          )
        ],
      ),
    );
  }
}
