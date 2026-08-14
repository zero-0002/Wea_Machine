# Contributing to WeaMachine

Thanks for helping improve this industrial automation HMI.

## Ways to contribute

- Fix bugs listed in GitHub Issues (preferred over `TODO.txt`)
- Improve docs, build scripts, or CI
- Add tests for models (`StepModel`, `PlcIOModel`, `RecordModel`)
- Review pull requests and leave concrete feedback

## Development setup

1. Install Qt 5.15+ or Qt 6 with modules: Core, Quick, Qml, QuickControls2, SerialBus, SerialPort
2. Install CMake 3.16+ and a C++17 toolchain (MSVC, MinGW, or Clang)
3. Configure and build:

```bash
cmake -S . -B build -DCMAKE_PREFIX_PATH=<path-to-Qt>
cmake --build build
```

4. Optional protocol helpers (Python 3.9+):

```bash
python -m pip install -r scripts/requirements.txt
python -m pytest scripts/tests
```

## Pull request checklist

- [ ] Change is focused (one concern per PR when possible)
- [ ] Build still configures with CMake
- [ ] QML/C++ naming stays consistent with existing modules
- [ ] No hardcoded secrets or machine credentials in source
- [ ] Update README / issues when behavior changes

## Code style

- Match surrounding C++ / QML style in the file you edit
- Prefer WeaCore logging over raw `qDebug()` for new code
- Avoid drive-by refactors unrelated to the PR

## Reporting issues

Use the Bug / Feature issue templates. Include Qt version, OS, Modbus mode (RTU/TCP), and steps to reproduce.
