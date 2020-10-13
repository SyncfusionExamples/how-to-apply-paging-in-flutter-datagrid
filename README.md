# How to design and configure the Syncfusion Flutter datapager (SfDataPager) on SfDataGrid ?

The datagrid interactively supports the manipulation of data using SfDataPager control. This provides support to load data in segments when dealing with large volumes of data. SfDataPager can be placed above or below based on the requirement to easily manage data paging.


## Step 1

```xml
@override
Widget build(BuildContext context) {
  return MaterialApp(
      title: 'Paginated SfDataGrid',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Paginated SfDataGrid'),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              SizedBox(
                  height: constraint.maxHeight - dataPagerHeight,
                  width: constraint.maxWidth,
                  child: SfDataGrid(
                      source: _orderInfoDataSource,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: <GridColumn>[
                        GridNumericColumn(
                            mappingName: 'orderID', headerText: 'Order ID')
                          ..headerTextAlignment = Alignment.centerRight,
                        GridTextColumn(
                            mappingName: 'customerID',
                            headerText: 'Customer Name')
                          ..padding = EdgeInsets.zero,
                        GridDateTimeColumn(
                            mappingName: 'orderDate',
                            headerText: 'Order Date')
                          ..dateFormat = DateFormat.yMd()
                          ..padding = EdgeInsets.zero,
                        GridNumericColumn(
                            mappingName: 'freight', headerText: 'Freight')
                          ..headerTextAlignment = Alignment.center
                          ..textAlignment = Alignment.center
                          ..numberFormat = NumberFormat.currency(
                              locale: 'en_US', symbol: '\$'),
                      ])),
              Container(
                height: dataPagerHeight,
                color: Colors.white,
                child: SfDataPager(
                  delegate: _orderInfoDataSource,
                  rowsPerPage: 20,
                  direction: Axis.horizontal,
                ),
              )
            ],
          );
        }),
      ));
}

```xml
## Step 2

Create a common delegate for both data pager and datagrid and do the followings. Please note that by default DataGridSource is extended with the DataPagerDelegate.

1.	Set the SfDataGrid.DataGridSource to the SfDataPager.delegate property.
2.	Set the number of rows to be displayed on a page by setting the SfDataPager.rowsPerPage property.
3.	Set the number of items that should be displayed in view by setting the SfDataPager.visibleItemsCount property.
4.	Override the SfDataPager.delegate.rowCount property and SfDataPager.delegate.handlePageChanges method in SfDataGrid.DataGridSource.
5.	You can load the data for the specific page in handlePageChanges method. This method is called for every page navigation from data pager.

```xml

class OrderInfoDataSource extends DataGridSource<OrderInfo> {
  @override
  List<OrderInfo> get dataSource => paginatedDataSource;

  @override
  Object getValue(OrderInfo orderInfos, String columnName) {
    switch (columnName) {
      case 'orderID':
        return orderInfos.orderID;
        break;
      case 'customerID':
        return orderInfos.customerID;
        break;
      case 'freight':
        return orderInfos.freight;
        break;
      case 'orderDate':
        return orderInfos.orderData;
        break;
      default:
        return '';
        break;
    }
  }

  @override
  int get rowCount => orders.length;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex,
      int startRowIndex, int rowsPerPage) async {
    int endIndex = startRowIndex + rowsPerPage;
    if (endIndex > orders.length) {
      endIndex = orders.length - 1;
    }

    paginatedDataSource = List.from(
        orders.getRange(startRowIndex, endIndex).toList(growable: false));
    notifyDataSourceListeners();
    return true;
  }
}

```

## Step 3

Create an instance of the OrderInfoDataSource and assign that to DataGrid’s source and DataPager’s delegate properties.

```xml

List<OrderInfo> orders = [];
List<OrderInfo> paginatedDataSource = [];

static const double dataPagerHeight = 60;

final _OrderInfoRepository _repository = _OrderInfoRepository();
final OrderInfoDataSource _orderInfoDataSource = OrderInfoDataSource();

@override
void initState() {
  super.initState();
  _orderInfoDataSource..addListener(updateWidget);
  orders = _repository.getOrderDetails(300);
}

updateWidget() {
  setState(() {});
}

@override
Widget build(BuildContext context) {
  return MaterialApp(
      title: 'Paginated SfDataGrid',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Paginated SfDataGrid'),
        ),
        body: LayoutBuilder(builder: (context, constraint) {
          return Column(
            children: [
              SizedBox(
                  height: constraint.maxHeight - dataPagerHeight,
                  width: constraint.maxWidth,
                  child: SfDataGrid(
                      source: _orderInfoDataSource,
                      columnWidthMode: ColumnWidthMode.fill,
                      columns: <GridColumn>[
                        GridNumericColumn(
                            mappingName: 'orderID', headerText: 'Order ID')
                          ..headerTextAlignment = Alignment.centerRight,
                        GridTextColumn(
                            mappingName: 'customerID',
                            headerText: 'Customer Name')
                          ..padding = EdgeInsets.zero,
                        GridDateTimeColumn(
                            mappingName: 'orderDate',
                            headerText: 'Order Date')
                          ..dateFormat = DateFormat.yMd()
                          ..padding = EdgeInsets.zero,
                        GridNumericColumn(
                            mappingName: 'freight', headerText: 'Freight')
                          ..headerTextAlignment = Alignment.center
                          ..textAlignment = Alignment.center
                          ..numberFormat = NumberFormat.currency(
                              locale: 'en_US', symbol: '\$'),
                      ])),
              Container(
                height: dataPagerHeight,
                color: Colors.white,
                child: SfDataPager(
                  delegate: _orderInfoDataSource,
                  rowsPerPage: 20,
                  direction: Axis.horizontal,
                ),
              )
            ],
          );
        }),
      ));
}

```


* [User guide documentation](https://help.syncfusion.com/flutter/datagrid/paging)



