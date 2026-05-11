# TruthLens Backend

Node.js backend for TruthLens AI, providing a `/chat` endpoint powered by OpenRouter.

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Configure environment variables:
   Copy `.env.example` to `.env` and add your `OPENROUTER_API_KEY`.

   ```bash
   cp .env.example .env
   ```

3. Start the server:
   ```bash
   node server.js
   ```

The server will run on `http://localhost:5000`.

## API Endpoints

### `POST /chat`
- **Body:** `{ "message": "your message" }`
- **Response:** `{ "reply": "AI response" }`
