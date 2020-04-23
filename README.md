# Pyan3 [![icon](docs/assets/icon.png)](docs/assets/icon.png)

Offline call graph generator for Python 3

[![Build Status](https://travis-ci.com/edumco/pyan.svg?branch=master)](https://travis-ci.com/edumco/pyan)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/7cba5ba5d3694a42a1252243e3634b5e)](https://www.codacy.com/manual/edumco/pyan?utm_source=github.com&utm_medium=referral&utm_content=edumco/pyan&utm_campaign=Badge_Grade)
![PyPI - Python Version](https://img.shields.io/pypi/pyversions/pyan3)

Pyan takes one or more Python source files and constructs a directed graph of the objects in the combined source, and how they define or use each other.

[![Example output](docs/assets/graph0.png "Example: GraphViz rendering of Pyan output (click for .svg)")](docs/assets/graph0.svg)

> The graphs are rendered by [GraphViz](https://pypi.org/project/graphviz/) or [yEd](https://www.yworks.com/products/yed).

**Defines** relations are drawn with _dotted gray arrows_.

**Uses** relations are drawn with _black solid arrows_. Recursion is indicated by an arrow from a node to itself. [Mutual recursion](https://en.wikipedia.org/wiki/Mutual_recursion#Basic_examples) between nodes X and Y is indicated by a pair of arrows, one pointing from X to Y, and the other from Y to X.

**Nodes** are always filled, and made translucent to clearly show any arrows passing underneath them. This is especially useful for large graphs with GraphViz's `fdp` filter. If colored output is not enabled, the fill is white.

In **node coloring**, the [HSL](https://en.wikipedia.org/wiki/HSL_and_HSV) color model is used. The **hue** is determined by the _filename_ the node comes from. The **lightness** is determined by _depth of namespace nesting_, with darker meaning more deeply nested. Saturation is constant. The spacing between different hues depends on the number of files analyzed; better results are obtained for fewer files.

**Groups** are filled with translucent gray to avoid clashes with any node color.

The nodes can be **annotated** by _filename and source line number_ information.

## Note

The static analysis approach Pyan takes is different from running the code and seeing which functions are called and how often. There are various tools that will generate a call graph that way, usually using a debugger or profiling trace hooks, such as [Python Call Graph](https://pycallgraph.readthedocs.org/).

In Pyan3, the analyzer was ported from `compiler` ([good riddance](https://stackoverflow.com/a/909172)) to a combination of `ast` and `symtable`, and slightly extended.

## Usage

Example:

`pyan3 *.py --uses --no-defines --colored --grouped --annotated --dot >myuses.dot`

Then render using your favorite GraphViz filter, mainly `dot` or `fdp`:

`dot -Tsvg myuses.dot >myuses.svg`

### Troubleshooting

If GraphViz says _trouble in init_rank_, try adding `-Gnewrank=true`, as in:

`dot -Gnewrank=true -Tsvg myuses.dot >myuses.svg`

Usually either old or new rank (but often not both) works; this is a long-standing GraphViz issue with complex graphs.

### Reducing details

If the graph is visually unreadable due to too much detail, consider visualizing only a subset of the files in your project. Any references to files outside the analyzed set will be considered as undefined, and will not be drawn.

Currently Pyan always operates at the level of individual functions and methods; an option to visualize only relations between namespaces may (or may not) be added in a future version.

## Authors

Original [pyan.py](https://github.com/ejrh/ejrh/blob/master/utils/pyan.py) by Edmund Horner. [Original post with explanation](http://ejrh.wordpress.com/2012/01/31/call-graphs-in-python-part-2/).

[Coloring and grouping](https://ejrh.wordpress.com/2012/08/18/coloured-call-graphs/) for GraphViz output by Juha Jeronen.

[Git repository cleanup](https://github.com/davidfraser/pyan/) and maintenance by David Fraser.

[yEd GraphML output, and framework for easily adding new output formats](https://github.com/davidfraser/pyan/pull/1) by Patrick Massot.

A bugfix [[2]](https://github.com/davidfraser/pyan/pull/2) and the option `--dot-rankdir` [[3]](https://github.com/davidfraser/pyan/pull/3) contributed by GitHub user ch41rmn.

A bug in `.tgf` output [[4]](https://github.com/davidfraser/pyan/pull/4) pointed out and fix suggested by Adam Eijdenberg.

This Python 3 port, analyzer expansion, and additional refactoring by Juha Jeronen.

Icon by [Gopi Doraisamy](https://www.behance.net/gopidoraisamy)

## License

[GPL v2](LICENSE.md), as per [comments here](https://ejrh.wordpress.com/2012/08/18/coloured-call-graphs/).
