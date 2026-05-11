# TruthLens: AI-Powered Cybersecurity & Threat Intelligence Platform

## Executive Overview
TruthLens is an enterprise-grade, real-time threat intelligence and fraud detection platform. Engineered to intercept and neutralize sophisticated digital threats—including programmatic phishing, credential harvesting, Domain Generation Algorithm (DGA) deployments, and highly targeted employment fraud—TruthLens leverages a hybrid heuristic orchestration model and multi-layered AI analysis to protect end-users at the edge.

Our mission is to democratize cybersecurity by delivering computational risk modeling and Explainable AI (XAI) directly to the mobile attack surface, ensuring decisions are data-driven, mathematically rigorous, and instantaneously actionable.

## 1. System Architecture & Modular Threat Intelligence
The TruthLens ecosystem is built on a scalable, event-driven architecture designed to process high-velocity unstructured data streams (URLs, SMS, documents, OCR extractions). The core consists of loosely coupled, highly cohesive subsystems adhering strictly to SOLID principles and Clean Architecture design patterns.

- **Edge Client (Flutter):** A performant, cross-platform client executing asynchronous state management and offloading complex computational tasks via non-blocking isolates.
- **Failover Analysis Pipeline:** To guarantee zero-downtime protection, TruthLens implements a resilient failover protocol. Primary threat analysis is orchestrated via an advanced LLM (OpenRouter/Claude), followed by a deterministic, offline-capable Modular Heuristic Engine that activates instantly upon network degradation.
- **Microservices Backend (Node.js/Express):** A stateless API layer facilitating scalable AI integrations, maintaining secure context windows, and executing rate-limited conversational threat analysis.

## 2. The Core Intelligence Engine
The TruthLens Intelligence Engine departs from legacy boolean rule sets, employing an **Asynchronous Analyzer Pipeline** to conduct distributed risk evaluation.

### Asynchronous Analyzer Pipeline
Incoming payloads are broadcast to specialized `AnalyzerModule` instances running concurrently. This map-reduce execution strategy prevents isolate blocking while performing computationally expensive evaluations.

- **UrlThreatAnalyzer:** Conducts deep protocol validation, typo-squatting distance analysis, and cross-references unsafe TLDs statistically overrepresented in scam infrastructure.
- **EntropyAnalyzer:** Employs Shannon Entropy calculations on core domains to identify programmatic DGA (Domain Generation Algorithm) characteristics. Highly randomized domains (Entropy > 3.8) are immediately flagged as disposable scam infrastructure.
- **NlpScamAnalyzer:** Utilizes word-boundary regex and semantic manipulation detection to identify artificial urgency, financial extortion patterns, and illegitimate employment routing.

### Computational Risk Modeling & Asymptotic Decay
Risk aggregation utilizes an advanced decay algorithm rather than linear subtraction. 
`Trust = Base * e^(-k * totalPenalty)`
This prevents mathematical overflow during compounding threat signals, ensuring that multiple high-risk indicators push the final trust score asymptotically toward zero without breaking constraints.

### Explainable AI (XAI) Engine
A core innovation of TruthLens is its Explainability Engine. Security alerts are useless without context. The XAI module converts weighted severity signatures into precise, human-readable intelligence reports, detailing specific **Evidence** and actionable **Mitigations**, sorted by critical threat priority.

## 3. Threat Intelligence Workflow
1. **Ingestion & Sanitization:** Multi-modal data (text, URLs, extracted OCR documents) is ingested and normalized.
2. **Primary Neural Evaluation:** Payload is securely transmitted to the cloud-based AI classifier for deep semantic contextualization and intent recognition.
3. **Secondary Heuristic Orchestration (Failover/Augmentation):** Concurrently, the offline Intelligence Engine calculates Shannon Entropy, evaluates URL entropy, and matches strict structural signatures.
4. **Threat Signal Aggregation:** Signals from both engines are deduplicated, normalized, and weighted based on their confidence intervals.
5. **Actionable Output:** The XAI Engine renders the aggregated signals into an `IntelligenceReport`, blocking malicious intent before user engagement.

