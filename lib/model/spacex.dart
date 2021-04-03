import 'package:starship/model/links.dart';

class SpaceX {
  final String name;
  final String details;
  final List<String> patch;
  final Links links;
  final int flightNumber;
  final bool success;

  SpaceX(
      {this.name,
      this.details,
      this.patch,
      this.links,
      this.flightNumber,
      this.success});

  factory SpaceX.fromJson(Map<String, dynamic> json) {
    return SpaceX(
        name: json['name'],
        details: json['details'],
        patch: json['patch'],
        links: json['links'] != null ? new Links.fromJson(json['links']) : null,
        flightNumber: json['flight_number'],
        success: json['success']);
  }
}
