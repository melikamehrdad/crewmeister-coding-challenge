
# **Absence Management App**

This is a Flutter application designed to manage employee absences using Clean Architecture principles. The application fetches absence data from a remote source, connects it with absence member data, and allows users to filter and paginate through absences based on type, dates, and status.

## **Features**
- **List Absences**: Displays a list of employee absences with the ability to paginate.
- **Absence Details**: Shows details such as member name, absence type, period, status, member and admitter notes.
- **Filtering**: Allows filtering absences by type (vacation, sickness) and date range.
- **Infinite Scroll**: Automatically loads more absences as the user scrolls down.
- **Reset Filters**: Resets all applied filters to show all absences.

## **Architecture**
This project follows the **Clean Architecture** principles, ensuring a separation of concerns and making it easier to scale and maintain the project.

### **Key Layers:**
1. **Presentation Layer**:
   - **Pages**: The UI pages that display the list of absence.
   - **Widgets**: The UI components that display the absence data, apply filters, and show absence details.
  
2. **Domain Layer**:
   - **Entities**: Defines the core business models (`Absence`, `Member`) used throughout the app.
  
3. **Data Layer**:
   - **Repositories**: Interacts with remote data sources to fetch data and passes it to the domain layer.
   - **Data Sources**: Handles fetching data from local storage.

4. **Logic Layer**:
   - **Bloc**: Manages the state of the UI, handles user actions, and communicates with the domain layer to fetch and filter data.

### **Data Flow**:
1. The **UI Layer** sends events to the **Bloc** (Presentation Layer).
2. The **Bloc** requests data from the **Use Case** (Domain Layer).
3. The **Use Case** calls the **Repository** to fetch data from the **Remote Data Source** (Data Layer).
4. The **Repository** returns the data to the **Use Case**, which processes it and sends it back to the **Bloc**.
5. The **Bloc** then updates the UI with the new data.

---

## **Setup**

### **Requirements**
- Flutter SDK >= 3.27.2
- Dart SDK >= 3.6.1
- IDE (Android Studio, VS Code, or any other preferred IDE)

### **Installation**

1. Clone this repository:
    ```bash
    git clone https://github.com/melikamehrdad/crewmeister-coding-challenge.git
    cd crewmeister-coding-challenge
    ```

2. Install dependencies:
    ```bash
    flutter pub get
    ```

3. Run the app:
    ```bash
    flutter run
    ```

---

## **Directory Structure**
Here is a brief overview of the directory structure:

```
assets/
├── json/
│   ├── absences.json           # Contains absences data
│   └── members.json            # Contains members data
lib/
├── bloc/
│   ├── absences_bloc.dart      # Contains the Bloc for managing absences
│   └── absences_event.dart     # Events related to absences (fetched, filtered, load more)
│   └── absences_state.dart     # States related to absences
├── data/
│   ├── models/                 # Contains models for Absence and Member
│   ├── remote_data_source/     # Contains data fetching logic (API)
│   └── repository/             # Contains repository logic for accessing data
├── domain/
│   ├── entities/               # Business entities (Absence, Member)
│   └── repositories/           # Abstract classes for repositories
├── ui/
│   ├── pages/                  # UI Pages (AbsencesPage)
│   ├── widgets/                # UI Widgets for Absence Cards, Filters, etc.
├── utils/
│   └── constants.dart          # Any global constants (URLs, colors, etc.)
└── main.dart                   # Entry point of the app
```

---

## **Testing**

To run the tests for this app, make sure you have **Flutter test** and **mocktail** packages installed.

1. **Run Unit Tests**:
   ```bash
   flutter test test/bloc_test.dart
   ```

2. **Run Widget Tests**:
   ```bash
   flutter test test/widget_test.dart
   ```

---

## **Contributing**

If you would like to contribute to this project, please follow these steps:

1. Fork this repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Create a new Pull Request.
