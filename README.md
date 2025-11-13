# Chatbot

## Overview

The **Chatbot** is an interactive Shiny application built in R that leverages OpenAI’s API to provide AI-powered conversational experiences. Users can interact with the chatbot directly in the browser, asking questions, receiving responses, and exploring AI-assisted workflows in real-time.

This project demonstrates how R, Shiny, and OpenAI can be integrated to create intelligent, user-friendly applications.

## Features

- **Real-Time Chat:** Users can type queries and get responses instantly.

- **OpenAI Integration:** Connects to OpenAI’s GPT models for natural language understanding.

- **R & Shiny Interface:** Fully interactive, reactive UI for seamless user experience.

- **Flexible Inputs:** Support for multiple conversation types and prompts.

- **Secure API Handling:** API keys are not stored in code, ensuring safe use.

## Usage
**1. Set your OpenAI API Key:** Before running the app, provide your OpenAI API key in settings:
Note: Do not save your API key directly in the code if you want to keep it secure.

**2. Open the Shiny app in your browser:** shiny::runApp("Chatbot")

**3. Enter your query in the text input box.**

**4. Press Send to receive a response from the AI chatbot.**

**5. Interact with the chatbot as needed for assistance, information retrieval, or workflow support.**

