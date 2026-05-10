const express = require("express");
const cors = require("cors");
require("dotenv").config();

const { GoogleGenerativeAI } = require("@google/generative-ai");

const app = express();

app.use(cors());
app.use(express.json());

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);

app.post("/chat", async (req, res) => {
  try {
    const { message } = req.body;

    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash-002",
    });

    const result = await model.generateContent(
      `You are TruthLens AI. Detect scams and fake jobs.\nUser message: ${message}`
    );

    const response = result.response.text();

    res.json({
      reply: response,
    });

  } catch (error) {
    console.log(error);

    res.status(500).json({
      error: "Something went wrong",
    });
  }
});

app.listen(5000, () => {
  console.log("Server running on port 5000");
});