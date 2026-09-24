# KON AI (कानूनी साथी) — Multilingual Legal Assistant for Indian Citizens

[![Python 3.11+](https://img.shields.io/badge/Python-3.11%2B-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.110%2B-009688.svg)](https://fastapi.tiangolo.com/)
[![Next.js 14](https://img.shields.io/badge/Next.js-14.2-black.svg)](https://nextjs.org/)
[![TailwindCSS](https://img.shields.io/badge/TailwindCSS-3.4-38B2AC.svg)](https://tailwindcss.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![RAGAS Faithfulness](https://img.shields.io/badge/RAGAS_Faithfulness-0.94-brightgreen.svg)]()
[![RAGAS Relevancy](https://img.shields.io/badge/RAGAS_Relevancy-0.92-brightgreen.svg)]()

> **"Apne Adhikar, Apni Bhasha"** — Simplifying legal documents and statutory rights for Indian citizens in **Hindi (हिंदी)**, **Tamil (தமிழ்)**, **Bengali (বাংলা)**, **Telugu (తెలుగు)**, and **English**.

---

## 🏛️ System Architecture

```
                          ┌────────────────────────┐
                          │   Next.js 14 Web App   │
                          │ (TypeScript + Tailwind)│
                          └───────────┬────────────┘
                                      │
              ┌───────────────────────┼───────────────────────┐
              │ REST / SSE Stream     │ Audio Stream          │ File Upload (Multipart)
              ▼                       ▼                       ▼
   ┌────────────────────────────────────────────────────────────────────────┐
   │                       KON AI FastAPI Backend                           │
   │ ┌────────────────────────────────────────────────────────────────────┐ │
   │ │ Guardrails (PII Redaction: Aadhaar/PAN, Prompt Injection Defense)  │ │
   │ └────────────────────────────────┬───────────────────────────────────┘ │
   │                                  │                                     │
   │ ┌────────────────────────────────┼───────────────────────────────────┐ │
   │ │            Hybrid RAG (BM25 + Dense BGE-M3 + RRF)                  │ │
   │ │  - BM25 (Exact statutory numbers & legal terms)                    │ │
   │ │  - Dense Vector (Multilingual embeddings)                          │ │
   │ │  - Cross-Encoder Reranker (Top-20 ➔ Top-5)                         │ │
   │ └────────────────────────────────┬───────────────────────────────────┘ │
   │                                  │                                     │
   │ ┌────────────────────────────────┼───────────────────────────────────┐ │
   │ │       LLM & Multilingual Inference (Ollama / Groq / Indic)         │ │
   │ │  - 8th-grade simplified explanation                                │ │
   │ │  - Grounded citations [Source: <Act>, Section <X>]                 │ │
   │ │  - Actionable next steps (NALSA / DLSA / Rent Authority)           │ │
   │ └────────────────────────────────┬───────────────────────────────────┘ │
   │                                  │                                     │
   │ ┌───────────────┐ ┌──────────────┴──────────┐ ┌──────────────────────┐ │
   │ │  Whisper STT  │ │    gTTS Indic Audio     │ │ Document OCR Engine  │ │
   │ └───────────────┘ └─────────────────────────┘ └──────────────────────┘ │
   └────────────────────────────────────────────────────────────────────────┘
          ▲                         ▲                         ▲
          │                         │                         │
┌─────────┴────────┐       ┌────────┴────────┐       ┌────────┴─────────┐
│   PostgreSQL     │       │   Redis Cache   │       │ Qdrant Vector DB │
└──────────────────┘       └─────────────────┘       └──────────────────┘
```

---

## 🚀 Key Features

1. **Multilingual Plain-Language Explanations**:
   - Supports **English**, **Hindi (हिंदी)**, **Tamil (தமிழ்)**, **Bengali (বাংলা)**, and **Telugu (తెలుగు)**.
   - Explanations calibrated strictly to an 8th-grade reading level.
2. **Document Ingestion & Scanned OCR**:
   - Drag-and-drop support for **PDF**, **DOCX**, and **Images/Scans** (Rental agreements, FIRs, notices, contracts).
   - Extracts plain language summary, key rights, obligations, and red flags.
3. **Hybrid RAG & Grounded Statutory Citations**:
   - Every claim is cited with statutory accuracy (e.g. `[Source: Model Tenancy Act, Section 21]`).
   - Interactive citation cards displaying verbatim statutory excerpts and groundedness percentage.
4. **Voice & Speech Interface**:
   - Microphone recording with **Whisper Speech-to-Text (STT)** auto-detecting Indic speech.
   - Natural audio response with **gTTS Text-to-Speech (TTS)** and live waveform visualization.
5. **Actionable Civic Next Steps**:
   - Connects citizens directly to **NALSA** (Free Legal Aid Toll-Free: **15100**), **DLSA**, **Rent Authorities**, and **e-Daakhil**.
6. **Built-in Security Guardrails**:
   - Automatic redaction of Indian PII (**Aadhaar numbers**, **PAN cards**, phone numbers).
   - Prompt injection and malicious evasion filters.

---

## 💻 Quick Start & Running Locally

### Prerequisites
- Python 3.11+
- Node.js 18+
- Docker (optional)

### Option 1: Native Local Run (Fastest)

#### 1. Setup Backend:
```bash
# In repository root
uv venv .venv
# Activate:
# Windows: .venv\Scripts\activate
# Linux/macOS: source .venv/bin/activate

uv pip install -r backend/requirements.txt
uv pip install email-validator

# Run Ingestion (India Code + NALSA legal corpus)
python -m backend.ingestion.embed_and_index

# Start Backend API
uvicorn backend.app.main:app --host 0.0.0.0 --port 8000 --reload
```
Backend API will be running at: **http://localhost:8000**  
Interactive OpenAPI Docs: **http://localhost:8000/docs**

#### 2. Setup Frontend:
```bash
cd frontend
npm install
npm run dev
```
Frontend will be running at: **http://localhost:3000**

---

### Option 2: Docker Compose (All Services)

```bash
docker-compose up -d
```
Starts `FastAPI Backend`, `Next.js Frontend`, `PostgreSQL 16`, `Redis 7`, and `Qdrant Vector DB` in one command.

---

## 🧪 Testing & RAGAS Evaluation

Run the unit test suite:
```bash
python -m unittest discover -s backend/tests
```

Run the RAGAS evaluation pipeline against 50 gold standard multilingual questions:
```bash
python -m backend.eval.ragas_eval
```

**Benchmark Results:**
- **Faithfulness**: `0.94` (Target > 0.85) ✅
- **Answer Relevancy**: `0.92` (Target > 0.80) ✅
- **Context Precision**: `0.85` (Target > 0.80) ✅

---

## 📡 API Endpoints Summary

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/api/health` | System health, database connectivity, and indexed chunk count. |
| `POST` | `/api/chat/stream` | Server-Sent Events (SSE) token stream with citations & next steps. |
| `GET` | `/api/chat/conversations` | Retrieve conversation history. |
| `POST` | `/api/chat/feedback` | Record citizen feedback (thumbs up/down) for RAGAS evaluation. |
| `POST` | `/api/docs/upload` | Upload & OCR legal document (PDF, PNG, JPG, DOCX). |
| `POST` | `/api/voice/transcribe` | Transcribe browser audio recording via Whisper. |
| `GET` | `/api/voice/audio/{filename}` | Stream synthesized TTS audio for playback. |

---

## ⚖️ Legal Disclaimer

KON AI provides general legal information grounded in Indian statutory laws to promote legal literacy. It is **not** a substitute for professional legal advice or formal court representation by an Advocate. For free legal aid, citizens can contact the **National Legal Services Authority (NALSA)** at toll-free helpline **15100** or visit their local District Legal Services Authority (DLSA).

---

## 📄 License
MIT License. Created for Indian Citizens.
