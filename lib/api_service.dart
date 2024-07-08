import 'dart:convert';
import 'package:http/http.dart' as http;
import 'inventory.dart';

class ApiService {
  final String baseUrl = "https://api.kartel.dev";

  Future<List<Inventory>> getInventories() async {
    final response = await http.get(Uri.parse('$baseUrl/inventori'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Inventory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load inventories');
    }
  }

  Future<Inventory> createInventory(Inventory inventory) async {
    final response = await http.post(
      Uri.parse('$baseUrl/inventori'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(inventory.toJson()),
    );
    if (response.statusCode == 201) {
      return Inventory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create inventory');
    }
  }

  Future<void> deleteInventory(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/inventori/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete inventory');
    }
  }

  Future<Inventory> updateInventory(Inventory inventory) async {
    final response = await http.put(
      Uri.parse('$baseUrl/inventori/${inventory.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(inventory.toJson()),
    );
    if (response.statusCode == 200) {
      return Inventory.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update inventory');
    }
  }
}
