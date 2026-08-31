# High-Level Design Document: Sodium Tracker

## 1. Introduction and Overview

Sodium Tracker is a mobile-first web application designed to help users track and manage their daily sodium intake. The application features:

- User authentication
- Food intake logging with multi-unit support
- Portion calculator with manual and AI-assisted entries
- Hybrid private/shared food catalog with image support
- Daily sodium tracking and warning system

The application follows a serverless architecture pattern with most business logic implemented in the frontend (Flutter) and minimal backend services (TypeScript/Lambda) handling authentication and data access.

## 2. Architecture Diagram

```
[Flutter Frontend] <-- API --> [TypeScript Backend] <-- DynamoDB & S3
                    HTTPS
```

## 3. Frontend Design (Flutter)

### Component Structure

- AuthenticationScreen
- DashboardScreen
- PortionCalculator
- FoodLogger
- CatalogBrowser

### State Management

- Provider for shared state
- Local SQLite for offline caching

### API Integration

- REST API wrapper
- Error handling
- Session management

## 4. Backend Design (TypeScript/Lambda)

### Authentication Service

- Email/password login
- JWT token generation
- Password encryption

### Data Access Layer

- DynamoDB queries
- Connection pooling
- Error handling

### Image Handling

- S3 pre-signed URL generation
- Image metadata storage

## 5. Database Design (DynamoDB)

### Table Schema

```
SodiumTrackerCore
  PK: USER#<UserId> | SHARED#ITEMS
  SK: PROFILE | PORTION#<PortionId> | INTAKE#<YYYY-MM-DD>#<EpochTime>

Attributes:
  - UserProfile (email, passwordHash, etc.)
  - PortionData (name, sodiumPerUnit, etc.)
  - IntakeLog (timestamp, amount, etc.)
```

### Query Patterns

- Get user profile
- List user portions
- Get daily intake
- Search shared catalog

## 6. Image Storage (S3)

### URL Generation

- Pre-signed URLs for upload/download
- Metadata stored in DynamoDB

## 7. API Specifications

### Authentication Endpoints

- POST /auth/login
- POST /auth/register

### Data Endpoints

- GET /portions
- POST /portions
- GET /intake
- POST /intake

### Image Endpoints

- POST /images/generateUploadUrl
- GET /images/generateDownloadUrl

## 8. API Gateway & Lambda Configuration

### API Gateway Setup

- HTTP API type for cost efficiency
- JWT authorizer configuration
- Rate limiting and throttling
- CORS configuration

### Lambda Functions

- AuthenticationHandler - Handles user login/registration
- DataHandler - Manages food portion and intake data
- ImageHandler - Generates S3 pre-signed URLs

### Deployment

- Infrastructure-as-code using AWS CDK
- Environment-specific configuration
