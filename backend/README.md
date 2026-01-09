# DayFlow Backend

REST API backend for the DayFlow Flutter application, built with Node.js and Express.

## Tech Stack

- **Runtime**: Node.js LTS (v18+)
- **Framework**: Express 5.x
- **Database**: Firebase Firestore
- **Auth**: Firebase Admin SDK (ID token verification)
- **Storage**: Firebase Cloud Storage (signed URLs)

## Project Structure

```
backend/
├── src/
│   ├── app.js              # Express app setup
│   ├── server.js           # App bootstrap
│   ├── config/
│   │   └── firebase.js     # Firebase Admin SDK init
│   ├── controllers/        # Route handlers
│   ├── middlewares/
│   │   ├── auth.middleware.js    # Token verification
│   │   ├── error.middleware.js   # Global error handler
│   │   └── validate.js           # Request validation
│   ├── routes/             # API route definitions
│   ├── services/
│   │   └── userRepos.js    # Firestore CRUD operations
│   ├── utils/
│   │   ├── asyncHandler.js
│   │   └── firestoreCollections.js
│   └── validators/         # Request validation schemas
├── .env.example            # Environment variables template
├── API_SPEC.md             # API documentation
├── package.json
└── serviceAccountKey.json  # Firebase service account (do not commit!)
```

## Prerequisites

1. **Node.js** v18 or higher
2. **Firebase Project** with:
   - Firestore database enabled
   - Authentication enabled
   - Cloud Storage bucket (for attachments)
3. **Service Account Key** from Firebase Console

## Local Setup

### 1. Clone and install dependencies

```bash
cd backend
npm install
```

### 2. Configure environment variables

```bash
cp .env.example .env
```

Edit `.env` with your values:

```env
PORT=3000
NODE_ENV=development
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
```

### 3. Add Firebase Service Account

1. Go to Firebase Console → Project Settings → Service Accounts
2. Click "Generate new private key"
3. Save as `backend/serviceAccountKey.json`

### 4. Run the server

```bash
# Development (with hot reload)
npm run dev

# Production
npm start
```

Server runs at `https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev`

### 5. Verify it works

```bash
# Health check
curl https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/health

# Should return: {"status":"ok"}
```

## Running Tests

```bash
# Run all tests
npm test

# Run tests with coverage
npm run test:coverage

# Run tests in watch mode
npm run test:watch
```

## API Authentication

All endpoints (except `/api/health`) require a Firebase ID token:

```bash
curl -H "Authorization: Bearer <FIREBASE_ID_TOKEN>" \
  https://ay-low-ackend-mohamedalaminsaad7753-nw351cb9.leapcell.dev/api/user/me
```

## API Endpoints

See [API_SPEC.md](./API_SPEC.md) for complete documentation.

### Quick Reference

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/health` | Health check |
| GET | `/api/user/me` | Current user identity |
| GET | `/api/tasks` | List tasks |
| POST | `/api/tasks` | Create task |
| PUT | `/api/tasks/:id` | Update task |
| DELETE | `/api/tasks/:id` | Delete task |
| POST | `/api/tasks/:id/toggle-complete` | Toggle completion |
| GET | `/api/habits` | List habits |
| POST | `/api/habits` | Create habit |
| PUT | `/api/habits/:id` | Update habit |
| DELETE | `/api/habits/:id` | Delete habit |
| POST | `/api/habits/:id/toggle-completion` | Toggle for date |
| GET | `/api/notes` | List notes |
| POST | `/api/notes` | Create note |
| PUT | `/api/notes/:id` | Update note |
| DELETE | `/api/notes/:id` | Delete note |
| POST | `/api/notes/:id/toggle-pin` | Toggle pin |
| POST | `/api/notes/:id/lock` | Lock note |
| POST | `/api/notes/:id/unlock` | Unlock note |
| GET | `/api/notifications` | List notifications |
| POST | `/api/notifications` | Create notification |
| POST | `/api/notifications/:id/read` | Mark as read |
| POST | `/api/attachments/presign` | Get upload URL |
| DELETE | `/api/attachments` | Delete attachment |
