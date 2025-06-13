import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:travller/features/itinerary/screens/itenary_display_screen.dart';
import 'package:travller/app/theme/app_colors.dart';
import 'package:travller/features/location/services/location_suggestions.dart'; // Import the new file
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/itinerary_provider.dart';

class ItineraryScreen extends ConsumerStatefulWidget {
  const ItineraryScreen({super.key});
  @override
  _ItineraryScreenState createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends ConsumerState<ItineraryScreen> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController();
  final LocationSuggestions _locationSuggestions = LocationSuggestions();
  bool _isLoading = false;
  bool _enableSuggestions = true;
  DateTime? _startDate;
  DateTime? _endDate;
  List<String> _suggestions = [];
  final List<String> _interests = []; // List to store interests
  String _selectedCurrency = "USD"; // Default currency

  final List<String> _currencies = [
    "INR",
    "USD",
    "EUR",
    "GBP",
    "JPY"
  ]; // Supported currencies

  void _addInterest(String interest) {
    if (interest.isNotEmpty && !_interests.contains(interest)) {
      setState(() {
        _interests.add(interest);
        _interestsController.clear(); // Clear the text field after adding
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _interests.remove(interest);
    });
  }

  void _pickDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primary,
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void generatePlan() async {
    if (_startDate == null || _endDate == null) {
      _showErrorDialog("Please select both start and end dates.");
      return;
    }
    if (_peopleController.text.isEmpty ||
        int.tryParse(_peopleController.text) == null ||
        int.parse(_peopleController.text) <= 0) {
      _showErrorDialog("Please enter a valid number of people.");
      return;
    }

    final int duration = _endDate!.difference(_startDate!).inDays + 1;
    final int numberOfPeople = int.parse(_peopleController.text);

    final params = ItineraryParams(
      source: _sourceController.text,
      destination: _destinationController.text,
      duration: duration.toString(),
      interests: _interests.join(','),
      numberOfPeople: numberOfPeople,
      startDate: _startDate,
      endDate: _endDate,
      currency: _selectedCurrency,
    );

    // Trigger the provider and listen for changes
    ref.listen<AsyncValue<Map<String, dynamic>>>(
      itineraryProvider(params),
      (previous, next) {
        next.when(
          data: (itineraryData) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ItineraryDisplayScreen(itinerary: itineraryData),
              ),
            );
          },
          loading: () {
            setState(() => _isLoading = true);
          },
          error: (e, st) {
            setState(() => _isLoading = false);
            _showErrorDialog("Failed to generate itinerary: $e");
          },
        );
      },
    );

    setState(() => _isLoading = true);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _toggleSuggestions() {
    setState(() {
      _enableSuggestions = !_enableSuggestions; // Toggle the flag
    });
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _locationSuggestions.dispose(); // Dispose of the suggestions logic
    _destinationController.dispose();
    _interestsController.dispose();
    _peopleController.dispose(); // Dispose the new controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plan Your Trip"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _isLoading
              ? Center(
                  child: Lottie.asset('assets/travel.json'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Source",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _sourceController,
                                  decoration: InputDecoration(
                                    hintText: "Enter your source location",
                                    prefixIcon: const Icon(Icons.location_on,
                                        color: AppColors.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _destinationController,
                                  onChanged: _enableSuggestions
                                      ? (input) {
                                          _locationSuggestions.debounce(input,
                                              (suggestions) {
                                            setState(() {
                                              _suggestions = suggestions;
                                            });
                                          });
                                        }
                                      : null, // Disable suggestions if the flag is false
                                  decoration: InputDecoration(
                                    hintText: "Enter your destination",
                                    prefixIcon: const Icon(Icons.location_on,
                                        color: AppColors.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Chip(
                                    label: Text(
                                      _enableSuggestions
                                          ? "Suggestions: ON"
                                          : "Suggestions: OFF",
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: _enableSuggestions
                                        ? Colors.green
                                        : Colors.red,
                                    onDeleted:
                                        _toggleSuggestions, // Toggle suggestions on tap
                                    deleteIcon: Icon(
                                      _enableSuggestions
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                if (_enableSuggestions &&
                                    _suggestions.isNotEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: _suggestions.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(_suggestions[index]),
                                          onTap: () {
                                            setState(() {
                                              _destinationController.text =
                                                  _suggestions[index];
                                              _suggestions = [];
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Currency",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                DropdownButtonFormField<String>(
                                  value: _selectedCurrency,
                                  items: _currencies
                                      .map((currency) => DropdownMenuItem(
                                            value: currency,
                                            child: Text(currency),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCurrency = value!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Number of People",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _peopleController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Enter number of people",
                                    prefixIcon: const Icon(Icons.people,
                                        color: AppColors.primary),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  "Interests",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _interestsController,
                                  onSubmitted: _addInterest,
                                  decoration: InputDecoration(
                                    hintText: "E.g., beaches, adventure",
                                    prefixIcon: const Icon(Icons.interests,
                                        color: AppColors.primary),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.add,
                                          color: AppColors.primary),
                                      onPressed: () => _addInterest(
                                          _interestsController.text),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  children: _interests
                                      .map((interest) => Chip(
                                            label: Text(interest),
                                            backgroundColor: AppColors.accent,
                                            labelStyle: const TextStyle(
                                                color: Colors.white),
                                            deleteIcon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onDeleted: () =>
                                                _removeInterest(interest),
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Travel Dates",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton.icon(
                                  onPressed: _pickDateRange,
                                  icon: const Icon(
                                    Icons.date_range,
                                    color: AppColors.background,
                                  ),
                                  label: const Text(
                                    "Select Travel Dates",
                                    style:
                                        TextStyle(color: AppColors.background),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                if (_startDate != null && _endDate != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("From",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(height: 5),
                                            Text(
                                              DateFormat('MMM dd, yyyy')
                                                  .format(_startDate!),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        const Icon(Icons.arrow_forward,
                                            color: AppColors.primary),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text("To",
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            const SizedBox(height: 5),
                                            Text(
                                              DateFormat('MMM dd, yyyy')
                                                  .format(_endDate!),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_startDate != null && _endDate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Duration: ${_endDate!.difference(_startDate!).inDays + 1} days",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        ElevatedButton(
                          onPressed: generatePlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.explore,
                                  color: AppColors.background,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Generate Itinerary",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.background),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
