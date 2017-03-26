import Foundation

/*:
 # Assignment 2
 
 The intent of this homework set is to:
 
 1. make sure that you can correctly use important concepts from Swift
 1. have a base set of code from which we can build our Conway's Game
    of Life app.
 
 This code will be incorporated into your final project, so it is very
 important that we get it right.  To the extent possible, I have given you
 a template for all the neccesary code here and have
 only asked you to fill in the details. You are being asked to 
 demonstrate that you understand the meaning of those details

 To complete this assignment, you need to have a basic understanding
 of the following Swift concepts:
 * Type Aliases
 * Base operations, in particular the modulo and ternary operators
 * Base data types, in particular Int and Tuple
 * Arrays and Arrays of Arrays
 * Basic control flow including: if, guard and switch
 * Why and when we avoid the use of "for" as a control flow mechanism
    and use functional constructs instead
 * The Swift types: enum, struct and class and their syntax, differences and similarities
 * Properties of enums, structs and classes
 * Subscripts on structs and classes
 * Functions and in particular higher order functions which take closures as arguments
 * Closures and in particular their capture rules and the trailing closure syntax
 * How to read the signature and therefore the type of a func or closure
 * Parameterized types (aka Generics) and their uses
 * Optional types and why they are genericized enums
 * The if-let and guard-let constructs

 It sounds like a lot I know, but these are parts of the language that you will use
 every day if programming professionally.  There's just no getting around them.
 
 Before attempting this homework, you should first read:
 * the Swift Tour section of the Apple Swift book
 * all of the learn-swift examples, cross-referencing back to the book as you go
 * the wikipedia page on Conway's Game of Life
 
 You should also keep these readily at hand while doing this assignment.
 
 **ALL** answers are to be given in line.  Please do not erase the formatted 
 comments as we will
 be grading by reading through this playground.  i.e. go to Editor->Show Rendered Markup 
 in Xcode and leave rendering on while doing the homework.  This will prevent you
 from inadvertantly changing things you should not change.
 
 You should make changes to this file **ONLY**
 in the places specified by the comments in green.  Put your code and or comments ONLY in
 those places!  Where the instructions specify a limit on the length of your answers, please
 be aware that we are serious about this.  Swift is built to facilitate concise coding style.
 This homework set has been created to teach you this style.
 
 As you work through this assignment you should reference the learn-swift workspace
 which has been provided in the course materials repository.
 
 To understand what we are doing you will need to make sure that you familiar 
 with Conway's Game of Life.  We discussed this extensively in class, but
 you may want to review: [The Wikipedia page](https://en.wikipedia.org/wiki/Conway's_Game_of_Life)
 
 You are **strongly** advised to work the problems in order.  And as you progress to make sure that
 the playground stays in a state where it compiles and runs.  An excellent practice to get into
 is to do frequent commits of your work so that you don't lose it and can roll back to previous 
 versions if you make a mistake.  Xcode will help you with this.
 
 ## Overall requirements:
 1. Your submitted playground must have zero errors and zero warnings
 1. It must successfully run to completion, generating the words The End at the end
 1. It must produce reasonable numbers for Conway's Game of Life, i.e. after a couple of 
 iterations, the game should have about 33 living cells.  It should NOT have zero or 100.
 1. You MUST do the work yourself, do not talk together on this one, any questions should be addressed to the discussion boards so that everyone may see them and the instructors may determine if they are appropriate
 
 The reason for these requirements are that if you do not understand how to use Swift at this level you will not 
 be able to do the other assignments.  It is VITAL that we get you the help you need if you are 
 having difficulties.
 
 ## Problem 1:  
 Problem 1 has already been worked for you as an example.  Everyone gets 5 free points!
 
 Create a typealias named Position for a tuple which has
 two integer variables: `row` and `col` in that order
*/
// ** Your Problem 1 code goes here! replace the following line **
typealias Position = (row: Int, col: Int)
/*:
 ## Problem 2: 
 Using the enum `CellState` defined below:
 1. create the following 4 possible values: `alive`, `empty`, `born` and `died`.
 1. equip `CellState` with a computed variable `isAlive` of type `Bool` which
    is true if the CellState is alive or born, false otherwise.
 1. Note that `isAlive` MUST use **ONLY** a switch statement on self
 1. `isAlive` can be no more than 8 readable lines long, including curly-braces.
 
 Failure to follow all rules will result in zero credit.
*/
enum CellState {
    // ** Your Problem 2 code goes here! Replace the contents of CellState **
    //  This shell code is here so that at all times the playground compiles and runs
    case alive, empty, born, died
    
