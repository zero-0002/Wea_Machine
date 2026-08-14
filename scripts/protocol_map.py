"""Delta ASD-A2 Modbus register map helpers used by WeaMachine docs/Protocol.txt."""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Iterable, List, Optional


@dataclass(frozen=True)
class Register:
    name: str
    address: int
    description: str
    access: str = "RW"  # R, W, RW


# Core registers referenced by ServoModbusDevice / docs/Protocol.txt
DELTA_ASD_A2_REGISTERS: Dict[str, Register] = {
    "di_status": Register("di_status", 0x0108, "Digital input status", "R"),
    "do_status": Register("do_status", 0x0109, "Digital output status", "R"),
    "encoder_puu": Register("encoder_puu", 0x0000, "Encoder position PUU (low/high pair)", "R"),
    "path_data_1": Register("path_data_1", 0x1702, "Internal path position P1-26/P1-27", "RW"),
    "speed_data_0": Register("speed_data_0", 0x170A, "Speed command data 0", "RW"),
    "ramp_data_0": Register("ramp_data_0", 0x170C, "Acc/Dec ramp data 0", "RW"),
    "jog_speed": Register("jog_speed", 0x010E, "JOG speed", "RW"),
    "alarms": Register("alarms", 0x0100, "Alarm code", "R"),
    "di_force_enable": Register("di_force_enable", 0x030B, "Enable DI force via serial", "RW"),
    "di_force_value": Register("di_force_value", 0x030C, "Forced DI bit pattern", "RW"),
}


SERVO_COM_DEFAULTS = {
    "mode": "RTU",
    "baudrate": 115200,
    "bytesize": 8,
    "parity": "O",
    "stopbits": 1,
    "x_slave": 2,
    "y_slave": 3,
}


def get_register(name: str) -> Register:
    try:
        return DELTA_ASD_A2_REGISTERS[name]
    except KeyError as exc:
        known = ", ".join(sorted(DELTA_ASD_A2_REGISTERS))
        raise KeyError(f"Unknown register '{name}'. Known: {known}") from exc


def validate_register_map(registers: Optional[Iterable[Register]] = None) -> List[str]:
    """Return human-readable problems found in the register map."""
    regs = list(registers) if registers is not None else list(DELTA_ASD_A2_REGISTERS.values())
    problems: List[str] = []
    seen_addresses = {}

    for reg in regs:
        if reg.address < 0 or reg.address > 0xFFFF:
            problems.append(f"{reg.name}: address 0x{reg.address:X} out of Modbus range")
        if not reg.name:
            problems.append("register with empty name")
        if reg.access not in {"R", "W", "RW"}:
            problems.append(f"{reg.name}: invalid access '{reg.access}'")
        if reg.address in seen_addresses and seen_addresses[reg.address] != reg.name:
            problems.append(
                f"duplicate address 0x{reg.address:X}: {seen_addresses[reg.address]} vs {reg.name}"
            )
        else:
            seen_addresses[reg.address] = reg.name

    return problems


def format_register_table(registers: Optional[Dict[str, Register]] = None) -> str:
    regs = registers or DELTA_ASD_A2_REGISTERS
    lines = ["Name | Address | Access | Description", "---- | ------- | ------ | -----------"]
    for key in sorted(regs):
        reg = regs[key]
        lines.append(f"{reg.name} | 0x{reg.address:04X} | {reg.access} | {reg.description}")
    return "\n".join(lines)


def main() -> int:
    problems = validate_register_map()
    print(format_register_table())
    print()
    if problems:
        print("Validation FAILED:")
        for problem in problems:
            print(f"  - {problem}")
        return 1
    print("Validation OK: register map is consistent.")
    print(
        "Default COM: {mode} {baudrate} {bytesize}{parity}{stopbits}, "
        "slaves X={x_slave} Y={y_slave}".format(**SERVO_COM_DEFAULTS)
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
