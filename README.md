# raleigh

## Status

[![Build Status](https://dl.circleci.com/status-badge/img/gh/sourceweaver/raleigh/tree/master.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/sourceweaver/raleigh/tree/master)
[![Known Vulnerabilities](https://snyk.io/test/github/sourceweaver/raleigh/badge.svg?targetFile=src/package.json)](https://snyk.io/test/github/sourceweaver/raleigh?targetFile=src/package.json)

## Table of Contents

1. [Requirements](#requirements)
2. [Workflow](#workflow)
   1. [Development](#development)
   2. [Test and Lint](#test-and-lint)
   3. [Format](#format)
   4. [Production](#production)
   5. [Clean-up](#clean-up)
   6. [Documentation](#documentation)
   7. [Playground](#playground)
3. [Using `raleigh` as a project template](#using-raleigh-as-a-project-template)
4. [License](#license)

## Requirements

You'll need the following on your system:

+ `crystal` version `>=1.6.0`
+ `shards` version `>=0.17.1`
+ `node` version `>=16.14.2`
+ `npm` version `>=8.5.0`

The tool that `raleigh` uses to watch files for changes is called `reflex` and it's a zero
dependency Go tool that weighs ~3MB. You can learn more about `reflex` in it's official
[repository](https://github.com/cespare/reflex).

The project uses the `reflex` binary which is shipped in the `./bin` directory. If you
want to fetch `reflex` from source and build it yourself, make sure you use `reflex` version `0.3.1`
and place the binary in `./bin` directory.

## Workflow

To get started, install the dependencies that are defined in `shards.yml` and `./src/package.json`.

1. Install server dependencies

``` shell
shards install
```

2. Install client dependencies

``` shell
cd src && npm i
```


You're now ready to work on the project. All the commands available reside in the `Makefile`. You'll find
a list of *some* of the commands that you'll use regularly in the next sections.

### Development

+ `make watch/client` to watch and trigger a live reload on changes to `js|jsx|scss` files.
+ `make watch/server` to watch and trigger a live reload on changes to `cr|ecr` files.
+ `make watch/all` to run the previous two commands in parallel. You'll use this.

**Environment Variables:**
> During watch/server, the environment variables that reside in `./config/dev.env` will be
> injected to the environment. Add the variables that your app needs to this file. Note that this file
> is not checked into VCS. You can use `./config/dev.env.example` as a guide.

### Test and Lint

+ `make run/tests` to run Crystal spec.
+ `make lint/server` to lint `cr` files.
+ `make lint/client` to lint `js|jsx` files.

### Format

+ `make fmt/client` to format client files using `eslint`.
+ `make fmt/server` to format server files using `crystal tool`

### Production

+ `make build/all` to build `js|jsx|scss` files and `cr` files in production mode. The output will be moved to
`dist` directory at the root of the project.

You can then run `PRODUCTION=true ./raleigh` to start the application in production mode.

**Environment Variables:**
> Unlike watch mode, in production mode you're responsible of providing the environment variables
> that the app needs.

### Clean-up

+ `make clean` to remove compiled files and generated directories.

### Documentation

+ `make docs/generate` to generate Crystal docs.
+ `make docs/serve` to server Crystal docs locally with `python3`

### Playground

+ `make playground/serve` to serve Crystal playground.

## Using `raleigh` as a project template

If you'd like to use `raleigh` as a boilerplate for your next server-side application, you can clone the repo at the
tag `v0.1.0`, change all instances of `raleigh` and `Raleigh` to the desired name and get to work. There's also a
release for this tag on [GitHub releases](https://github.com/sourceweaver/raleigh/releases/tag/v0.1.0) which includes a tarball of the source code.

If you'd like to browse the repo at this point, visit the [relevant tree](https://github.com/sourceweaver/raleigh/tree/2facc47c22e8780ff794464c0f86310b4a49607b).

## License

`raleigh` is released under `AGPL-3.0`.