## 4. Scalability & Performance Optimization
- **Concurrent Execution:** Analyzers utilize `Future.wait` to execute heuristic calculations in parallel, ensuring sub-100ms response times on the edge.
- **Stateless Backend:** The Node.js proxy layer is entirely stateless, allowing horizontal scaling via Kubernetes or serverless container environments.
- **Dependency Injection:** The `FraudIntelligenceEngine` is completely decoupled from its underlying analyzers. Scaling the rule set involves injecting new modules (e.g., ImageHashAnalyzer, SmsReputationAnalyzer) without modifying the orchestration logic.

## 5. Security Engineering & Data Privacy
- **Zero-Trust Input Validation:** All inputs are heavily sanitized before evaluation to prevent injection attacks against the heuristic engine.
- **Forbidden Header Omission:** API integrations strip CORS-triggering headers (e.g., `HTTP-Referer`) for secure, seamless cross-origin web execution.
- **Ephemeral State:** The conversational AI context window is aggressively pruned (limited to 10 nodes) to prevent memory leaks and contextual poisoning.

## 6. Strategic Roadmap: Scaling Threat Intelligence

The TruthLens development trajectory is focused on transitioning from edge-based detection to a global, interconnected cybersecurity ecosystem. Our roadmap is divided into three strategic phases designed for venture-scale expansion and enterprise-grade resilience.

### Phase I: Advanced Behavioral Analysis & OSINT Enrichment (Q3 2026)
*   **Behavioral Anomaly Detection:** Implementation of zero-trust behavioral modeling to detect subtle social engineering patterns that bypass static heuristic filters.
*   **OSINT Enrichment Pipeline:** Integration of Open-Source Intelligence (OSINT) feeds to cross-reference reported entities against global databases of known threat actors and malicious infrastructure.
*   **Multilingual NLP Expansion:** Scaling the NLPScamAnalyzer to support 15+ regional languages using localized transformer models for nuanced threat detection in non-English communications.

### Phase II: Scam Graph Analytics & Federated Intelligence (Q4 2026)
*   **Scam Graph Analysis:** Deployment of a graph-based database (Neo4j/ArangoDB) to map relationships between disparate scam reports. This identifies organized fraud rings by correlating shared UPI IDs, phone numbers, and domain infrastructure.
*   **Federated Learning Infrastructure:** Transitioning to a privacy-preserving Federated Learning model where threat intelligence is refined on-device and synchronized across the network without exposing sensitive user data.
*   **Distributed Threat Synchronization:** Real-time, peer-to-peer synchronization of high-confidence threat signatures to ensure edge clients remain protected even in air-gapped or low-connectivity environments.

### Phase III: Enterprise Ecosystem & SIEM Integration (2027)
*   **SIEM/SOC Dashboard Integration:** Exposing standardized REST APIs and webhooks for seamless integration into enterprise Security Information and Event Management (SIEM) systems and Security Operations Centers (SOC).
*   **Adaptive Phishing Detection:** Implementation of reinforcement learning pipelines that retrain models in real-time based on successful "near-miss" interceptions, ensuring the engine stays ahead of evolving adversarial tactics.
*   **Enterprise Admin Console & Risk Telemetry:** A centralized dashboard for organizational security officers to monitor real-time risk telemetry across distributed employee endpoints, facilitating rapid incident response.
*   **Cross-Platform Extension Ecosystem:** Deployment of browser extensions and OS-level hooks to provide a unified threat-detection layer across all user entry points (Web, Desktop, and Mobile).

---

*TruthLens: Engineering a fraud-free digital future through computational rigor and venture-scale intelligence.*

## Quick Start (Development Environment)

```bash
# Clone the repository
git clone <repository_url>
cd TruthLens

# Retrieve dependencies
flutter pub get

# Execute with injected Cloud Intelligence Key
flutter run --dart-define=OPENROUTER_API_KEY=<ENTERPRISE_KEY>
```

*TruthLens: Computational rigor meets actionable intelligence.*