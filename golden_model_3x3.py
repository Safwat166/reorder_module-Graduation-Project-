"""
Golden Model — Reorder Module, Filter 3×3
==========================================
Simulates all register operations exactly as the RTL does.
You provide the 4 register initial values; the script shows
every cycle's register state and PE array output.

Usage
-----
Run directly and enter hex values when prompted, or call
simulate_3x3(regA, regB, regC, regD) from your own script.

Input format
------------
Each register is 16 bytes (128 bits), entered as a 32-character
hex string, MSB first.
Example: 0102030405060708090a0b0c0d0e0f10
"""


# ─────────────────────────────────────────────────────────────────
# Low-level register operations  (match RTL bit-exactly)
# ─────────────────────────────────────────────────────────────────

def shift_left(reg: bytes) -> bytes:
    """
    Shift register left by 1 byte.
    RTL: reg[127:0] = {reg[119:0], 8'h00}
    Drop MSB, append 0x00 at LSB.
    """
    return reg[1:] + bytes(1)


def out(reg: bytes) -> bytes:
    """
    wire_out[127:16] = upper 14 bytes of the 16-byte register.
    This is what gets sent to the PE array.
    """
    return reg[:14]


def reg_e_pipeline(out_b_history: list) -> bytes:
    """
    RegisterE is a 2-stage pipeline of out_B.
      stage1 ← out_B      (captured this cycle)
      stage2 ← stage1     (one cycle later)
      out_to_A = stage2   (available to RegA two cycles after capture)

    out_b_history: list of out_B values captured so far (oldest first).
    Returns the value RegA would receive if valid_up_A fires this cycle.
    Returns 14 zero bytes if fewer than 2 previous captures exist.
    """
    if len(out_b_history) < 2:
        return bytes(14)
    return out_b_history[-2]            # value from 2 cycles ago


# ─────────────────────────────────────────────────────────────────
# Pretty-print helpers
# ─────────────────────────────────────────────────────────────────

def hex_str(b: bytes) -> str:
    return b.hex()


def print_separator(char="─", width=72):
    print(char * width)


def print_register_state(label, A, B, C, D, indent="  "):
    print(f"{indent}RegA = {hex_str(A)}")
    print(f"{indent}RegB = {hex_str(B)}")
    print(f"{indent}RegC = {hex_str(C)}")
    print(f"{indent}RegD = {hex_str(D)}")


# ─────────────────────────────────────────────────────────────────
# Core simulation
# ─────────────────────────────────────────────────────────────────

