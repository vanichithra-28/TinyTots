import 'package:flutter/material.dart';
import 'package:tinytots_admin/main.dart';

class District extends StatefulWidget {
  const District({super.key});

  @override
  State<District> createState() => _DistrictState();
}

class _DistrictState extends State<District> {
  final TextEditingController _districtname = TextEditingController();
  List<Map<String, dynamic>> _district = [];

  @override
  void initState() {
    super.initState();
    select();
  }

  Future<void> insertdistrict() async {
    try {
      await supabase.from('tbl_district').insert({
        'district_name': _districtname.text,
      });
      select();
      _districtname.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserted successfully')),
      );
    } catch (e) {
      print('Exception during insert: $e');
    }
  }

  Future<void> select() async {
    try {
      final response = await supabase.from('tbl_district').select();
      setState(() {
        _district = response;
      });
    } catch (e) {
      print('Exception during insert: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Form(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("ADD DISTRICT"),
            TextFormField(
              controller: _districtname,
              decoration: InputDecoration(
                hintText: 'district',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  insertdistrict();
                },
                child: Text("submit")),
            Expanded(
              child: ListView.builder(
                itemCount: _district.length,
                itemBuilder: (context, index) {
                  final _districtdata = _district[index];
                  return Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            _districtdata['district_name'],
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }
}
