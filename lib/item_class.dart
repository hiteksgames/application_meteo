class City {
  Map<String, dynamic> data;

  City(this.data);

  Map<String, dynamic> toMap() {
    return data;
  }
}

class ApiResponse {
  Map<String, dynamic> data;

  ApiResponse(this.data);

  // Method to get a value by key
  dynamic getValue(String key) {
    return data[key];
  }

  // Method to set a value by key
  void setValue(String key, dynamic value) {
    data[key] = value;
  }

  // Method to check if a key exists
  bool containsKey(String key) {
    return data.containsKey(key);
  }
}