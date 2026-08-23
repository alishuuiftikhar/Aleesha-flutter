class Employee {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final int departmentId;
  final String departmentName;
  final String joiningDate;
  final double salary;
  final String status;

  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.departmentId,
    required this.departmentName,
    required this.joiningDate,
    required this.salary,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'department_id': departmentId,
      'joining_date': joiningDate,
      'salary': salary,
      'status': status,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map, String deptName) {
    return Employee(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      departmentId: map['department_id'],
      departmentName: deptName,
      joiningDate: map['joining_date'],
      salary: map['salary'],
      status: map['status'],
    );
  }
}
