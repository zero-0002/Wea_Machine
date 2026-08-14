from protocol_map import (
    DELTA_ASD_A2_REGISTERS,
    Register,
    format_register_table,
    get_register,
    validate_register_map,
)


def test_core_registers_present():
    for name in ("encoder_puu", "path_data_1", "di_force_enable", "alarms"):
        reg = get_register(name)
        assert reg.name == name
        assert 0 <= reg.address <= 0xFFFF


def test_validate_default_map_ok():
    assert validate_register_map() == []


def test_validate_detects_duplicate_address():
    regs = [
        Register("a", 0x10, "first"),
        Register("b", 0x10, "second"),
    ]
    problems = validate_register_map(regs)
    assert any("duplicate" in p for p in problems)


def test_format_register_table_contains_header():
    table = format_register_table()
    assert "Name | Address" in table
    assert "path_data_1" in table
    assert len(DELTA_ASD_A2_REGISTERS) >= 8
