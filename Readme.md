## [cliHelper.env](dotEnv)

A PowerShell module that enables developers to load and edit `env` variables with ease, featuring cmdlets for enhanced [security measures](/docs/Readme.md#security-best-practices).

[![CI](https://github.com/chadnpc/cliHelper.env/actions/workflows/CI.yaml/badge.svg)](https://github.com/chadnpc/cliHelper.env/actions/workflows/CI.yaml)

## install

```PowerShell
Install-Module cliHelper.env
```

## usage

<!-- [demo] thumbnail : http://i.ytimg.com/vi/$Id/hqdefault.jpg -->
<!-- ex: id is YuCyE8HiLTY in https://www.youtube.com/watch?v=YuCyE8HiLTY -->

</br>

Notes:

_Its recomended to use with vscode extensions temitope1909.dotenv-intellisense_

0-risk editing environment variables

- **Security**:

  Environment variables can be easily accessed by anyone who has access to the
  system. This can lead to security breaches if sensitive information is stored
  in environment variables. This module has cmdlets to create
  [encrypted Enviromment variables](https://github.com/chadnpc/cliHelper.env/wiki#enc)

- **Debugging**:

  Debugging issues can arise when environment variables are not set correctly or
  when they are not being passed correctly between different parts of the
  system.

- **Performance**:

  Cmdlets are benchmarked during tests to make sure they will not slow down the
  system.

## TODOs

- [ ] Complete Protect-Env & UnProtect-Env
- [x] Update build script
- [ ] Add fancy cli. ex animations, progressbar & logging
- [x] Add tests
- [ ] Add zstandard compression
- [ ] complete the docs

## license

This module is licensed under the
[MIT License](https://chadnpc.MIT-license.org).
