# Project 6 Report: MapReduce and Network Programming
**Name:** Arika Khor
**Date:** April 20, 2026

## Problem 1: MapReduce Word Length Analyzer

### Implementation Details
The goal was to find the longest words starting with each letter (a-z) in a large text file (`1342-0.txt`).
- **Framework:** `mrjob` was used for the MapReduce implementation.
- **Word Extraction:** `re.findall(r'[a-zA-Z]+', line)` was used to extract words, automatically ignoring punctuation, numbers, and the UTF-8 BOM.
- **Efficiency:** A **Combiner** was implemented to perform local aggregation, reducing the volume of data sent across the network to the Reducer.
- **Tie-Handling:** The Reducer collects all words matching the maximum length for a given letter and returns them as an alphabetically sorted list.

### Results
The script was run against `1342-0.txt` (Pride and Prejudice). Key results included:
- **'r':** `["recommendations"]`
- **'s':** `["superciliousness"]`
- **'t':** `["thoughtlessness"]`
- **'g':** `["gentlemanlike", "gratification"]`

---

## Problem 2: Network Programming - Multiplication Servers

### Implementation Details
I implemented two pairs of client-server applications using TCP and UDP protocols.
- **Servers:** Used `socketserver.ThreadingTCPServer` and `socketserver.ThreadingUDPServer`. These provide high robustness, handle concurrent clients, and utilize `SO_REUSEADDR` for immediate port rebinding.
- **Logic:** A shared helper function `calculate_product` parses comma-separated numeric strings (handling integers and floats) and calculates their product using `math.prod()`.
- **Error Handling:** Inputs containing non-numeric characters or empty strings return exactly `"Invalid input"`.
- **Ports:** 5050 (TCP) and 5051 (UDP) on `127.0.0.1`.

### Verification Results
Both protocols were verified with the following test cases:
1. **Valid Integers:** `1, 2, 3` -> `6`
2. **Floats:** `1.5, 2` -> `3.0`
3. **Invalid Input:** `abc, 1` -> `Invalid input`
4. **Empty/Whitespace:** ` ` -> `Invalid input`

The servers successfully handled all cases and maintained connection stability throughout the tests.

---

## Conclusion
The project successfully demonstrated the power of MapReduce for large-scale text processing and the reliability of Python's socket programming for client-server communication. Both problems were implemented with robust error handling and verified against the provided requirements.

## Security Considerations & Future Enhancements
While the current implementation fulfills the transport-layer requirements of the assignment, a production-ready "Cloud Multiplication Service" would require additional security layers:

*   **TLS/SSL:** The most robust way to add security is to wrap the TCP socket using Python's `ssl` module. This provides an encrypted handshake and ensures the data cannot be read in transit (Privacy and Integrity).
*   **Application-Layer Handshake:** We could implement a simple "Auth" step where the client sends a token/password (or a PAKE like **SPAKE2**) before the server accepts numbers for calculation. This prevents unauthorized access to the server's CPU resources.
*   **Project Context:** In an introductory network programming context, basic sockets are used to demonstrate the fundamental differences between TCP (connection-oriented) and UDP (connectionless). For a "production-ready" deployment, TLS for TCP is considered mandatory.
*   **UDP Security (DTLS):** UDP is more challenging to secure with a handshake because it is connectionless. In a real-world scenario, we would implement **DTLS (Datagram TLS)** to provide similar security guarantees as TLS for the UDP stream.
