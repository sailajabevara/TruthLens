const express = require("express");
const cors = require("cors");
const axios = require("axios");
require("dotenv").config();

const app = express();

app.use(cors());
app.use(express.json());

const OPENROUTER_API_KEY = process.env.OPENROUTER_API_KEY;
const OPENROUTER_URL = "https://openrouter.ai/api/v1/chat/completions";
const PORT = Number(process.env.PORT || 5000);

if (!OPENROUTER_API_KEY) {
  console.error("Missing OPENROUTER_API_KEY in environment variables.");
  process.exit(1);
}

app.post("/chat", async (req, res) => {
  try {
    const { message } = req.body || {};
    if (typeof message !== "string" || message.trim().length < 3) {
      return res.status(400).json({
        error: "Please provide a valid message with at least 3 characters.",
      });
    }

    const response = await axios.post(
      OPENROUTER_URL,
      {
        model: "google/gemini-2.0-flash-001",
        messages: [
          {
            role: "system",
            content: "You are TruthLens AI. Detect scams and fake jobs. Be concise."
          },
          {
            role: "user",
            content: message.trim()
          }
        ]
      },
      {
        headers: {
          "Authorization": `Bearer ${OPENROUTER_API_KEY}`,
          "Content-Type": "application/json",
          "HTTP-Referer": "https://truthlens.app", // Optional, for OpenRouter rankings
          "X-Title": "TruthLens AI" // Optional
        }
      }
    );

    const reply = response?.data?.choices?.[0]?.message?.content;
    if (!reply || typeof reply !== "string") {
      return res.status(502).json({
        error: "AI service returned an unexpected response format.",
      });
    }

    res.json({
      reply: reply,
    });

  } catch (error) {
    console.error("OpenRouter Error:", error.response ? error.response.data : error.message);

    res.status(500).json({
      error: "Something went wrong with the AI service",
    });
  }
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});