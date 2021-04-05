import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(PaginatedDataGrid());
}

/// Render data pager
class PaginatedDataGrid extends StatefulWidget {
  /// Create data pager
  const PaginatedDataGrid({Key? key}) : super(key: key);

  @override
  _PaginatedDataGrid createState() => _PaginatedDataGrid();
}

List<OrderInfo> orders = [];
List<OrderInfo> paginatedDataSource = [];
final int rowsPerPage = 20;

class _PaginatedDataGrid extends State<PaginatedDataGrid> {
  static const double dataPagerHeight = 60;

  final _OrderInfoRepository _repository = _OrderInfoRepository();
  late OrderInfoDataSource _orderInfoDataSource;

  @override
  void initState() {
    super.initState();
    orders = _repository.getOrderDetails(300);
    _orderInfoDataSource = OrderInfoDataSource();
    _orderInfoDataSource..addListener(updateWidget);
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
                          GridTextColumn(
                              columnName: 'orderID',
                              label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Order ID',
                                  ))),
                          GridTextColumn(
                              columnName: 'customerID',
                              label: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Customer ID'))),
                          GridTextColumn(
                              columnName: 'orderDate',
                              label: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Order Date',
                                    overflow: TextOverflow.ellipsis,
                                  ))),
                          GridTextColumn(
                              columnName: 'freight',
                              label: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Freight'))),
                        ])),
                Container(
                  height: dataPagerHeight,
                  color: Colors.white,
                  child: SfDataPager(
                    pageCount: (orders.length / rowsPerPage).ceilToDouble(),
                    delegate: _orderInfoDataSource,
                    direction: Axis.horizontal,
                  ),
                )
              ],
            );
          }),
        ));
  }
}

class OrderInfoDataSource extends DataGridSource {
  OrderInfoDataSource() {
    paginatedDataSource = orders.getRange(0, rowsPerPage).toList();
    buildPaginatedDataGridRows();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    int startRowIndex = newPageIndex * rowsPerPage;
    int endIndex = startRowIndex + rowsPerPage;

    if (endIndex > orders.length) {
      endIndex = orders.length - 1;
    }

    paginatedDataSource = List.from(
        orders.getRange(startRowIndex, endIndex).toList(growable: false));
    buildPaginatedDataGridRows();
    notifyListeners();
    return true;
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }

  void buildPaginatedDataGridRows() {
    dataGridRows = paginatedDataSource.map<DataGridRow>((dataGridRow) {
      return DataGridRow(cells: [
        DataGridCell(columnName: 'orderID', value: dataGridRow.orderID),
        DataGridCell(columnName: 'customerID', value: dataGridRow.customerID),
        DataGridCell(columnName: 'orderDate', value: dataGridRow.orderData),
        DataGridCell(columnName: 'freight', value: dataGridRow.freight),
      ]);
    }).toList(growable: false);
  }
}

/// Order Details
class OrderInfo {
  OrderInfo(
      {this.orderID,
      this.employeeID,
      this.customerID,
      this.firstName,
      this.lastName,
      this.gender,
      this.shipCity,
      this.shipCountry,
      this.freight,
      this.shippingDate,
      this.orderData,
      this.isClosed});

  final String? orderID;
  final String? employeeID;
  final String? customerID;
  final String? firstName;
  final String? lastName;
  final String? gender;
  final String? shipCity;
  final String? shipCountry;
  final String? freight;
  final DateTime? shippingDate;
  final String? orderData;
  final bool? isClosed;
}

class _OrderInfoRepository {
  final List<DateTime> shippedDate = [];
  final Random random = Random();
  final Map<String, List<String>> shipCity = {
    'Argentina': ['Rosario'],
    'Austria': ['Graz', 'Salzburg'],
    'Belgium': ['Bruxelles', 'Charleroi'],
    'Brazil': ['Campinas', 'Resende', 'Recife', 'Manaus'],
    'Canada': ['Montréal', 'Tsawassen', 'Vancouver'],
    'Denmark': ['Århus', 'København'],
    'Finland': ['Helsinki', 'Oulu'],
    'France': [
      'Lille',
      'Lyon',
      'Marseille',
      'Nantes',
      'Paris',
      'Reims',
      'Strasbourg',
      'Toulouse',
      'Versailles'
    ],
    'Germany': [
      'Aachen',
      'Berlin',
      'Brandenburg',
      'Cunewalde',
      'Frankfurt',
      'Köln',
      'Leipzig',
      'Mannheim',
      'München',
      'Münster',
      'Stuttgart'
    ],
    'Ireland': ['Cork'],
    'Italy': ['Bergamo', 'Reggio', 'Torino'],
    'Mexico': ['México D.F.'],
    'Norway': ['Stavern'],
    'Poland': ['Warszawa'],
    'Portugal': ['Lisboa'],
    'Spain': ['Barcelona', 'Madrid', 'Sevilla'],
    'Sweden': ['Bräcke', 'Luleå'],
    'Switzerland': ['Bern', 'Genève'],
    'UK': ['Colchester', 'Hedge End', 'London'],
    'USA': [
      'Albuquerque',
      'Anchorage',
      'Boise',
      'Butte',
      'Elgin',
      'Eugene',
      'Kirkland',
      'Lander',
      'Portland',
      'San Francisco',
      'Seattle',
    ],
    'Venezuela': ['Barquisimeto', 'Caracas', 'I. de Margarita', 'San Cristóbal']
  };

