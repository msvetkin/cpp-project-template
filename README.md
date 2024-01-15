# C++ project template

## Template Initialization

This project is a template that cannot be used before initialization. To initialize your project, you must run the following shell command:

```sh
cmake -P init.cmake --project <name> --module <name> --header <name>
```

- **Project name** will become your top-level CMake project name
  - Must be alphanumeric and begin with a character.
- **Module name** will be concatenated with your project name to determine the library's namespace (`${project}::${module}`)
- **Header name** will become the name of your library's main include header


## Building

To build the project locally, you will need to select a [CMake](https://cmake.org/) preset that matches your system configuration. Your system's configuration is described by a [triplet](https://wiki.osdev.org/Target_Triplet). This is inspired by [rust triples](https://doc.rust-lang.org/nightly/rustc/platform-support.html).

Presets for the most common system triplets are defined in [`cmake/presets/`](./cmake/presets/) and presented via [`CMakePresets.json`](./CMakePresets.json). 

Notice that each system triplet defines a preset for multiple compilers. If you have a compiler preference, you can pick the respective preset. If you do not have a preference, you can choose the following reccomendation (depending on your OS): 

 - Windows: `msvc`
 - MacOS: `clang`
 - Linux: `gcc`

Now you can configure and build your project:

```sh
cmake --workflow --preset=<PRESET>
```

This is equivalend to running the following in a step-by-step proceedure:

```sh
# Configure
cmake --preset=<PRESET>
# Build
cmake --build --preset=<PRESET>
# Test
ctest --preset=<PRESET>
```

Regardless of how you build, the `build/<PRESET>` folder will be populated with the binaries for all of your [CMake targets](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Key%20Concepts.html#targets).

## Usage

By default, this template comes with a CLI entrypoint defined in [`src/cli/src/main.cpp`](src/cli/src/main.cpp), and one module/library defined in your `src` folder. The Command Line Interface contains a very basic `main` function, and can be run after building by the `build/<PRESET>/src/cli/<Debug|Release|RelWithDebInfo>/<PROJECT_NAME>_cli` executable(s).

Tests are run with [Catch2](https://github.com/catchorg/Catch2). They can be written in the [`tests`](tests) subdirectory, and run with CTest:

```sh
ctest --preset <PRESET>
```

For usage within another C++ project, you can add the following to your CMake configuration:

```cmake
find_package(<PROJECT_NAME> CONFIG REQUIRED)
target_link_libraries(<TARGET> PUBLIC <PROJECT_NAME>::<MODULE_NAME>)
```

This will require that your library is published and installed via vcpkg or found locally by setting the `CMAKE_PREFIX_PATH` environment variable in your other project during configure.