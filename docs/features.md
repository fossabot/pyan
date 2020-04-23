## Features

_Items tagged with ☆ are new in Pyan3._

**Graph creation**:

- Nodes for functions and classes
- Edges for defines
- Edges for uses
  - This includes recursive calls ☆
- Grouping to represent defines, with or without nesting
- Coloring of nodes by filename
  - Unlimited number of hues ☆

**Analysis**:

- Name lookup across the given set of files
- Nested function definitions
- Nested class definitions ☆
- Nested attribute accesses like `self.a.b` ☆
- Inherited attributes ☆
  - Pyan3 looks up also in base classes when resolving attributes. In the old Pyan, calls to inherited methods used to be picked up by `contract_nonexistents()` followed by `expand_unknowns()`, but that often generated spurious uses edges (because the wildcard to `*.name` expands to `X.name` _for all_ `X` that have an attribute called `name`.).
- Resolution of `super()` based on the static type at the call site ☆
- MRO is (statically) respected in looking up inherited attributes and `super()` ☆
- Assignment tracking with lexical scoping
  - E.g. if `self.a = MyFancyClass()`, the analyzer knows that any references to `self.a` point to `MyFancyClass`
  - All binding forms are supported (assign, augassign, for, comprehensions, generator expressions, with) ☆
    - Name clashes between `for` loop counter variables and functions or classes defined elsewhere no longer confuse Pyan.
- `self` is defined by capturing the name of the first argument of a method definition, like Python does. ☆
- Simple item-by-item tuple assignments like `x,y,z = a,b,c` ☆
- Chained assignments `a = b = c` ☆
- Local scope for lambda, listcomp, setcomp, dictcomp, genexpr ☆
  - Keep in mind that list comprehensions gained a local scope (being treated like a function) only in Python 3. Thus, Pyan3, when applied to legacy Python 2 code, will give subtly wrong results if the code uses list comprehensions.
- Source filename and line number annotation ☆
  - The annotation is appended to the node label. If grouping is off, namespace is included in the annotation. If grouping is on, only source filename and line number information is included, because the group title already shows the namespace.