  List<String> genders = [
    'Male',
    'Female',
    'Female',
    'Female',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Male',
    'Female',
    'Female',
    'Female',
    'Male',
    'Male',
    'Male',
    'Female',
    'Female',
    'Female',
    'Male',
    'Male',
    'Male',
    'Male'
  ];

  List<String> firstNames = [
    'Kyle',
    'Gina',
    'Irene',
    'Katie',
    'Michael',
    'Torrey',
    'William',
    'Bill',
    'Daniel',
    'Frank',
    'Brenda',
    'Danielle',
    'Fiona',
    'Howard',
    'Jack',
    'Larry',
    'Holly',
    'Jennifer',
    'Liz',
    'Pete',
    'Steve',
    'Vince',
    'Zeke',
    'Oscar',
    'Ralph',
  ];

  List<String> lastNames = [
    'Adams',
    'Crowley',
    'Ellis',
    'Gable',
    'Irvine',
    'Keefe',
    'Mendoza',
    'Owens',
    'Rooney',
    'Waddell',
    'Thomas',
    'Betts',
    'Doran',
    'Holmes',
    'Jefferson',
    'Landry',
    'Newberry',
    'Perez',
    'Spencer',
    'Vargas',
    'Grimes',
    'Edwards',
    'Stark',
    'Cruise',
    'Fitz',
    'Chief',
    'Blanc',
    'Perry',
    'Stone',
    'Williams',
    'Lane',
    'Jobs'
  ];

  List<String> customerID = [
    'Alfki',
    'Frans',
    'Merep',
    'Folko',
    'Simob',
    'Warth',
    'Vaffe',
    'Furib',
    'Seves',
    'Linod',
    'Riscu',
    'Picco',
    'Blonp',
    'Welli',
    'Folig'
  ];

  List<String> shipCountry = [
    'Argentina',
    'Austria',
    'Belgium',
    'Brazil',
    'Canada',
    'Denmark',
    'Finland',
    'France',
    'Germany',
    'Ireland',
    'Italy',
    'Mexico',
    'Norway',
    'Poland',
    'Portugal',
    'Spain',
    'Sweden',
    'UK',
    'USA',
  ];

  List<OrderInfo> getOrderDetails(int count) {
    shippedDate
      ..clear()
      ..addAll(_getDateBetween(2000, 2014, count));
    List<OrderInfo> orderDetails = [];

    for (int i = 10001; i <= count + 10000; i++) {
      final String _shipCountry =
          shipCountry[random.nextInt(shipCountry.length)];
      final List<String> _shipCityColl = shipCity[_shipCountry]!;
      final DateTime shippedData = shippedDate[i - 10001];
      final String orderedData = DateFormat.yMd().format(
          DateTime(shippedData.year, shippedData.month, shippedData.day - 2));
      final freight = NumberFormat.currency(locale: 'en_US', symbol: '\$')
          .format((random.nextInt(1000) + random.nextDouble()));
      orderDetails.add(OrderInfo(
        orderID: i.toString(),
        customerID: customerID[random.nextInt(15)],
        employeeID: next(1700, 1800).toString(),
        firstName: firstNames[random.nextInt(15)],
        lastName: lastNames[random.nextInt(15)],
        gender: genders[random.nextInt(5)],
        shipCountry: _shipCountry,
        orderData: orderedData,
        shippingDate: shippedData,
        freight: freight,
        isClosed: (i + (random.nextInt(10)) > 2) ? true : false,
        shipCity: _shipCityColl[random.nextInt(_shipCityColl.length)],
      ));
    }

    return orderDetails;
  }

  int next(int min, int max) => min + random.nextInt(max - min);

  List<DateTime> _getDateBetween(int startYear, int endYear, int count) {
    List<DateTime> date = [];

    for (int i = 0; i < count; i++) {
      int year = next(startYear, endYear);
      int month = random.nextInt(13);
      int day = random.nextInt(31);

      date.add(DateTime(year, month, day));
    }

    return date;
  }
}