def simulate_3x3(reg_A_init: bytes,
                 reg_B_init: bytes,
                 reg_C_init: bytes,
                 reg_D_init: bytes,
                 verbose: bool = True) -> list:
    """
    Simulate the 9-cycle 3×3 subfilter sequence.

    Cycle-by-cycle operations (from valid_logic.v cnt 0..8):

      cnt 0 : valid_left_A=1, valid_left_B=1
                RegA ← shift_left(RegA)
                RegB ← shift_left(RegB)

      cnt 1 : valid_left_A=1, valid_left_B=1
                RegA ← shift_left(RegA)
                RegB ← shift_left(RegB)

      cnt 2 : valid_up_A=1, valid_up_B=1
                RegA ← RegE_out  (= out_B captured at cnt=0)
                RegB ← RegC      (sel_C_D=0)

      cnt 3 : valid_up_A=1, valid_left_B=1
                RegA ← RegE_out  (= out_B captured at cnt=1)
                RegB ← shift_left(RegB)

      cnt 4 : valid_up_A=1, valid_left_B=1
                RegA ← RegE_out  (= out_B captured at cnt=2)
                RegB ← shift_left(RegB)

      cnt 5 : valid_up_A=1, valid_up_B=1
                RegA ← RegE_out  (= out_B captured at cnt=3)
                RegB ← RegD      (sel_C_D=1)

      cnt 6 : valid_up_A=1, valid_left_B=1
                RegA ← RegE_out  (= out_B captured at cnt=4)
                RegB ← shift_left(RegB)

      cnt 7 : valid_up_A=1, valid_left_B=1
                RegA ← RegE_out  (= out_B captured at cnt=5)
                RegB ← shift_left(RegB)

      cnt 8 : valid_reuse=1
                (for 3×3: no reuse action needed — end of operation)

    RegC and RegD are STATIC throughout the 9 cycles.
    RegisterE pipeline delay = 2 cycles (output seen 2 cycles after capture).

    Parameters
    ----------
    reg_A_init, reg_B_init, reg_C_init, reg_D_init : bytes
        16-byte initial register values (MSB first).

    verbose : bool
        Print full register state and PE output for every cycle.

    Returns
    -------
    list of 9 dicts, one per cycle:
        {
          'cnt'       : int,
          'out_A'     : bytes  (14 bytes sent to PE row 0),
          'out_B'     : bytes  (14 bytes sent to PE row 1),
          'reg_A'     : bytes  (full 16-byte RegA at START of cycle),
          'reg_B'     : bytes  (full 16-byte RegB at START of cycle),
          'reg_C'     : bytes  (constant),
          'reg_D'     : bytes  (constant),
          'reg_E_out' : bytes  (14 bytes RegE delivers to RegA, or zeros),
          'operation' : str    (human-readable description),
        }
    """

    A = bytearray(reg_A_init)
    B = bytearray(reg_B_init)
    C = bytearray(reg_C_init)   # static
    D = bytearray(reg_D_init)   # static

    # RegE: 2-stage pipeline. We keep a history of out_B values.
    # out_B captured at cycle N is available to RegA at cycle N+2.
    out_b_history = []

    results = []

    # Operation labels for each cnt
    operations = {
        0: "left_A + left_B",
        1: "left_A + left_B",
        2: "up_A (←RegE[cnt=0]) + up_B (←RegC)",
        3: "up_A (←RegE[cnt=1]) + left_B",
        4: "up_A (←RegE[cnt=2]) + left_B",
        5: "up_A (←RegE[cnt=3]) + up_B (←RegD, sel_C_D=1)",
        6: "up_A (←RegE[cnt=4]) + left_B",
        7: "up_A (←RegE[cnt=5]) + left_B",
        8: "valid_reuse (end of subfilter — no shift for 3×3)",
    }

    if verbose:
        print_separator("═")
        print("  3×3 FILTER GOLDEN MODEL")
        print_separator("═")
        print("\n  Initial register values:")
        print_register_state("initial", A, B, C, D)
        print()

    for cnt in range(9):

        # ── 1. Capture outputs BEFORE this cycle's update ─────────────────
        out_a = out(bytes(A))
        out_b = out(bytes(B))
        reg_e_out = reg_e_pipeline(out_b_history)

        # ── 2. Record result ──────────────────────────────────────────────
        result = {
            'cnt'       : cnt,
            'out_A'     : out_a,
            'out_B'     : out_b,
            'reg_A'     : bytes(A),
            'reg_B'     : bytes(B),
            'reg_C'     : bytes(C),
            'reg_D'     : bytes(D),
            'reg_E_out' : reg_e_out,
            'operation' : operations[cnt],
        }
        results.append(result)

        # ── 3. Print cycle summary ─────────────────────────────────────────
        if verbose:
            print_separator()
            print(f"  cnt = {cnt}  |  {operations[cnt]}")
            print_separator()
            print(f"  Register state at START of cycle:")
            print_register_state("", A, B, C, D)
            if cnt >= 2:
                print(f"  RegE delivers: {hex_str(reg_e_out)}"
                      f"  (= out_B from cnt={cnt-2})")
            print(f"\n  ► out_A → PE row 0 : {hex_str(out_a)}")
            print(f"  ► out_B → PE row 1 : {hex_str(out_b)}")

        # ── 4. Update RegE pipeline (capture current out_B) ───────────────
        out_b_history.append(out_b)

        # ── 5. Apply this cycle's register updates ────────────────────────
        if cnt in (0, 1):
            # Both shift left
            A = bytearray(shift_left(bytes(A)))
            B = bytearray(shift_left(bytes(B)))

        elif cnt == 2:
            # RegA ← RegE output (out_B from cnt=0)
            # RegB ← RegC  (sel_C_D=0)
            A = bytearray(reg_e_out + bytes(2))   # 14 + 2 padding = 16
            B = bytearray(C)

        elif cnt in (3, 4):
            # RegA ← RegE output
            # RegB ← shift_left
            A = bytearray(reg_e_out + bytes(2))
            B = bytearray(shift_left(bytes(B)))

        elif cnt == 5:
            # RegA ← RegE output
            # RegB ← RegD  (sel_C_D=1)
            A = bytearray(reg_e_out + bytes(2))
            B = bytearray(D)

        elif cnt in (6, 7):
            # RegA ← RegE output
            # RegB ← shift_left
            A = bytearray(reg_e_out + bytes(2))
            B = bytearray(shift_left(bytes(B)))

        elif cnt == 8:
            # valid_reuse fires but for 3×3 no register update needed
            pass

        # ── 6. Print register state AFTER update ─────────────────────────
        if verbose and cnt < 8:
            print(f"\n  Register state AFTER update:")
            print_register_state("", A, B, C, D)
            print()

    # ── Final summary ─────────────────────────────────────────────────────
    if verbose:
        print_separator("═")
        print("  COMPLETE — all 9 output pairs")
        print_separator("═")
        print(f"\n  {'cnt':>3}  {'out_A (→ PE row 0)':32}  {'out_B (→ PE row 1)'}")
        print(f"  {'---':>3}  {'-------------------------------':32}  "
              "-------------------------------")
        for r in results:
            print(f"  {r['cnt']:>3}  {hex_str(r['out_A'])}"
                  f"  {hex_str(r['out_B'])}")

        print()
        print("  Sliding window interpretation:")
        print("  cnt 0-2 : row0 × row1  (left shift, 3 column positions)")
        print("  cnt 3-5 : row1 × row2  (RegE → RegA, RegC → RegB)")
        print("  cnt 6-8 : row2 × row3  (RegE → RegA, RegD → RegB)")
        print()

    return results


