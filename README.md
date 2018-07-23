charukiewi.cz
=============

A personal website generated using the [Hakyll](https://jaspervdj.be/hakyll/) static site generator, written in Haskell.

The `site.hs` file, when compiled, acts as both a build tool and development-only webserver.

### Build Instructions

This project uses [Stack](https://docs.haskellstack.org/en/stable/README/), as Haskell build tool designed for reproducible builds. After installing `stack`, run the following command:

```
stack build
```

This will download and install all necessary dependencies, and produce the `site` executable in the `.stack-work` subdirectory fof the project.

### Usage Instructions

You can build the website by invoking the `site` executable through `stack`:

```
stack exec site -- build
```

This will output the contents of the static site into the `_site` directory of this project.

View the additional commands with the `help` command:

```
stack exec site -- help
```
