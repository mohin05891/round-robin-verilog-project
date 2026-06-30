# Weighted Round Robin Arbiter - Complete Visual Report

This repository contains the complete description, Finite State Machine (FSM) logic, request-zero fallback behavior, simulation steps, and waveform analysis for the Weighted Round Robin (WRR) Arbiter.

---

## 1. Design Summary

The arbiter manages four request inputs and grants access to four corresponding master outputs using a weighted round-robin scheduling algorithm.

* **Inputs:** Four request inputs (`req0` to `req3`).
* **Outputs:** Four one-hot grant outputs (`master0` to `master3`).
* **Weights Configuration:** `master0` has a weight of **4**, while `master1`, `master2`, and `master3` each have a weight of **1**.

> 📌 **Key Behavior:** When all request signals are active simultaneously, `master0` receives four consecutive turns before the arbiter moves to the next request.

### Grant Sequence (Weight 4:1:1:1)
When all requests remain high, the arbitration cycle follows this sequence:
`M0` → `M0` → `M0` → `M0` → `M1` → `M2` → `M3` → *(Repeats back from M0)*

---

## 2. FSM Diagram & Conditions

The Finite State Machine (FSM) transitions based on the status of the request lines:
* **Forward Progress (Green arrows):** Occurs when a request is `1`, moving the FSM forward.
* **Fallback Behavior (Red arrows):** Occurs when a request is `0`, causing the FSM to return to the initial state `S0`.

### FSM State Transition Table

| Condition | FSM Action |
| :--- | :--- |
| `req0 = 0` in `S0` | Stay in `S0`, reset count, and do not grant `master0`. |
| `req0 = 1` and `count < 3` in `S0` | Stay in `S0` and continue granting `master0`. |
| `req1 = 1` after `M0` finishes | Move from `S0` to `S1`. |
| `req1 = 0` after `M0` finishes | Return or stay in `S0`[cite: 1]. |
| `req2 = 1` in `S1` | Move from `S1` to `S2`[cite: 1]. |
| `req2 = 0` in `S1` | Return to `S0`[cite: 1]. |
| `req3 = 1` in `S2` | Move from `S2` to `S3`[cite: 1]. |
| `req3 = 0` in `S2` | Return to `S0`[cite: 1]. |
| After `S3` | Always return unconditionally to `S0`[cite: 1]. |

---

## 3. How to Run in EDA Playground

To verify the design, follow these simulation steps[cite: 1]:

1. Open **EDA Playground**.
2. Paste the hardware description code (`arbiter.v`) into the **Design** section[cite: 1].
3. Paste the testbench code (`arbiter_tb.v`) into the **Testbench** section[cite: 1].
4. Select a Verilog simulator (e.g., **Icarus Verilog**) and click **Run**[cite: 1].

The testbench generates the waveform file using the following system tasks[cite: 1]:
```verilog
$dumpfile("weighted_rr.vcd");
$dumpvars(0, tb_weighted_rr_arbiter);
