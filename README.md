# Multi-Mode Embedded System
Multi-mode embedded system on 8051 Assembly featuring real-time polling, 16-bit arithmetic, and buffered I/O interfacing.

This project implements a multi-mode embedded system built around the 8051 microcontroller, designed to demonstrate low-level assembly language programming, real-time control, and peripheral interfacing on a single unified platform. The system operates across four distinct operational modes—performing 16-bit kinematic calculations, cylinder volume computations, software-based PWM LED intensity visualization, and prime/composite number detection—all selectable dynamically via DIP switches on Port 3 without requiring a system reset.
     Microcontroller Core: Driven by an 8051 microcontroller running at 11.0592 MHz, yielding a machine cycle time of approximately 1.085µs for calibrated delay generation and synchronized instruction execution. 
     
     Input Interface: 8-bit input data is supplied via DIP switches on Port 1, with real-time mode selection controlled via pins P3.0 and P3.1.

     Output & Interfacing: Computational outputs, visual patterns, and 16-bit data splits (low-byte on Port 0, high-byte on Port 2) drive 16 external LEDs.

     Hardware Protection & Buffering: Two 74LS245 octal tri-state bus transceivers isolate the microcontroller pins and supply necessary current amplification to drive the LED arrays safely.

     Architecture: Written entirely in non-interrupt-driven 8051 Assembly (ASM51) using a fast polling loop (<100 µs response time) for immediate mode transitions, direct register arithmetic, internal ROM lookup tables, and inline 16-bit Timer 0 configurations.