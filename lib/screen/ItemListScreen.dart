import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ror_2_companion/model/Item.dart';
import 'package:ror_2_companion/provider/DataProvider.dart';
import 'package:ror_2_companion/provider/SettingProvider.dart';
import 'package:ror_2_companion/widget/CustomDetailRow.dart';
import 'package:ror_2_companion/widget/CustomGridTile.dart';
import 'package:ror_2_companion/widget/ItemFilterDialog.dart';

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  TextEditingController _searchController = TextEditingController();

  Widget _buildItemGrid(BuildContext ctx, int index) {
    var prov = DataProvider.of(context);
    var data = prov.filteredItemList[index];

    return CustomGridTile(
      id: data.id,
      imagePath: "asset/gameAsset/item/${data.id}.png",
      name: data.name,
      path: "/item",
    );
  }

  void _onSearch(String text) {
    DataProvider.of(context).filterItem(text);
  }

  void _showFilterDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return ItemFilterDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Consumer<DataProvider>(
        builder: (_, dataModel, __) {
          return Column(
            children: <Widget>[
              Container(
                // height: 50,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(6),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Search",
                          suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                _searchController.text = "";
                                _onSearch("");
                              }),
                        ),
                        controller: _searchController,
                        onChanged: _onSearch,
                        onSubmitted: _onSearch,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: _showFilterDialog,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Expanded(
                child: Consumer<SettingProvider>(builder: (_, settingModel, __){
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: settingModel.gridCount),
                    itemBuilder: _buildItemGrid,
                    itemCount: dataModel.filteredItemList.length,
                  );
                },),
              )
            ],
          );
        },
      ),
    );
  }
}
