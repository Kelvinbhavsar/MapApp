
class LocationModel {
  LocationModel({
    this.lat,
    this.long,
    this.address
  });

  int lat;
  String long;
  String address;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      LocationModel(
        lat: json["lat"],
        long: json["long"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "long": long,
        "address": address
  };
}
