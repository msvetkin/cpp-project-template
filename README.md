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

To build the project locally, you will need to select a [CMake](https://cmake.org/) preset that matches your system configuration. Your system's configuration is described by a [triplet](https://wiki.osdev.org/Target_Triplet).

Presets for the most common system triplets are defined in [`CMakePresets.json`](./CMakePresets.json). 

Notice that each system triplet defines a preset for multiple compilers. If you have a compiler preference, you can pick the respective preset. If you do not have a preference, you can choose [GCC](https://gcc.gnu.org/), which should be available on most systems.

Now you can configure your project:

```sh
cmake --preset=<PRESET>
```

And finally build:

```sh
cmake --build --preset=<PRESET>
```

This will populate the `build/<PRESET>` folder with the binaries for all of your [CMake targets](https://cmake.org/cmake/help/book/mastering-cmake/chapter/Key%20Concepts.html#targets).

## Usage

By default, this template comes with a CLI entrypoint defined in [`src/cli/src/main.cpp`](src/cli/src/main.cpp). This Command Line Interface can be run after building by the `build/<PRESET>/src/cli/<Debug|Release|RelWithDebInfo>/<PROJECT_NAME>_cli` executable(s).

Tests are run with [Catch2](https://github.com/catchorg/Catch2). They can be written in the [`tests`](tests) subdirectory, and run from the `build/<PRESET>/tests/<PROJECT_NAME>_module/<Debug|Release|RelWithDebInfo>/<PROJECT_NAME>_module-<MODULE_NAME>` executable.