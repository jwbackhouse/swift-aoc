// This code is a refactor by Claude of the commented-out code below
// I was on the right lines but it was running too slowly
enum Direction: CaseIterable {
  case up, right, down, left
  
  var offset: (dx: Int, dy: Int) {
    switch self {
      case .up:    return (0, -1)
      case .right: return (1, 0)
      case .down:  return (0, 1)
      case .left:  return (-1, 0)
    }
  }
  
  mutating func turnRight() {
    self = Direction.allCases[(Direction.allCases.firstIndex(of: self)! + 1) % 4]
  }
}

struct Point: Hashable {
  let x: Int
  let y: Int
  
  func moved(by direction: Direction) -> Point {
    let offset = direction.offset
    return Point(x: x + offset.dx, y: y + offset.dy)
  }
}

struct Grid {
  private var grid: [[Character]]
  let width: Int
  let height: Int
  
  init(_ input: String) {
    self.grid = input.split(separator: "\n").map { Array($0) }
    self.height = grid.count
    self.width = grid[0].count
  }
  
  mutating func addWall(at point: Point) {
    self.grid[point.y][point.x] = "#"
  }
  
  mutating func removeWall(at point: Point) {
    self.grid[point.y][point.x] = "."
  }
  
  func contains(_ point: Point) -> Bool {
    point.x >= 0 && point.x < width && point.y >= 0 && point.y < height
  }
  
  func isWall(at point: Point) -> Bool {
    grid[point.y][point.x] == "#"
  }
  
  func findStart() -> Point? {
    for y in 0..<height {
      for x in 0..<width where grid[y][x] == "^" {
        return Point(x: x, y: y)
      }
    }
    return nil
  }
}

struct PathTracker {
  private let grid: Grid
  private var visited: Set<Point> = []
  
  init(grid: Grid) {
    self.grid = grid
  }
  
  mutating func trackPath() -> Set<Point> {
    guard var current = grid.findStart() else { return Set() }
    var direction = Direction.up
    
    visited.insert(current)
    
    while true {
      let next = current.moved(by: direction)
      
      guard grid.contains(next) else { break }
      
      if grid.isWall(at: next) {
        direction.turnRight()
        continue
      }
      
      current = next
      visited.insert(current)
    }
    
    return visited
  }
}

struct PathTrackerPart2 {
  private let grid: Grid
  private var visited: [Point: Direction] = [:]
  private var result = 0
  
  init(grid: Grid) {
    self.grid = grid
  }
  
  mutating func trackPath() -> Int {
    guard var current = grid.findStart() else {return 0}
    var direction = Direction.up
    
    visited[current] = direction
    while true {
      let next = current.moved(by: direction)
      
      guard grid.contains(next) else { break }
      
      if visited[next] == direction {
        result += 1
        break
      }
       if grid.isWall(at: next) {
        direction.turnRight()
        continue
      }
     
      current = next
      visited[current] = direction
    }
    
    return result
  }
}

struct Day06: AdventDay {
  var data: String
  
  func part1() -> Int {
    let grid = Grid(data)
    var tracker = PathTracker(grid: grid)
    return tracker.trackPath().count
  }
  
  func part2() -> Int {
    let grid = Grid(data)
    var tracker = PathTracker(grid: grid)
    let visited = tracker.trackPath()
    var total = 0
    
    
    for point in visited {
      var grid2 = Grid(data)
      grid2.addWall(at: point)
      var tracker2 = PathTrackerPart2(grid: grid2)
      let result = tracker2.trackPath()
      total += result
    }
    
    return total
  }
}


// ****
// The following code was my original attempt
// Part 1 works fine, albeit slowly (~40s)
// Part 2 I think is the correct approach, but ran too slowly to every complete
// ****