# ─────────────────────────────────────────────────────────────────
# Input parsing
# ─────────────────────────────────────────────────────────────────

def parse_hex_register(prompt: str) -> bytes:
    """
    Prompt the user for a 32-char hex string and return 16 bytes.
    Accepts upper/lower case and ignores spaces or underscores.
    """
    while True:
        raw = input(prompt).strip().replace(" ", "").replace("_", "")
        if len(raw) != 32:
            print(f"  ✗ Expected 32 hex characters (16 bytes), got {len(raw)}."
                  " Try again.")
            continue
        try:
            value = bytes.fromhex(raw)
            return value
        except ValueError:
            print("  ✗ Invalid hex string. Try again.")


# ─────────────────────────────────────────────────────────────────
# Entry point
# ─────────────────────────────────────────────────────────────────

if __name__ == "__main__":

    print("╔══════════════════════════════════════════════════════════════════╗")
    print("║        Reorder Module Golden Model  —  Filter 3×3               ║")
    print("╠══════════════════════════════════════════════════════════════════╣")
    print("║  Enter each register as a 32-character hex string (16 bytes).   ║")
    print("║  MSB first. Example: 0102030405060708090a0b0c0d0e0f10           ║")
    print("╚══════════════════════════════════════════════════════════════════╝")
    print()

    regA = parse_hex_register("  RegA (row 0) → ")
    regB = parse_hex_register("  RegB (row 1) → ")
    regC = parse_hex_register("  RegC (row 2) → ")
    regD = parse_hex_register("  RegD (row 3) → ")

    print()
    simulate_3x3(regA, regB, regC, regD, verbose=True)