    var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
}
/*:
 ## Problem 3:
 In the struct Cell below:
 1. Initialize `position` to `(0,0)` and `state` to `empty`,
 2. allow Swift to infer the two types, i.e. **do not** put `:Type` on the
 left hand side of the equals sign.
*/
// A struct representing a Cell in Conway's Game of Life
struct Cell {
    // ** Your Problem 3 code goes here! replace the following two lines **
    var position = (row: 0, col: 0)
    var state = CellState.empty
}
/*:
 ## Problem 4:
 I am providing the following function, `map2` immediately below.
 
 Answer the following questions on `map2` in the places shown.  (Your answers may consist of **AT MOST** once sentence):
 1. what do the `_` characters do?
 */
// ** Your Problem 4.1 answer goes here **
/*
 Allow you to not name the arguments on invocation
 */
/*:
 2. what is the type of the `transform` variable?
 */
// ** Your Problem 4.2 answer goes here **
/*
 (Int, Int) -> T i.e. a function taking 2 Ints and returning T
 */
/*:
 3. what is the return type of `map2`?
 */
// ** Your Problem 4.3 answer goes here **
/*
 [[T]] i.e. an array of arrays of T
 */
/*:
 4. what is `T` in this declaration?
 */
// ** Your Problem 4.4 answer goes here **
/*
  a generic type determined by what is returned from transform
 */
// A function which is like the standard map function but
// which will operate only on a two dimensional array
func map2<T>(_ rows: Int, _ cols: Int, transform: (Int, Int) -> T) -> [[T]] {
    return (0 ..< rows).map { row in
        return (0 ..< cols).map { col in
            return transform(row, col)
        }
    }
}
/*:
 The following 4 problems apply to the struct Grid shown below.
 
 ## Problem 5:
 In a comment here, explain what the contents
 of the variable named `offsets` in the struct `Grid` below represent.
 
 **Hint:** they are relative to the missing entry in the center and
 have to do with the rules to Conway's Game of Life.
 
 **Your answer may be no more than one sentence.**
*/
// ** Your Problem 5 comment goes here! **
/*
 the relative positions of the neighbor cells of any given cell
 */
/*:
 ## Problem 6:
 The struct `Grid` has been provided with 3 variables `rows`, `cols` and `cells`:
 1. Initialize `rows` of type `Int` to be 10 by default
 1. Intialize `cols` of type `Int` to be 10 by default
 
 ## Problem 7:
 In the location shown below, equip Grid with an initializer which:
 1. Initializes the `rows` and `cols` properties from the arguments
 1. initializes the `cells` array to be an array of length `rows` with
 each entry in that array being an array of type `[Cell]` of length `cols` by using:
 
 `    [[Cell]](repeatElement([Cell](repeatElement ...))`
 
 1. Uses the default values of the Cell struct in initialization
 1. is no more than 10 readable lines long
 
 Failure to follow all rules will result in zero credit
 
 ## Problem 8:
 Write precisely two lines of code in the location shown below
 
 1. The first line of code sets the position value of the cell specified by row and col
 to be (row, col)
 1. the second line of code which sets the state of each cell specified
 by row and col to the value specificied by `cellInitializer`.
 
 **HINT** you are setting the `position` and `state` properties of a value in `cells` to their appropriate values
 
 Failure to follow all rules will result in zero credit.
 */
// A grid of cells representing the world of Conway's GoL
struct Grid {
    static let offsets: [Position] = [
        (row: -1, col:  1), (row: 0, col:  1), (row: 1, col:  1),
        (row: -1, col:  0),                    (row: 1, col:  0),
        (row: -1, col: -1), (row: 0, col: -1), (row: 1, col: -1)
    ]
    
