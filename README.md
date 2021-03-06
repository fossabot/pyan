# Pyan3 [![icon](docs/assets/icon.png)](docs/assets/icon.png)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fedumco%2Fpyan.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fedumco%2Fpyan?ref=badge_shield)

Offline call graph generator for Python 3

[![Build Status](https://travis-ci.com/edumco/pyan.svg?branch=master)](https://travis-ci.com/edumco/pyan)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7cba5ba5d3694a42a1252243e3634b5e)](https://www.codacy.com/manual/edumco/pyan?utm_source=github.com&utm_medium=referral&utm_content=edumco/pyan&utm_campaign=Badge_Grade)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/pyan3)

Pyan takes one or more Python source files and constructs a directed graph of the objects in the combined source, and how they define or use each other.

## Install

Install pyan3 using pip on Python 3.6

```bash
pip install pyan3
```

## Usage

All you need is to pass a python file or several files by passing an wildcard (\*)

```bash
pyan3 *.py --dot > myuses.dot
```

Then render using your favorite GraphViz filter, mainly `dot` or `fdp`:

```bash
dot -T svg myuses.dot > myuses.svg
```

[![Example output](docs/assets/graph0.png "Example: GraphViz rendering of Pyan output (click for .svg)")](docs/assets/graph0.svg)

The graph is drawn and organized this way:

- **Nodes** filled and translucent elipses.

- **Defines** relations are drawn with _dotted gray arrows_.

- **Uses** relations are drawn with _black solid arrows_.

- **Recursion** is indicated by an arrow from a node to itself.

- **[Mutual recursion](https://en.wikipedia.org/wiki/Mutual_recursion#Basic_examples)** a pair of arrows pointing each other.

- **Colors** uses the [HSL](https://en.wikipedia.org/wiki/HSL_and_HSV) color model like:

  - **hue** shows the _filename_ the node comes from.
  - **lightness** shows the _depth of namespace nesting_ (darker is deeper).
  - **saturation** is constant.

- **Groups** are filled with translucent gray to avoid clashes with any node color.

- **Annotations** with _filename and source line number_ can be added to nodes.

> The static analysis approach Pyan3 takes is different from running the code and seeing which functions are called and how often. There are various tools that will generate a call graph that way, usually using a debugger or profiling trace hooks, such as [Python Call Graph](https://pycallgraph.readthedocs.org/).

## Authors

- Original [pyan.py](https://github.com/ejrh/ejrh/blob/master/utils/pyan.py) by Edmund Horner. [Original post with explanation](http://ejrh.wordpress.com/2012/01/31/call-graphs-in-python-part-2/).

- [Coloring and grouping](https://ejrh.wordpress.com/2012/08/18/coloured-call-graphs/) for GraphViz output by Juha Jeronen.

- [Git repository cleanup](https://github.com/davidfraser/pyan/) and maintenance by David Fraser.

- [yEd GraphML output, and framework for easily adding new output formats](https://github.com/davidfraser/pyan/pull/1) by Patrick Massot.

- A bugfix [[2]](https://github.com/davidfraser/pyan/pull/2) and the option `--dot-rankdir` [[3]](https://github.com/davidfraser/pyan/pull/3) contributed by GitHub user ch41rmn.

- A bug in `.tgf` output [[4]](https://github.com/davidfraser/pyan/pull/4) pointed out and fix suggested by Adam Eijdenberg.

- This Python 3 port, analyzer expansion, and additional refactoring by Juha Jeronen.

- Icon by [Gopi Doraisamy](https://www.behance.net/gopidoraisamy)

## License

[GPL v2](LICENSE.md), as per [comments here](https://ejrh.wordpress.com/2012/08/18/coloured-call-graphs/).


[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fedumco%2Fpyan.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fedumco%2Fpyan?ref=badge_large)