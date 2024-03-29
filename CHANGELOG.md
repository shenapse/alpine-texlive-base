# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [0.3.4] - 2023-08-27

### Added

- locate `.bash_profile` at root.
- set `IMAGE_NAME` and `IMAGE_TAG` as environmental variables

## [0.3.3] - 2023-08-16

### Added

- bundle latexdiff and lacheck by default.
- add meta packages: ulem, listings, l3packages, mleftright

## [0.3.2] - 2023-08-10

### Added

- created a latexindent config file in the home directory that specifies the location of user-setting files.

### Changed

- separated the build of the perl module from that of texlive, which were originally a single build.

## [0.3.1] - 2023-08-01

### Fixed

- update `tlmgr` to make it work in container shell

## [0.3.0] - 2023-08-01

### Changed

- adopt texlive-2023

### Added

- `texlive-version.txt`

## [0.2.0] - 2023-01-04

### Added

- install git

## [0.1.0] - 2022-12-31

### Added

- biblatex and biber package

### Changed

- adopt biblatex & biber style bibliography on sample file. The previous bibtex style is now removed.

## [0.0.1] - 2022-12-31

### Added

- first release
- base Dockerfile
- tex files (test.tex, master.tex) for testing image