    // ** Your Problem 6 code goes here! Change the following two lines **
    var rows: Int = 10
    var cols: Int = 10
    var cells: [[Cell]] = [[Cell]]()
    
    init(_ rows: Int,
         _ cols: Int,
         cellInitializer: (Int, Int) -> CellState = { _,_ in .empty } ) {
        // ** Your Problem 7 code goes here! **
        self.rows = rows
        self.cols = cols
        cells = [[Cell]](repeatElement([Cell](repeatElement(Cell(position:(0,0), state: .empty), count: cols)), count: rows))
        
        map2(rows, cols) { row, col in
            cells[row][col].position = (row,col)
            cells[row][col].state = cellInitializer(row,col)
        }
    }
}
/*:
 The next two problems apply to the extension to `Grid` immediately below.
 
 ## Problem 9:
 In the extension to `Grid` below, provide a return
 value of type `Position` for the function `neighbors`
 such that `neighbors` returns the coordinates of all neighbor cells of self.
 Where by neighbor we mean one of the 8 cells in a grid which touches the current
 cell.
 
 Your answer MUST:
 1. consist of a return statement followed by the creation
 of a single Position object,
 1. implement the "wrap-around" rules of Conway's Game of Life
 1. take advantage of the following facts:
 
 `            0 <= (position.row + offsetRow    + maxRows) % maxRows < maxRows`
 
 `            0 <= (position.col + offsetColumn + maxCols) % maxCols < maxCols`
 
 
 4. make use of `$0` as passed into map
 5. be no longer than 4 readable lines long
 
 Failure to follow all rules will result in zero credit.
 
 **HINT** Note that the code you are being asked to write is inside of a map
 function operating over the `offsets` array and that it returns a position
 which represents a neighbor of the given cell which has its own position.
 
 ## Problem 10:
 In the extension to Grid below, examine the `neighbors` call.
 1. Explain in one sentence when you would use the word `of` in relation to this function
 */
// ** your problem 10.1 answer goes here.
/*
 when calling the function
 */
/*:
 2. Explain in one sentence when you would use the word `cell` in relation to this function
 */
// ** your problem 10.2 answer goes here.
/*
 when using the paramater in the function
 */
// An extension of Grid to add a function for computing the positions
// of the 8 neighboring cells of a given cell
extension Grid {
    // For the given cell in Conways' GoL, find all 8 of its neighbors,
    // "wrapping around" a maximum number of rows and columns
    func neighbors(of cell: Cell) -> [Position] {
        return Grid.offsets.map {
            // ** Your Problem 9 Code goes here! replace the following line **
            return Position(
                row: (cell.position.row + $0.row + self.rows) % self.rows,
                col: (cell.position.col + $0.col + self.cols) % self.cols
            )
        }
    }
}
/*:
 ## Problem 11:
 I am providing the following function, reduce2. Answer the following questions
 with **AT MOST** one sentence each.
 1. what do you expect the combine argument to do?
 */
// ** Your Problem 11.1 answer goes here **
/*
  sum a series of values determined by row and col
 */
/*:
 2. what is the return type of reduce2?
 */
// ** Your Problem 11.2 answer goes here **
/*
 Int
 */
/*:
 3. why is there no T parameter here as in map2 above?
 */
// ** Your Problem 11.3 answer goes here **
/*
  because the return type is fixed as Int where in map2 it was generic
 */

// A function which is useful for counting things in an array of arrays of things
func reduce2(_ rows: Int, _ cols: Int, combine: (Int, Int, Int) -> Int) -> Int  {
    return (0 ..< rows).reduce(0) { (total: Int, row: Int) -> Int in
        return (0 ..< cols).reduce(total) { (subtotal, col) -> Int in
            return combine(subtotal, row, col)
        }
    }
}
/*:
 ## Problem 12:
 In the extension to Grid below, write precisely one line of code which:
 1. uses the ternary conditional operators `?:`
 1. returns `total + 1` if the state of the referenced cell is `alive`, otherwise return `total`
 
 **HINT** you are returning a running count of living neighbors
 
 Failure to follow all rules will result in zero credit.
 */
