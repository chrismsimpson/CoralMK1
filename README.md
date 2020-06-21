# Coral

My contribution to the shit show that is reality a la 2020. Earth needs a new programming language, something to finally replace C, that is:
- Type safe
- Memory safe (i.e. stack machine based, no garbage collection)
- Thread safe (i.e. threading/async/await that is built into the language primitives and/or foundational core/runtime)
- Free, but not just free, Lisp like in that it has no intrinsic dependancy on a proprietary runtime (or architecture), or even C for that matter
- Energy efficient - I'm sick of all you Node.js script kiddies burning the Amazon

An initial working title I had for this project was Meta (i.e. the *meta* language that everything will eventually be built in - the name Monkey was already taken). That seemed a massively insurmountable task, so I recalibrated to something smaller and arrived at Diesel (a play on DSL). Then I saw a three year old in the park with a shirt that read "Coral not Coal", and something from nature seemed symbolically important. This just happens to be the name of my current *File > New > Project* in which I got AST parsing (starting) to work. Let's see how long the name sticks.

## The Plan

Hmm, there is no *real* plan, only that I've wanted to hack a language for the longest time. I'm thinking (in a loose order):
- Get an AST working
- Build some kind of semantic analysis
- Code generation for:
    - MLIR (and hopefully therefore LLVM IR for free)
    - WASM
- Build an OS

## The Language

Checkout [SPEC.md](SPEC.md) for specifics, but basically:
- No OOP. Basically Go or Rust, but with a Swift-like syntax. In fact, you could call this a loose subset of Swift. When Apple announced Swift, they dubbed it "Objective-C without the C". Coral is "Swift without the Objective".
- No C interop initially. I say initially, because if I can ever get this thing working, it's probably a good feature to have. Why not initially? Because I think it's more important to have an X-safe (type safe, memory safe, thread safe etc.) implementation of a standard library written in the language itself rather than relying on C. This is the reason why Swift support on Linux/Windows is still patchy. Many of the primitives used in a typical Swift program come from Foundation, which is not part of the core language spec.
- Mutability/immutability as an language/allocation construct (as opposed to being provided by say, immutable types)
- First order functions & closures, meaning you can run code outside of a type def
- Async/await, but with a more English/human readable syntax
- Optionals
- Builtin Result & Promise types
- Aliasing (of types, functions/closures & modules/namespaces)
- Keyword aliases (e.g. `fn`, `fun`, `func` and `function` are all acceptable, though the language spec has a preferred style)
- Module/Namespacing (more flexible namespacing than Swift's virtually nonexisting namespacing) 
- Builtin package management similar to Go
- Test driven (or at least, I'll try)