//enum DirectionEnum {
//  case Up
//  case Down
//  case Left
//  case Right
//}
//
//enum PathError: Error {
//  case outOfBounds
//}
//
//struct Point: Hashable {
//  let row: Int
//  let col: Int
//}
//
//var visitedPoints: Set<Point> = []
//
//struct Direction: Equatable {
//  var direction: DirectionEnum
//
//  static let up = Direction(direction: .Up)
//  static let down = Direction(direction: .Down)
//  static let left = Direction(direction: .Left)
//  static let right = Direction(direction: .Right)
//
//  mutating func turnRight() -> Void {
//    direction = switch direction  {
//      case .Down: .Left
//      case .Left: .Up
//      case .Up: .Right
//      case .Right: .Down
//    }
//  }
//
//  func nextCoordinates(from point: (row: Int, col: Int)) -> (row: Int, col: Int) {
//    switch direction {
//      case .Down:
//        (row: point.row + 1, col: point.col)
//      case .Up:
//        (row: point.row - 1, col: point.col)
//      case .Left:
//        (row: point.row, col: point.col - 1)
//      case .Right:
//        (row: point.row, col: point.col + 1)
//    }
//  }
//}
//
//struct Day06: AdventDay {
//  var data: String
//
//  var entities: [[String]] {
//    data.split(separator: "\n").map {
//      $0.split(separator: "").map { String($0) }
//    }
//  }
//
//  func getStartingPoint() -> (row: Int, col: Int) {
//    for (y, row) in entities.enumerated() {
//      for (x, cell) in row.enumerated() {
//        if cell == "^" {
//          let startingPoint = (row: y, col: x)
//          return startingPoint
//        }
//      }
//    }
//    return (-1, -1)
//  }
//
//
//  func getNextCoords(row: Int, col: Int, dir: DirectionEnum) -> (row: Int, col: Int) {
//    switch dir {
//      case .Down:
//        return (row: row + 1, col: col)
//      case .Up:
//        return (row: row - 1, col: col)
//      case .Left:
//        return (row: row, col: col - 1)
//      case .Right:
//        return (row: row, col: col + 1)
//    }
//  }
//
//  func checkNextCoords(_ coords: (row: Int, col: Int)) throws {
//    if coords.row < 0 || coords.row >= entities.count || coords.col < 0 || coords.col >= entities[coords.row].count {
//      throw PathError.outOfBounds
//    }
//  }
//
//  func recordVisit(for point: Point) {
//    visitedPoints.insert(point)
//  }
//
//  func part1() -> Int {
//    let startingPoint = getStartingPoint()
//    var currentPoint = startingPoint
//    var currentDirection = Direction.up
//
//    do {
//      while true {
//        recordVisit(for: Point(row: currentPoint.row, col: currentPoint.col))
//
//        let nextPoint = currentDirection.nextCoordinates(from: (currentPoint.row, col: currentPoint.col))
//
//        try checkNextCoords(nextPoint)
//
//        if entities[nextPoint.row][nextPoint.col] == "#" {
//          currentDirection.turnRight()
//          continue
//        }
//
//        currentPoint = nextPoint
//      }
//    } catch PathError.outOfBounds {
//      print("All done!")
//    } catch {
//      print("Something went wrong")
//    }
//
//    return visitedPoints.count
//  }
//
//  func part2() -> Int {
//    var result = 0
//    print("Starting: \(visitedPoints.count)")
//    let startingPoint = getStartingPoint()
////    let rowCount = entities.count
////    let colCount = entities[0].count
//    var count = 0
//
//    var visitedPointsWithDirection: [Point: Direction] = [:]
//
//    func recordVisitForDirection(for point: Point, direction: Direction) {
//      visitedPointsWithDirection[point] = direction
//    }
//
//    func checkHasVisited(point: Point, facing direction: Direction) -> Bool  {
//      visitedPointsWithDirection[point]  == direction
//    }
//
//    for (idx, visitedPoint) in visitedPoints.enumerated() {
//      print("idx \(idx)")
//        var currentPoint = startingPoint
//        var currentDirection = Direction.up
//        visitedPointsWithDirection = [:]
//
//        do {
//          while true {
//            let nextPoint = currentDirection.nextCoordinates(from: (currentPoint.row, col: currentPoint.col))
//
//            try checkNextCoords(nextPoint)
//            let hasVisited = checkHasVisited(
//              point: Point(row: nextPoint.row, col: nextPoint.col),
//              facing: currentDirection
//            )
//            if (hasVisited) {
//              result += 1
//              break
//            }
//
//            if entities[nextPoint.row][nextPoint.col] == "#"  {
//              currentDirection.turnRight()
//              continue
//            }
//
//            if (
//              nextPoint.row == visitedPoint.row && nextPoint.col == visitedPoint
//                .col) {
//              currentDirection.turnRight()
//              continue
//            }
//
//            recordVisitForDirection(for: Point(
//              row: currentPoint.row,
//              col: currentPoint.col
//            ), direction: currentDirection)
//            currentPoint = nextPoint
//            count += 1
//          }
//        } catch PathError.outOfBounds {
////          print("All done!")
//        } catch {
//          print("Something went wrong")
//        }
//    }
//
//    print("All done: \(result)")
//    return result
//  }
//}