// An extension to Grid which will count the number of living cells in the grid
extension Grid {
    var numLiving: Int {
        return reduce2(self.rows, self.cols) { total, row, col in
            // ** Replace the following line with your Problem 12 code
            return cells[row][col].state.isAlive ? total + 1 : total
        }
    }
}
/*:
 ## Problem 13:
 Let's test your work so far.
 
 1. Uncomment the lines of working code marked immediately below.
 2. Replace the cellInitializer with a closure which
 causes each cell to be `alive` with probability 1/3 and `empty` otherwise
 
 3. Use the following expression to determine if the `state` should be .alive or .empty:
 
 `     arc4random_uniform(3) == 2`
 
 4. Assign the state using the ternary conditional operators `?:`

 5. If your code above compiles and runs the value returned from grid.numLiving
 should be approximately 33. If it is not around 33, then debug your code above.
 Explain why it should be approximately but not necessarily exactly 33
 in a **one sentence** comment in the location shown below.
 
 **Hint:** This example passes the initializer in trailing closure syntax.  
 You will want to set the state of
 a cell using code similar to what you've already done
 
 Failure to follow all rules will result in zero credit.
 */
// Code to initialize a 10x10 grid, set up every cell in the grid
// and randomly turn each cell on or off.  Uncomment following 4 lines
// and replace `.empty` with your one line of code
var grid = Grid(10, 10) { row, col in 
   // ** Your Problem 13 code goes here! **
    arc4random_uniform(3) == 2 ? .alive : .empty
}
grid.numLiving

// ** Your Problem 13 comment goes here! **
/*
  100 / 3 is ~= 33
 */
/*:
 ## Problem 14:
 In the extension to `Grid` below, equip `Grid` with a subscript which allows you to
 get and set the values of a cell of type `Cell` in the following manner:
 ```
 aGrid[1,2] = aCell
 aGrid[2,3].state = .born
 let someCell = aGrid[4,7]
 let somePosition = aGrid[2,5].position
 ```
 Your solution MUST:
 1. implement both a `get` and a `set`
 1. in each case consist **ONLY** of a guard-else statement followed by a single line of code
 1. use the guard statement in both the `get` and the `set` to do boundary checking and ensure that row and col are between 0 and rows or cols respectively
 1. use the guard statement in `set` to ensure that the new value is not nil
 1. be no more than 4 lines for the `get` and 4 lines for the `set`
 
 Failure to follow all rules will result in zero credit.
 */
// An extension to grid to allow each cell to be referenced by its position
extension Grid {
    subscript (row: Int, col: Int) -> Cell? {
        get {
            // ** Your Problem 14 `get` code goes here! replace the following line **
            guard row >= 0 && row < rows && col >= 0 && col < cols else { return nil }
            return cells[row][col]
        }
        set {
            // ** Your Problem 14 `set` code goes here! replace the following line **
            guard let newValue = newValue, row >= 0 && row < rows && col >= 0 && col < cols else { return }
            cells[row][col] = newValue
            return
        }
    }
}
/*:
 The following 4 problems all refer to the extension to `Grid` immediately below
 
 ## Problem 15:
 Answer the following questions about livingNeighbors(of:) with **AT MOST ONE SENTENCE**.
 1. what is the type of `cell`?
 */
// Problem 15.1 answer goes here
/*
 Cell
 */
/*:
 2. what the type of `self[row,col]`?
 */
// Problem 15.2 answer goes here
/*
 Cell?
 */
/*:
 3. why those two types are different?
 */
// Problem 15.3 comment goes here
/*
  One is an optional the other is nonoptional
 */
/*:
 4. under what circumstances will the `else` clause will be executed?
 */
// Problem 15.4 comment goes here
/*
  when row or col or both is an invalid value
 */
/*:
 ## Problem 16:
 In a comment explain what the reduce function
 in the following extension returns in the context of Conway's Game of Life.
 
 Your answer may consist of **AT MOST** 2 sentences
 */

