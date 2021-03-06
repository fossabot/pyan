# TODO

- Determine confidence of detected edges (probability that the edge is correct). Start with a binary system, with only values 1.0 and 0.0.
  - A fully resolved reference to a name, based on lexical scoping, has confidence 1.0.
  - A reference to an unknown name has confidence 0.0.
  - Attributes:
    - A fully resolved reference to a known attribute of a known object has confidence 1.0.
    - A reference to an unknown attribute of a known object has confidence 1.0. These are mainly generated by imports, when the imported file is not in the analyzed set. (Does this need a third value, such as 0.5?)
    - A reference to an attribute of an unknown object has confidence 0.0.
  - A wildcard and its expansions have confidence 0.0.
  - Effects of binding analysis? The system should not claim full confidence in a bound value, unless it fully understands both the binding syntax and the value. (Note that this is very restrictive. A function call or a list in the expression for the value will currently spoil the full analysis.)
  - Confidence values may need updating in pass 2.
- Make the analyzer understand `del name` (probably seen as `isinstance(node.ctx, ast.Del)` in `visit_Name()`, `visit_Attribute()`)
- Prefix methods by class name in the graph; create a legend for annotations. See the discussion [here](https://github.com/johnyf/pyan/issues/4).
- Improve the wildcard resolution mechanism, see discussion [here](https://github.com/johnyf/pyan/issues/5).
  - Could record the namespace of the use site upon creating the wildcard, and check any possible resolutions against that (requiring that the resolved name is in scope at the use site)?
- Add an option to visualize relations only between namespaces, useful for large projects.
  - Scan the nodes and edges, basically generate a new graph and visualize that.
- Publish test cases.
- Get rid of `self.last_value`?
  - Consider each specific kind of expression or statement being handled; get the relevant info directly (or by a more controlled kind of recursion) instead of `self.visit()`.
  - At some point, may need a second visitor class that is just a catch-all that extracts names, which is then applied to only relevant branches of the AST.
  - On the other hand, maybe `self.last_value` is the simplest implementation that extracts a value from an expression, and it only needs to be used in a controlled manner (as `analyze_binding()` currently does); i.e. reset before visiting, and reset immediately when done.

The analyzer **does not currently support**:

- Tuples/lists as first-class values (currently ignores any assignment of a tuple/list to a single name).
  - Support empty lists, too (for resolving method calls to `.append()` and similar).
- Starred assignment `a,*b,c = d,e,f,g,h`
- Slicing and indexing in assignment (`ast.Subscript`)
- Additional unpacking generalizations ([PEP 448](https://www.python.org/dev/peps/pep-0448/), Python 3.5+).
  - Any **uses** on the RHS _at the binding site_ in all of the above are already detected by the name and attribute analyzers, but the binding information from assignments of these forms will not be recorded (at least not correctly).
- Enums; need to mark the use of any of their attributes as use of the Enum. Need to detect `Enum` in `bases` during analysis of ClassDef; then tag the class as an enum and handle differently.
- Resolving results of function calls, except for a very limited special case for `super()`.
  - Any binding of a name to a result of a function (or method) call - provided that the binding itself is understood by Pyan - will instead show in the output as binding the name to that function (or method). (This may generate some unintuitive uses edges in the graph.)
- Distinguishing between different Lambdas in the same namespace (to report uses of a particular `lambda` that has been stored in `self.something`).
- Type hints ([PEP 484](https://www.python.org/dev/peps/pep-0484/), Python 3.5+).
- Type inference for function arguments
  - Either of these two could be used to bind function argument names to the appropriate object types, avoiding the need for wildcard references (especially for attribute accesses on objects passed in as function arguments).
  - Type inference could run as pass 3, using additional information from the state of the graph after pass 2 to connect call sites to function definitions. Alternatively, no additional pass; store the AST nodes in the earlier pass. Type inference would allow resolving some wildcards by finding the method of the actual object instance passed in.
  - Must understand, at the call site, whether the first positional argument in the function def is handled implicitly or not. This is found by looking at the flavor of the Node representing the call target.
- Async definitions are detected, but passed through to the corresponding non-async analyzers; could be annotated.
- Cython; could strip or comment out Cython-specific code as a preprocess step, then treat as Python (will need to be careful to get line numbers right).

## How it works

From the viewpoint of graphing the defines and uses relations, the interesting parts of the [AST](https://en.wikipedia.org/wiki/Abstract_syntax_tree) are bindings (defining new names, or assigning new values to existing names), and any name that appears in an `ast.Load` context (i.e. a use). The latter includes function calls; the function's name then appears in a load context inside the `ast.Call` node that represents the call site.

Bindings are tracked, with lexical scoping, to determine which type of object, or which function, each name points to at any given point in the source code being analyzed. This allows tracking things like:

```python
def some_func()
    pass

class MyClass:
    def __init__(self):
        self.f = some_func

    def dostuff(self)
        self.f()
```

By tracking the name `self.f`, the analyzer will see that `MyClass.dostuff()` uses `some_func()`.

The analyzer also needs to keep track of what type of object `self` currently points to. In a method definition, the literal name representing `self` is captured from the argument list, as Python does; then in the lexical scope of that method, that name points to the current class (since Pyan cares only about object types, not instances).

Of course, this simple approach cannot correctly track cases where the current binding of `self.f` depends on the order in which the methods of the class are executed. To keep things simple, Pyan decides to ignore this complication, just reads through the code in a linear fashion (twice so that any forward-references are picked up), and uses the most recent binding that is currently in scope.

When a binding statement is encountered, the current namespace determines in which scope to store the new value for the name. Similarly, when encountering a use, the current namespace determines which object type or function to tag as the user.
