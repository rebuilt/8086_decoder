Performance-Aware Programming Series
This series is designed for programmers who know how to write programs, but don’t know how hardware runs those programs. It’s designed to bring you up to speed on how modern CPUs work, how to estimate the expected speed of performance-critical code, and the basic optimization techniques every programmer should know.

The course is broken into parts, with the first part (the “prologue”) being strictly a demonstration with no associated homework. Later parts feature weekly homework.

Q&A videos are posted regularly. If you have a question you’d like answered, please put it in the comments of the most recent Q&A video. Homework listings are available from github.

Prologue: The Five Multipliers (3 1/2 hours, no homework)

This part of the course gives simple demonstrations of how seemingly minor code changes can produce dramatically different software performance, even for very simple operations.

Welcome to the Performance-Aware Programming Series! (22:05)

Waste (32:56)

Instructions Per Clock (25:05)

Single Instruction, Multiple Data (35:31)

Caching (22:55)

Multithreading (32:11)

Python Revisited (36:22)

Interlude (1 hour, no homework)

The Haversine Distance Problem (30:28)

“Clean” Code, Horrible Performance (22:40)

Part 1: Reading ASM (7 hours, plus homework)

This part of the course is designed to ensure that everyone taking the course has a solid understanding of how a CPU works at the assembly-language level.

Instruction Decoding on the 8086 (28:28)

Decoding Multiple Instructions and Suffixes (43:51)

Opcode Patterns in 8086 Arithmetic (20:01)

8086 Decoder Code Review (1:17:49)

Using the Reference Decoder as a Shared Library (8:48)

Simulating Non-memory MOVs (18:00)

Simulating ADD, SUB, and CMP (25:56)

Simulating Conditional Jumps (19:41)

Simulating Memory (26:32)

Simulating Real Programs (16:02)

Other Common Instructions (19:43)

The Stack (26:58)

Estimating Cycles (23:56)

From 8086 to x64 (26:21)

8086 Simulation Code Review (33:05)

Part 2: Basic Profiling (4 hours, plus homework)

In this part of the course, we learn about how to measure time, and instrument programs to automatically determine where time is being spent.

Generating Haversine Input JSON (15:40)

Writing a Simple Haversine Distance Processor (12:09)

Initial Haversine Processor Code Review (29:22)

Introduction to RDTSC (48:05)

How does QueryPerformanceCounter measure time? (31:43)

Instrumentation-Based Profiling (18:01)

Profiling Nested Blocks (26:12)

Profiling Recursive Blocks (30:44)

A First Look at Profiling Overhead (18:37)

Comparing the Overhead of RDTSC and QueryPerformanceCounter (13:00)

Part 3: Moving Data (13 hours, plus homework, and 3 hours of bonus content)

Using our knowledge from parts 1 and 2, in Part 3 we look at how data moves into the CPU, and how to estimate the upper performance limits of our software imposed by the need to move data.

Measuring Data Throughput (21:54)

Repetition Testing (27:57)

Monitoring OS Performance Counters (20:25)

Page Faults (38:52)

Probing OS Page Fault Behavior* (33:05)

Four-Level Paging* (31:23)

Analyzing Page Fault Anomalies* (31:44)

Powerful Page Mapping Techniques* (39:20)

Faster Reads with Large Page Allocations (25:52)

Memory-Mapped Files* (20:46)

Inspecting Loop Assembly (32:31)

Intuiting Latency and Throughput (22:57)

Analyzing Dependency Chains (29:06)

Linking Directly to ASM for Experimentation (48:07)

CPU Front End Basics (31:09)

Branch Prediction (42:03)

Code Alignment (32:03)

The RAT and the Register File (45:21)

Execution Ports and the Scheduler (34:51)

Increasing Read Bandwidth with SIMD Instructions (37:52)

Cache Size and Bandwidth Testing (34:00)

Non-Power-of-Two Cache Size Testing (35:15)

Latency and Throughput, Again (37:55)

Unaligned Load Penalties (27:25)

Cache Sets and Indexing (30:34)

Non-Temporal Stores (28:11)

Prefetching (21:31)

Prefetching Wrap-up (19:40)

A Closer Look at the Prefetching Performance Graph* (33:38)

2x Faster File Reads (31:01)

Overlapping File Reads with Computation (20:35)

Testing Memory-Mapped Files* (18:03)

* Entries with an asterisk were “bonus” entries that can be skipped.

Part 4: Computation

Part 4 extends the techniques learned in Part 3 from memory operations to computation more broadly. We look at what kinds of operations CPUs perform natively, how more complicated operations are broken down into native ones, and how to reason about the peak performance of computational processes.

Reference Haversine Code (19:49)

Identifying Non-inlined Math Functions (19:27)

Determining Input Ranges (14:37)

Introduction to SSE Intrinsics (48:51)

Function Approximation (56:28)

Range Reduction (16:32)

Approximation Using Higher-Power Polynomials (25:04)

Part 4 is still in progress. This listing will be updated as new videos are posted.

The Computer Enhance 2024 International Event Tracing for Windows Halloween Spooktacular Challenge
Announcing the 2024 Halloween Spooktacular Challenge!

Day 1: The Challenge

Day 2: Reboot Your Machine

Day 3: Trace in Real-Time Mode

Day 4: Use TraceQueryInformation

Day 5: Call TraceSetInformation Twice

Day 6: PMCs Only Work for A Subset of Event Types

Day 7: Look for PMCs in the ExtendedData

Day 8: Mārtiņš Možeiko's Miniperf

Day 9: What's Left?

Day 10: Use TraceEvent

Day 11: Define Your Own Event UserData

Day 12: Find Another PMC Event Type

Day 13: Use SysCallExit to Mark Start Points

Day 14: Use SysCallEnter to Mark Stop Points

Day 15: Use GetEventProcessorIndex to Help Track Profile Regions

Real-time PMCs on Windows with ETW

1994 Internship Interview Series
The Four Programming Questions from My 1994 Microsoft Internship Interview (19:02)

Question #1: Rectangle Copy (24:50)

Question #2: String Copy (14:50)

Question #3: Flood Fill Detection (23:58)

Question #4: Outline a Circle (1:09:01)