// Problem 16 comment goes here
/*
  how many of the neighbors of a given cell are in the isAlive state
 */

/*:
 ## Problem 17:
 In a comment explain what `$1` in:
 
 `                self[$1.row, $1.col]`
 
 does
 
 Your answer may consist of **AT MOST** one sentence
 */

// Problem 17 comment goes here
/*
  returns the Cell at position row and col
 */

/*:
 ## Problem 18:
 In the location shown below, write precisely ONE line of code which returns
 the correct value for computing the number of living neighbors
 of cell.
 
 Your answer must use:
 1. the ternary operators,
 1. $0 and
 1. the state of neighborCell
 
 Failure to follow all rules will result in zero credit
 */
// An extension to Grid which counts the number of living neighbors for the
// cell in position row, col
extension Grid {
    func livingNeighbors(of cell: Cell) -> Int {
        return self
            .neighbors(of: cell)
            .reduce(0) {
                guard let neighborCell = self[$1.row, $1.col] else { return $0 }
                // ** Problem 18 code goes here!  replace the following 2 lines **
                return neighborCell.state.isAlive ? $0 + 1 : $0
            }
    }
}
/*:
 ## Problem 19:
 In the extension to `Grid` shown below, implement a function nextState which:
 1. takes parameters `row` and `col`
 1. returns a properly initialized CellState
 1. implements the rules of Conway's Game of Life
 
 Your answer MUST:
 * use a `switch` statement on `livingNeighbors(of:)` from above to determine
 the value to return
 * the switch statement should consist of a single case and a default statement
 * use the `isAlive` property of `CellState` from above in
 a where clause attached to the case as part of the determination of state
 * return `alive` if the cell `isAlive` and has two living neighbors
 * return `alive` if the cell has 3 living neighbors regardless of
 the cell itself is alive or not
 * return `empty` otherwise
 * be no more than 8 lines long
 
 Failure to follow all rules will result in zero credit.
 */
// An extension to Grid to implement Conway's rules for transitioning a cell
// from one state of the game to the next
extension Grid {
    func nextState(of cell: Cell) -> CellState {
        // ** Problem 19 code goes here! Replace the following line **
        switch livingNeighbors(of: cell) {
        case 2 where cell.state.isAlive,
             3: return .alive
        default: return .empty
        }
    }
}
/*:
 ## Problem 20:
 In the location shown in the following extension of Grid, write precisely one line of
 code which sets the state of cell
 corresponding to `row, col` in nextGrid to the correct state for
 Conway's Game of Life using the `nextState` function from above
 */
// An extension to grid to jump to the next state of Conway's GoL
extension Grid {
    func next() -> Grid {
        var nextGrid = Grid(rows, cols)
        map2(self.rows, self.cols) { (row, col)  in
            // ** Problem 20 code goes here! **
            nextGrid[row,col]!.state = self.nextState(of: self[row,col]!)
        }
        return nextGrid
    }
}
/*:
 ## Problem 21:
 Explain what nextGrid variable immediately above represents
 in the context of Conway's Game of Life
 
 Your answer may consist of **ONLY ONE** sentence.
 */

// ** Your Problem 21 comment goes here! **
/*
  The next state of a grid in conway's game of life
 */
/*:
 ## Problem 22:
 Uncomment the following 2 lines of code.
 Verify that the number living is still in the neighborhood of 33
 If it is not please debug all your code
 */
grid = grid.next()
grid.numLiving
/*:
 It works!
 ## For Fun
 Once you have everything above working, uncomment and think about the following lines of code
 */
func gliderInitializer(row: Int, col: Int) -> CellState {
    switch (row, col) {
    case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
    default: return .empty
    }
}

grid = Grid(10, 10, cellInitializer: gliderInitializer)
grid.numLiving
grid = grid.next()
grid.numLiving
grid = grid.next()
grid.numLiving
grid = grid.next()
grid.numLiving
grid = grid.next()
grid.numLiving
grid = grid.next()
grid.numLiving
let theEnd = "The End"
