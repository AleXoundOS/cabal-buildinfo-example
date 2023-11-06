This example shows how to parameterize your cabal project with preprocessor definitions, passed to haskell code.

What makes it work:

1. `build-type: Configure` in a project cabal file
2. `configure` script (file), that generates `$PROJECT.buildinfo` file with `cpp-options: -DMYDEF=SOME_TEXT` contents
3. haskell (library) code, that uses `CPP` extension to access `MYDEF`

[This can be used with executables too if generated text starts with `executable: EXECUTABLE_NAME `](https://cabal.readthedocs.io/en/stable/cabal-package.html#system-dependent-parameters).

## develop

```
$ nix develop
[devshell]$ cabal build
Build profile: -w ghc-9.2.8 -O1
In order, the following will be built (use -v for more details):
 - cabal-buildinfo-example-0.1.0.0 (lib:cabal-buildinfo-example, exe:cabal-buildinfo-example) (first run)
Preprocessing library for cabal-buildinfo-example-0.1.0.0..
Building library for cabal-buildinfo-example-0.1.0.0..
Preprocessing executable 'cabal-buildinfo-example' for cabal-buildinfo-example-0.1.0.0..
Building executable 'cabal-buildinfo-example' for cabal-buildinfo-example-0.1.0.0..
[1 of 1] Compiling Main             ( app/Main.hs, /data/proj/cabal-buildinfo-example/dist-newstyle/build/x86_64-linux/ghc-9.2.8/cabal-buildinfo-example-0.1.0.0/build/cabal-buildinfo-example/cabal-buildinfo-example-tmp/Main.o )
Linking /data/proj/cabal-buildinfo-example/dist-newstyle/build/x86_64-linux/ghc-9.2.8/cabal-buildinfo-example-0.1.0.0/build/cabal-buildinfo-example/cabal-buildinfo-example ...

[devshell]$ cabal run
CPP_definition

[devshell]$ cabal repl
Build profile: -w ghc-9.2.8 -O1
In order, the following will be built (use -v for more details):
 - cabal-buildinfo-example-0.1.0.0 (ephemeral targets)
Preprocessing library for cabal-buildinfo-example-0.1.0.0..
GHCi, version 9.2.8: https://www.haskell.org/ghc/  :? for help
[1 of 1] Compiling MyLib            ( src/MyLib.hs, interpreted )

src/MyLib.hs:6:14: error:
    Data constructor not in scope: MYDEF :: String
  |
6 | definition = MYDEF
  |              ^^^^^
Failed, no modules loaded.
```

Currently, `cabal repl` fails to pick up the definition.
