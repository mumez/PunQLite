# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PunQLite is a Pharo Smalltalk binding for UnQLite, a fast, lightweight embedded NoSQL database with key-value storage and Jx9 scripting engine support. The project provides a Dictionary-like interface for storing and retrieving data with minimal overhead.

## Architecture

### Package Structure (Dependency Order)

```
PunQLite-Core         # FFI bindings, low-level library interface
  ├─ UnQLiteFFI       # FFI wrapper for C library
  ├─ UnQLiteLibrary   # Library loading and platform detection
  └─ UnQLiteConstants # C constants mapping

PunQLite-DB           # High-level database API
  ├─ PqDatabase       # Main database interface (Dictionary-like API)
  ├─ PqCursor         # Cursor-based iteration
  ├─ PqCollection     # Collection interface
  └─ PqValueAppender  # Efficient value appending

PunQLite-Jx9          # Jx9 scripting engine integration
  ├─ PqJx9Executer    # Script execution
  ├─ PqJx9Context     # Execution context
  ├─ PqJx9Value       # Value marshalling between Smalltalk and Jx9
  └─ Extensions       # Adds Jx9 conversion methods to core classes

PunQLite-Tests        # Test suite (depends on all above)
PunQLite-Tools        # GUI browser (depends on PunQLite-DB)
PunQLite-Help         # Help system integration
```

### Key Design Patterns

**FFI Layer**: Uses Pharo's UnifiedFFI to interface with the native UnQLite C library. All FFI calls go through `UnQLiteFFI` class with type mappings for pointers (`db_ptr`, `cursor_ptr`, `vm_ptr`, `value_ptr`, `context_ptr`).

**Handle Management**: `PqObject` is the base class managing native handles and provides lifecycle methods (`close`, `release`). Subclasses (`PqDatabase`, `PqCursor`, `PqJx9Executer`) must properly release their native resources.

**Dictionary Protocol**: `PqDatabase` implements standard Dictionary methods (`at:`, `at:put:`, `at:ifAbsent:`, `at:ifPresent:`, `keys`, `do:`) making it intuitive for Smalltalk developers.

**Cursor-Based Iteration**: For efficient database scanning, use `PqCursor` which provides `seek:untilEndDo:` and standard iteration protocols.

**Jx9 Integration**: Bidirectional conversion between Smalltalk objects and Jx9 values via extension methods (e.g., `String>>asJx9Value:`, `Integer>>asJx9Value:`). The `PqJx9Executer` manages script compilation and execution lifecycle.

## Native Library Management

The UnQLite shared library must be present in the image directory or system library path:

- **Linux**: `unqlite.so`
- **macOS**: `unqlite.dylib`
- **Windows**: `unqlite.dll`

Pre-built binaries are stored in `binary/linux/`, `binary/osx/`, `binary/win/`. The `BaselineOfPunQLite>>preLoad` method automatically downloads the appropriate library if missing.

To compile UnQLite manually (it's just two files):

```bash
gcc -c unqlite.c
gcc -shared -o unqlite.so unqlite.o  # Linux
gcc -dynamiclib -o unqlite.dylib unqlite.o  # macOS
gcc -shared -static-libgcc -o unqlite.dll unqlite.o -Wl,--add-stdcall-alias  # Windows
```

## Working with Smalltalk MCP Tools

This is a Pharo Smalltalk project. Use the available Smalltalk MCP tools for all Smalltalk operations:

**Essential Commands**:
- `mcp__smalltalk-interop__get_class_source` - Read full class definitions
- `mcp__smalltalk-interop__get_method_source` - Read specific method implementations
- `mcp__smalltalk-interop__search_implementors` - Find all implementors of a method
- `mcp__smalltalk-interop__search_references` - Find references to methods/symbols
- `mcp__smalltalk-interop__eval` - Execute Smalltalk code in the running image
- `mcp__smalltalk-interop__run_package_test` - Run all tests in a package
- `mcp__smalltalk-interop__run_class_test` - Run tests for a specific test class
- `mcp__smalltalk-validator__validate_tonel_smalltalk_from_file` - Validate Tonel syntax

**Testing Workflow**:
```smalltalk
# Run all PunQLite tests
mcp__smalltalk-interop__run_package_test('PunQLite-Tests')

# Run specific test class
mcp__smalltalk-interop__run_class_test('PqDatabaseTest')
mcp__smalltalk-interop__run_class_test('PqJx9Test')
mcp__smalltalk-interop__run_class_test('PqCollectionTest')
```

**Development Pattern**:
1. Use `search_classes_like` to find relevant classes
2. Use `get_class_source` to understand class structure
3. Use `get_method_source` to read specific implementations
4. Validate changes with `validate_tonel_smalltalk_from_file`
5. Run tests with `run_class_test` or `run_package_test`

## Installation & Loading

```smalltalk
# Load via Metacello
Metacello new
    repository: 'github://mumez/PunQLite/repository'
    baseline: 'PunQLite';
    load.

# Or from Pharo Catalog
```

## Testing

Test packages are in `repository/PunQLite-Tests/`:
- `PqDatabaseTest` - Core database operations
- `PqJx9Test` - Jx9 scripting integration
- `PqCollectionTest` - Collection protocol

All tests use in-memory databases (`PqDatabase openOnMemory`) to avoid file system dependencies.

## Transaction Handling

PunQLite supports both auto-commit and explicit transaction modes:

- **Auto-commit** (default): Each operation is automatically committed
- **Manual transactions**: Call `database disableAutoCommit` then use `database transact: [ ... ]`

Cursor operations and manual transactions provide better performance for bulk operations.

## Common Pitfalls

1. **Resource Leaks**: Always call `close` or `release` on `PqDatabase`, `PqCursor`, and `PqJx9Executer` instances. Use `ensure:` blocks in production code.

2. **Jx9 Type Marshalling**: Jx9 variables must be extracted with proper type conversion (`asInt`, `asString`, `asBoolean`). Check `PqJx9Value` for supported types.

3. **Cursor Validity**: Cursors become invalid after database operations. Create fresh cursors for each iteration.

4. **FFI Platform Differences**: The FFI layer has platform-specific differences in 32-bit vs 64-bit integer handling. The recent commit addresses C integer size issues (see commit 30f854b).

## Git Workflow

- **Main branch**: `master` (for PRs)
- **Development branch**: `develop` (current active branch)
- Source code is in Cypress/Tonel format under `repository/`
