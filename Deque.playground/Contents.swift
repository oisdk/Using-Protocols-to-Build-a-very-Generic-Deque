//: ## The Deque ##

let d: Deque = [0, 1, 2, 3, 4, 5]

//: Under the hood, this deque is made up of two arrays. The front is reversed:

d.front.description

//: And the back is not:

d.back.description

//: ### Indexing ###

//: Index into the front, with 0:
//: 1. Figure out which queue it's in
//: 2. It's in the front, so subtract it from the end
//: 3. Index into the relevant queue

let index = 0
d[index]

// Step 1.
index < d.front.endIndex
0     < 3

// Step 2.
(d.front.endIndex - 1) - index
(3 - 1) - 0

// Step 3.
d.front[2]

//: Index into the back, with 4:
//: 1. Figure out which queue it's in:
//: 2. It's in the back, so the subtraction is reversed:
//: 3. Use that to index into the back:

let backIndex = 4
d[backIndex]

// Step 1.
backIndex < d.front.endIndex
4         < 3

// Step 2.
backIndex - d.front.endIndex
4 - 3

// Step 3.
d.back[1]

//: Instead of having all of this logic within the `subscript`, we could refactor it
//: out, into something that translates an integer into the releveant index in the 
//: relevant queue. To start with, we'll need an enum with a payload: `IndexLocation`.
//: (This is a private enum in the full implementation, [here](https://github.com/oisdk/SwiftDataStructures/blob/master/SwiftDataStructures/Deque.swift#L80-L82).
//: It's public here to make it visible in the playground.)

let indexLoc   = IndexLocation.Front(2)
let translated = d.translate(2)

//extension DequeType where
//  Container.Index : RandomAccessIndexType,
//  Container.Index.Distance : ForwardIndexType {
//  
//  public func translate(i: Container.Index.Distance) -> IndexLocation<Container.Index> {
//    return i < front.count ?
//      .Front(front.endIndex.predecessor().advancedBy(-i)) :
//      .Back(back.startIndex.advancedBy(i - front.count))
//  }
//}

//: We can do a similar thing with index ranges:

d.translate(0...2).debugDescription
d.translate(4...5).debugDescription
d.translate(2...5).debugDescription
d.translate(3..<3).debugDescription
//: ### Extra methods ###

//: A deque is a good data structure for certain uses, especially those that require
//: popping and appending from either end. `popFirst()` and `popLast()` aren't included
//: in the standard `RangeReplaceableCollectionType`, though, so we'll have to add our
//: own.

//extension RangeReplaceableCollectionType where Index : BidirectionalIndexType {
//  private mutating func popLast() -> Generator.Element? {
//    return isEmpty ? nil : removeLast()
//  }
//}

var mutableD = d
mutableD.popLast()
mutableD.debugDescription

//extension DequeType where Container.Index : BidirectionalIndexType {
//  public mutating func popLast() -> Container.Generator.Element? {
//    return back.popLast()
//  }
//}

//: The method needs to include `check()`, which we can do with `defer`

//mutating func popLast() -> Container.Generator.Element? {
//  defer { check() }
//  return back.popLast()
//}

mutableD.popLast()
mutableD.debugDescription
mutableD.popLast()
mutableD.debugDescription
//: You also can't just pop from the back queue in `popLast()`, because it may be the
//: case that the front queue has one element left

//mutating func popLast() -> Container.Generator.Element? {
//  defer { check() }
//  return back.popLast() ?? front.popLast()
//}

mutableD.popLast()
mutableD.popLast()
mutableD.debugDescription
mutableD.popLast()
mutableD.debugDescription
mutableD.popLast()
mutableD

//: The `DequeType` protocol can have any `RangeReplaceableCollectionType` as its
//: container, as long as you define a sliced type. You can even have a Deque made up
//: of two Deques:

struct DequeDeque<Element> : DequeType {
  var front, back: Deque<Element>
  typealias SubSequence = DequeDequeSlice<Element>
  init() { front = Deque(); back = Deque() }
}

struct DequeDequeSlice<Element> : DequeType {
  var front, back: DequeSlice<Element>
  typealias SubSequence = DequeDequeSlice
  init() { front = DequeSlice(); back = DequeSlice() }
}

let dd: DequeDeque = [1, 2, 3, 4, 5, 6, 7, 8]
dd.debugDescription
dd.front.debugDescription
dd.back.debugDescription
