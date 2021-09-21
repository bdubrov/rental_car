import 'dart:io';

mixin TransportProperty {
  int? _id;
  String? _company;
  String? _model;
  int? _year;
  double? _power;
  String? _fuelType;
  double? _price;
  String? _status;

  int get id => _id ?? -1;
  String get company => _company ?? 'Defaulte';
  String get model => _model ?? 'Defaulte';
  int get year => _year ?? 0;
  double get power => _power ?? 0;
  String get fuelType => _fuelType ?? 'Petrol';
  double get price => _price ?? 0;
  String get status => _status ?? 'Unknown';

  set company(var company) => _company = company;
  set model(var model) => _model = model;
  set year(var newDate) => _year = newDate;
  set power(var newPower) => _power = newPower;
  set fuelType(var newFuelType) => _fuelType = newFuelType;
  set price(var newPrice) => _price = newPrice;
  set status(var status) => _status = status;

  void setAllParameters(
      [String? company,
      String? model,
      int? year,
      double? power,
      String? fuelType,
      double? price,
      String? status]) {
    _company = company;
    _model = model;
    _year = year;
    _power = power;
    _fuelType = fuelType;
    _price = price;
    _status = status;
  }
}

class Transport with TransportProperty {
  static int _genericId = 0;

  Transport();
  factory Transport.factory(String type) {
    _genericId++;
    return type == 'Car' ? Car(_genericId) : Bike(_genericId);
  }

  void printInfo() {
    print(
        'Transoprt #$_id - $_status: $_company $_model. Year = $_year price = $_price power = $_power and use $_fuelType as fuel');
  }
}

class Car extends Transport {
  Car(int id,
      [String? company,
      String? model,
      int? year,
      double? power,
      String? fuelType,
      double? price,
      String? status]) {
    _id = id;
    _company = company;
    _model = model;
    _year = year;
    _power = power;
    _fuelType = fuelType;
    _price = price;
    _status = status;
  }

  @override
  void printInfo() {
    print(
        'Car #$_id - $_status: $_company $_model. Year = $_year price = $_price power = $_power and use $_fuelType as fuel');
  }
}

class Bike extends Transport {
  Bike(int id,
      {String? company,
      String? model,
      int? year,
      double? power,
      String? fuelType,
      double? price,
      String? status}) {
    _id = id;
    _company = company;
    _model = model;
    _year = year;
    _power = power;
    _fuelType = fuelType;
    _price = price;
    _status = status;
  }

  @override
  void printInfo() {
    print(
        'Bike #$_id - $_status: $_company $_model. Year = $_year price = $_price power = $_power and use $_fuelType as fuel');
  }
}

class Customer {
  String _name;
  String _invoiceNumber;
  Function? _ownDiscount;

  Customer(this._name, this._invoiceNumber, [this._ownDiscount]);

  String get name => _name;
  String get invoiceNumber => _invoiceNumber;
  Function get ownDiscount => _ownDiscount ?? applyDiscount();

  set name(String newName) => _name = newName;
  set invoiceNumber(String newInvoiceNumber) =>
      _invoiceNumber = newInvoiceNumber;
  set ownDiscount(Function newDiscount) => _ownDiscount = newDiscount;
}

class Order {
  static int _genericId = 1;
  int? _id;
  int _daysAmount;
  Transport _rentedTransport;
  Customer _customer;
  double _pricePerDay;

  Order(Customer customer, Transport transport, int daysAmount,
      [double? pricePerDay])
      : _id = _genericId,
        _customer = customer,
        _rentedTransport = transport,
        _daysAmount = daysAmount,
        _pricePerDay =
            pricePerDay ?? customer.ownDiscount(transport.price) / daysAmount {
    _genericId++;
  }

  int get id => _id ?? -1;
  int get daysAmount => _daysAmount;
  double get pricePerDay => _pricePerDay;
  Transport get rentedTransport => _rentedTransport;
  Customer get customer => _customer;

  @override
  String toString() {
    return "Order #$_id: Customer ${_customer.name} rent transport with id: ${_rentedTransport.id} for $_daysAmount days by price = $pricePerDay per day";
  }
}

class Rental {
  List<Car> _cars;
  List<Bike> _bikes;
  Set<Order> _orders;

  Rental(this._cars, this._bikes, this._orders);
  Rental.empty()
      : _cars = List.empty(growable: true), // <Car>[]
        _bikes = List.empty(growable: true), // <Bike>[]
        _orders = <Order>{};

  set cars(var newCars) => _cars = newCars;
  List<Car> get cars => _cars;
  set bikes(var newBikes) => _bikes = newBikes;
  List<Bike> get bikes => _bikes;
  set orders(var newOrders) => _orders = newOrders;

  void printAvailableTransport() {
    List<Transport> tmpList = [
      ..._cars.where((car) => car._status == 'Available'),
      ..._bikes.where((bike) => bike._status == 'Available')
    ];
    tmpList.forEach((transport) => transport.printInfo());
  }

  void printInventory() {
    List<Transport> tmpList = [..._cars, ..._bikes];
    tmpList.forEach((transport) => transport.printInfo());
  }

  void rentCar(Customer customer, int daysToRent) {
    printAvailableTransport();

    print('Please choose transport to rent by entering it`s id: ');
    int? index = int.tryParse(stdin.readLineSync()!);

    assert(index != null);

    Transport transportToRent = [..._cars, ..._bikes]
        .where((transport) => transport.id == index)
        .single;

    assert(transportToRent.id == index);

    _orders.add(Order(customer, transportToRent, daysToRent));

    if (transportToRent is Car) {
      print('Car ${transportToRent._id} was rented by ${customer._name}');
    } else if (transportToRent is Bike) {
      print('Bike ${transportToRent._id} was rented by ${customer._name}');
    }
    print('And new order was created:');
    print('   ${_orders.last}');

    transportToRent.status = 'Rented';
  }
}

Function applyDiscount({double discountPercent = 0}) {
  return (double price) => price - (price * discountPercent / 100);
}

void main(List<String> arguments) {
  Rental rental = Rental.empty();

  Car car1 = Transport.factory('Car') as Car;
  car1.setAllParameters('A', 'a', 2020, 1000, 'petrol', 100000, 'Available');
  Car car2 = Transport.factory('Car') as Car;
  car2.setAllParameters('A', 'b', 2010, 300, 'gas', 8000, 'Available');
  Car car3 = Transport.factory('Car') as Car;
  car3.setAllParameters('B', 'B', 2015, 600, 'electro', 20000, 'Available');

  Bike bike1 = Transport.factory('Bike') as Bike;
  bike1.setAllParameters('X', 'x', 2020, 150, 'petrol', 12000, 'Available');
  Bike bike2 = Transport.factory('Bike') as Bike;
  bike2.setAllParameters('Y', 'y', 2018, 100, 'petrol', 6000, 'Available');
  Bike bike3 = Transport.factory('Bike') as Bike;
  bike3.setAllParameters('Z', 'z', 2020, 300, 'petrol', 18000, 'Available');

  rental.cars
    ..add(car1)
    ..add(car2)
    ..add(car3);

  rental.bikes.addAll([bike1, bike2, bike3]);

  Customer cust1 =
      Customer('US-001', '1010101', applyDiscount(discountPercent: 10));
  Customer cust2 = Customer('UA-002', '2222222');

  rental.rentCar(cust1, 10);
  print('');
  rental.rentCar(cust2, 30);
  print('');

  print('Let`s print all inventory:');
  rental.printInventory();
}
