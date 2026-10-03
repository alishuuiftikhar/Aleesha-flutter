class Customer {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      };
}

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String unit;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'unit',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'unit': unit,
      };
}

class Invoice {
  final String id;
  final String customerId;
  final DateTime date;
  final DateTime dueDate;
  final String status; // 'paid', 'unpaid', 'overdue'
  final double subtotal;
  final double tax;
  final double discount;
  final double total;
  final String? notes;

  Invoice({
    required this.id,
    required this.customerId,
    required this.date,
    required this.dueDate,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.total,
    this.notes,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      customerId: json['customer_id'],
      date: DateTime.parse(json['date']),
      dueDate: DateTime.parse(json['due_date']),
      status: json['status'] ?? 'unpaid',
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
        'customer_id': customerId,
        'date': date.toIso8601String(),
        'due_date': dueDate.toIso8601String(),
        'status': status,
        'subtotal': subtotal,
        'tax': tax,
        'discount': discount,
        'total': total,
        'notes': notes,
      };
}

class InvoiceItem {
  final String id;
  final String invoiceId;
  final String productId;
  final int quantity;
  final double unitPrice;
  final double total;

  InvoiceItem({
    required this.id,
    required this.invoiceId,
    required this.productId,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      invoiceId: json['invoice_id'],
      productId: json['product_id'],
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unit_price'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'invoice_id': invoiceId,
        'product_id': productId,
        'quantity': quantity,
        'unit_price': unitPrice,
        'total': total,
      };
}

class Payment {
  final String id;
  final String invoiceId;
  final DateTime date;
  final double amount;
  final String method;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.date,
    required this.amount,
    required this.method,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      invoiceId: json['invoice_id'],
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0).toDouble(),
      method: json['method'] ?? 'cash',
    );
  }

  Map<String, dynamic> toJson() => {
        'invoice_id': invoiceId,
        'date': date.toIso8601String(),
        'amount': amount,
        'method': method,
      };
}
