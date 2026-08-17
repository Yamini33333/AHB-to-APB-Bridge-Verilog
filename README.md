# AHB-to-APB Bridge using Verilog HDL

## Overview

Designed and implemented an RTL-based AHB-to-APB Bridge using Verilog HDL based on the AMBA protocol.

The bridge enables communication between the high-performance AHB bus and the low-power APB bus using FSM-based control logic.

## Features

- AMBA AHB-to-APB protocol conversion
- Verilog RTL design
- FSM-based control logic
- Single read and write transfers
- Burst transfer handling
- Address mapping between AHB and APB
- Simulation and functional verification

## Architecture

The bridge consists of:

- AHB Master Interface
- AHB Slave Interface
- APB Interface
- APB Controller
- FSM Control Logic
- Address and Data Transfer Logic

## Working

1. AHB master initiates a read or write transaction.
2. The bridge receives and decodes the AHB transaction.
3. The control FSM generates the required APB signals.
4. APB performs the corresponding read or write operation.
5. The response and read data are transferred back to the AHB side.

## Verification

The design was verified through simulation for:

- Single Write Transfer
- Single Read Transfer
- Burst Write Transfer
- Burst Read Transfer

## Tools & Technologies

- Verilog HDL
- AMBA AHB/APB
- RTL Design
- FSM
- Simulation and Verification

## Author

**Yamini**
