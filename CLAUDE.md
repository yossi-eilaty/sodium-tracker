# Sodium Tracker Project Documentation

## Project Structure

```
sodium-tracker/
├── backend/          # TypeScript backend services
│   ├── package.json
│   ├── package-lock.json
│   └── tsconfig.json
├── frontend/         # Flutter mobile-first frontend
│   ├── src/
│   ├── pubspec.yaml
│   ├── pubspec.lock
│   └── README.md
└── doc/              # Project documentation
```

## Running the Frontend (Flutter)

### Development Mode
```bash
cd frontend
flutter pub get      # Install dependencies
flutter run          # Start development server
```

### Production Build
```bash
cd frontend
flutter build apk    # Build Android APK
flutter build ios    # Build iOS application
```

## Running the Backend (TypeScript)

### Development Mode
```bash
cd backend
npm install          # Install dependencies
npm start           # Start development server
```

### Production Build
```bash
cd backend
npm run build       # Compile TypeScript
npm start           # Start production server
```

## Development Workflow

1. Clone the repository
2. Start frontend development server:
   ```bash
   cd frontend
   flutter run -d chrome
   ```
3. Start backend development server:
   ```bash
   cd backend
   npm start
   ```

## Project Specifications

For full project specifications, see [doc/sodium-tracker-spec.md](/doc/sodium-tracker-spec.md)