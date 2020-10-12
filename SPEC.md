# Coral Spec

## Namespacing

```
extend MyType {

    public func myFunc() {

    }
}
```

Namespace != Module

```
namespace MyNamespace

or

namespace MyNamespace {

    ...
}

```

```
module MyModule
```

Otherwise implicit.

## Func signature

```
func myFunc() returns Int {

}

or

func myFunc() -> Int {

}

or

mutable func myFunc() {

}
```

## Async/await

```
async func myFunc() {

}

or 

task myTask() {

}
```

## References

### Pass by Value

```
func myFunc(myType: MyType) {

}
```

### Pass by Reference

```
func myFunc(myType: let MyType) {

}

or 

func myFunc(myType: ref MyType) {

}
```

## Pass by Reference (mutable)

```
func myFunc(myType: var MyType) {

}

or 

func myFunc(myType: mutable ref MyType) {

}
```

## Borrowing

```
extend MyType {

    func myFunc() {

        async {

            borrow self // not guarenteed to run
            
            self.doSomethingToSelf()
        }
    }
    
    or
    
    func myFunc() {
    
        async {
    
            borrow self? // guarenteed to run
            
            self?.doSomethingToSelf()
        }
    }
    
    or 
    
    func myFunc() {
    
        async {
        
            mutable borrow 
        }
    }
}
```

## Using Declarations

The following forms are acceptable:

```
using MyLibrary
```

```
using type MyLibrary.MyType
```

```
using func MyLibrary.myFunc
```

```
using MyLibrary as MyAlias
```

```
using type MyLibrary.MyType as MyTypeAlias
```

```
using func MyLibrary.myFunc as myFuncAlias
```

```
using MyLibrary from https://path/to/my/lib
```

```
using type MyLibrary.MyType from https://path/to/my/lib
```

```
using func MyLibrary.myFunc from https://path/to/my/lib
```

```
using MyLibrary from https://path/to/my/lib as MyAlias
```

```
using type MyLibrary.MyType from https://path/to/my/lib as MyTypeAlias
```

```
using func MyLibrary.myFunc from https://path/to/my/lib as myFuncAlias
```

## Struct Declarations


