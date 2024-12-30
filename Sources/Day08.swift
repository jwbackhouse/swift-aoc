// This is the post-Claude version of the previous commit.

import Algorithms

struct Map {
  private var map: [String]
  
  init(_ map: String) {
    self.map = map.split(separator: "\n").map(String.init)
  }
  
  var lines: [String] { map }
  
  var antennaMap: [String: [Coordinate]] {
    var result: [String: [Coordinate]] = [:]
    
    for (rowIdx, line) in map.enumerated() {
      for (colIdx, char ) in line.enumerated() where char != "." {
        result[String(char), default: []].append(Coordinate(row:rowIdx, col:colIdx))
      }
    }
    
    return result
  }
}

struct Coordinate: Hashable {
  var row: Int
  var col: Int
  
  init(row: Int, col: Int) {
    self.row = row
    self.col = col
  }
  
  func shifted(by rowOffset: Int, colOffset: Int) -> Coordinate {
    Coordinate(row: row + rowOffset, col: col + colOffset)
  }
}

func isWithinRange(_ coordinate: Coordinate, in map: Map) -> Bool {
  coordinate.row >= 0 && coordinate.row < map.lines.count && coordinate.col >= 0 && coordinate.col < map.lines.first?.count ?? 0
}

struct Day08: AdventDay {
  var data: String
  
  func part1() -> Int {
    let map = Map(data)
    return calculateAntinodes(in: map, isPropagated: false)
  }
  
  func part2() -> Int {
    let map = Map(data)
    return calculateAntinodes(in: map, isPropagated: true)
  }
  
  private func calculateAntinodes(in map: Map, isPropagated: Bool) -> Int {
    var antinodeSet: Set<Coordinate> = []
    
    for (_, coordinates) in map.antennaMap {
      for pair in coordinates.permutations(ofCount: 2) {
        let (coordA, coordB) = (pair[0], pair[1])
        let rowDistance = coordA.row - coordB.row
        let colDistance = coordA.col - coordB.col
        
        processAntinode(
          startingAt: coordA
            .shifted(by: rowDistance, colOffset: colDistance),
          rowDistance: rowDistance,
          colDistance: colDistance,
          map: map,
          into: &antinodeSet,
          isPropagated: isPropagated
        )
        
        processAntinode(
          startingAt: coordB
            .shifted(by: -rowDistance, colOffset: -colDistance),
          rowDistance: rowDistance,
          colDistance: colDistance,
          map: map,
          into: &antinodeSet,
          isPropagated: isPropagated
        )
      }
    }
    
    return antinodeSet.count
  }
  
  private func processAntinode(
    startingAt coordinate: Coordinate,
    rowDistance: Int,
    colDistance: Int,
    map: Map,
    into antinodeSet: inout Set<Coordinate>,
    isPropagated: Bool
  ) {
    var current = coordinate
    while isWithinRange(current, in: map) {
      antinodeSet.insert(current)
      if !isPropagated {break}
      current = current.shifted(by: rowDistance, colOffset: colDistance)
    }
  }
  
}
