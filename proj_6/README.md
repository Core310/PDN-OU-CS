# Project 6: MapReduce and Network Programming

## Overview
This project involves implementing a MapReduce word analyzer using `mrjob` and creating TCP/UDP multiplication servers.

## Implementation Plan

### Phase 1: Environment & Setup (Completed)
- Set up Python virtual environment and install `mrjob`.
- Prepare directory structure and data files.

### Phase 2: Problem 1 - MapReduce (Completed)
- Implement `find_longest_words_MRJob.py` in `Problem_1/`.
- Uses `re.findall(r'[a-zA-Z]+', line)` for case-insensitive extraction.
- Uses a Combiner for local aggregation.
- Returns a sorted list of the longest words per letter.

### Phase 3: Problem 2 - Network Programming (Current)
**Goal:** Implement TCP and UDP client-server pairs that multiply a list of numbers.

**TCP Implementation:**
- **Server (`Problem_2/TCPServer_multiply.py`):**
    - Port: 5050, IP: 127.0.0.1.
    - Uses `socketserver.ThreadingTCPServer` for robustness.
    - Parses comma-separated input, calculates product, and returns result or "Invalid input".
- **Client (`Problem_2/TCPClient_multiply.py`):**
    - Connects to server, prompts user for input, and prints response.

**UDP Implementation:**
- **Server (`Problem_2/UDPServer_multiply.py`):**
    - Port: 5051, IP: 127.0.0.1.
    - Uses `socketserver.ThreadingUDPServer`.
    - Same logic for parsing and multiplication.
- **Client (`Problem_2/UDPClient_multiply.py`):**
    - Sends datagram to server and waits for response.

**Validation:**
- Test with valid numeric lists (ints, floats, negative numbers).
- Test with invalid input (letters, symbols, empty strings) to verify "Invalid input" response.

### Phase 4: Finalization
- Create final report.
- Zip project structure for submission.
