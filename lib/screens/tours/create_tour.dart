import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tour_app/screens/tours/get_tours.dart';
import 'package:tour_app/services/services_tours.dart';
import 'package:tour_app/services/services_province.dart';
import 'package:tour_app/services/services_regency.dart';

class CreateTourScreen extends StatefulWidget {
  const CreateTourScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTourScreenState createState() => _CreateTourScreenState();
}

class _CreateTourScreenState extends State<CreateTourScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController latitude = TextEditingController();
  TextEditingController longtitude = TextEditingController();
  String? province;
  String? regency;
  File? _image;
  final picker = ImagePicker();
  final ProvincesService _provincesService = ProvincesService();
  final RegencyService _regencyService = RegencyService();
  final ToursServices _toursServices = ToursServices();
  List<Map<String, String>> provincesData = [];
  List<Map<String, String>> regenciesData = [];
  String? accessToken;
  bool isValid = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProvinces();
    _loadAccessToken();
  }

  void _loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      accessToken = prefs.getString('accessToken') ?? '';
    });
  }

  void _validateInputs() {
    setState(() {
      isValid = name.text.isNotEmpty &&
          latitude.text.isNotEmpty &&
          longtitude.text.isNotEmpty &&
          province != null &&
          regency != null &&
          _image != null;
    });
  }

  void _createTour(
    String name,
    String provinsi,
    String provinsiId,
    String kabkot,
    String kabkotId,
    String latitude,
    String longtitude,
    dynamic images,
    String accessToken,
  ) async {
    setState(() {
      isLoading = true;
    });

    final data = await _toursServices.createTour(
      name,
      provinsi,
      provinsiId,
      kabkot,
      kabkotId,
      latitude,
      longtitude,
      images,
      accessToken,
    );

    if (data != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GetTourScreen(),
        ),
      );

      setState(() {
        isLoading = false;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchProvinces() async {
    final data = await _provincesService.getProvinces();

    if (data != null) {
      setState(() {
        provincesData = List<Map<String, String>>.from(data.map((item) {
          return Map<String, String>.from(item as Map<String, dynamic>);
        }));
      });
    }
  }

  Future<void> _fetchRegencies(String provinceId) async {
    final data = await _regencyService.getRegencies(provinceId);

    if (data != null) {
      setState(() {
        regenciesData = List<Map<String, String>>.from(data.map((item) {
          return Map<String, String>.from(item as Map<String, dynamic>);
        }));
      });
    }
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    _validateInputs();
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    _validateInputs();
  }

  Future<void> showOptions(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Gallery'),
              onTap: () {
                Navigator.of(context).pop();
                getImageFromGallery();
              },
            ),
            ListTile(
              title: const Text('Camera'),
              onTap: () {
                Navigator.of(context).pop();
                getImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Tour', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: name,
                  onChanged: (_) => _validateInputs(),
                  decoration: const InputDecoration(
                    labelText: 'Masukan nama tour',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: province,
                  hint: const Text('Pilih Provinsi'),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      province = newValue!;
                      regency = null;
                    });
                    _fetchRegencies(newValue!);
                    _validateInputs();
                  },
                  items: provincesData.map((Map<String, String> province) {
                    return DropdownMenuItem(
                      value: province['id'],
                      child: Text(province['name']!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: regency,
                  hint: const Text('Pilih Kota/Kabupaten'),
                  elevation: 16,
                  underline: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      regency = newValue!;
                    });
                    _validateInputs();
                  },
                  items: regenciesData.map((Map<String, String> regency) {
                    return DropdownMenuItem(
                      value: regency['id'],
                      child: Text(regency['name']!),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: latitude,
                  onChanged: (_) => _validateInputs(),
                  decoration: const InputDecoration(
                    labelText: 'Masukan Latitude',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: TextField(
                  controller: longtitude,
                  onChanged: (_) => _validateInputs(),
                  decoration: const InputDecoration(
                    labelText: 'Masukan longtitude',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: OutlinedButton(
                  onPressed: () {
                    showOptions(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Colors.black),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
                    child: Text(
                      'Ambil gambar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: _image == null
                    ? Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                        height: 200,
                      )
                    : Image.file(
                        _image!,
                        height: 200,
                      ),
              ),
              const SizedBox(height: 15),
              FractionallySizedBox(
                widthFactor: 0.7,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : isValid
                          ? () async {
                              _createTour(
                                name.text,
                                provincesData.firstWhere((element) =>
                                    element['id'] == province)['name']!,
                                province!,
                                regenciesData.firstWhere((element) =>
                                    element['id'] == regency)['name']!,
                                regency!,
                                latitude.text,
                                longtitude.text,
                                _image!,
                                accessToken!,
                              );
                            }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 36, vertical: 12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(color: Colors.black),
                          ))
                      : const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                          child: Text(
                            'Simpan data',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
