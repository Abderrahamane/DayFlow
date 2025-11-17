# DayFlow Backend

Node.js backend for the DayFlow application with MongoDB integration.

## 📁 Project Structure

```
backend/
├── config/           # Configuration files (database, etc.)
├── controllers/      # Route controllers
├── models/          # MongoDB models
├── routes/          # API routes
├── .env.example     # Example environment variables
├── package.json     # Dependencies
└── server.js        # Main server file
```

## 🚀 Setup Instructions (For Mohammed)

### Step 1: Install Dependencies

Navigate to the backend folder and install required packages:

```bash
cd backend
npm install
```

This will install:
- **express**: Web framework for Node.js
- **mongoose**: MongoDB object modeling
- **dotenv**: Environment variable management
- **cors**: Cross-Origin Resource Sharing
- **body-parser**: Request body parsing
- **nodemon**: Auto-restart during development (dev dependency)

### Step 2: Set Up MongoDB

You have two options:

#### Option A: MongoDB Atlas (Recommended for Cloud)

1. Go to [https://www.mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account
3. Create a new cluster (free tier is fine)
4. Click "Connect" → "Connect your application"
5. Copy the connection string
6. Create a `.env` file in the backend folder (copy from `.env.example`)
7. Replace `MONGODB_URI` with your Atlas connection string

Example:
```env
MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/dayflow?retryWrites=true&w=majority
```

#### Option B: Local MongoDB

1. Install MongoDB on your computer: [https://www.mongodb.com/try/download/community](https://www.mongodb.com/try/download/community)
2. Start MongoDB service
3. Use the default local connection in `.env`:
```env
MONGODB_URI=mongodb://localhost:27017/dayflow
```

### Step 3: Configure Environment

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Edit `.env` and add your MongoDB URI

### Step 4: Start the Server

For development (auto-restarts on file changes):
```bash
npm run dev
```

For production:
```bash
npm start
```

You should see:
```
✅ MongoDB connected successfully
📦 Database: dayflow
✅ Server running on port 5000
🌐 Environment: development
```

### Step 5: Test the API

Open your browser or use curl/Postman to test:

```bash
curl http://localhost:5000/api/status
```

You should get a response like:
```json
{
  "ok": true,
  "message": "DayFlow backend is running",
  "timestamp": "2024-01-20T10:30:00.000Z",
  "database": {
    "status": "connected",
    "name": "dayflow"
  },
  "environment": "development"
}
```

## 📝 What's Already Implemented

- ✅ Express server setup
- ✅ MongoDB connection
- ✅ Basic folder structure
- ✅ Status endpoint (GET /api/status)
- ✅ Error handling middleware
- ✅ CORS enabled
- ✅ Environment configuration

## 🎯 Next Steps (Future Development)

After the basic setup is working, you can add:

1. **User routes**: `/api/users`
2. **Task routes**: `/api/tasks`
3. **Habit routes**: `/api/habits`
4. **Authentication**: JWT tokens
5. **MongoDB models** in the `models/` folder

## 📚 Resources

- Express.js Documentation: [https://expressjs.com/](https://expressjs.com/)
- Mongoose Documentation: [https://mongoosejs.com/](https://mongoosejs.com/)
- MongoDB Atlas Tutorial: [https://www.mongodb.com/docs/atlas/getting-started/](https://www.mongodb.com/docs/atlas/getting-started/)

## 🐛 Troubleshooting

### Port already in use
If port 5000 is taken, change the `PORT` in `.env`:
```env
PORT=3000
```

### MongoDB connection fails
- Check your MongoDB service is running (local)
- Verify connection string is correct (Atlas)
- Check firewall/network settings
- Ensure IP whitelist is configured (Atlas)

### Dependencies not installing
Try:
```bash
npm cache clean --force
npm install
```

## 📞 Getting Help

If you encounter any issues:
1. Check the error messages in the terminal
2. Read the documentation links above
3. Ask team lead (Abderrahmane) for help
4. Search Stack Overflow for specific errors

Good luck! 🚀
