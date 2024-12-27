import Algorithms

struct Map {
  private var map: [String]
  
  init(_ map: String) {
    self.map = map.split(separator: "\n").map(String.init)
  }
  
  var lines: [String] { map }
  
  var antennaMap: [String: [(Int, Int)]] {
    var result: [String: [(Int, Int)]] = [:]
    
    for (rowIdx, line) in map.enumerated() {
      for (colIdx, char ) in line.enumerated() {
        if char == "." {
          continue
        }
        
        result[String(char), default: []].append((rowIdx, colIdx))
      }
    }
    
    return result
  }
}

struct Coordinate: Hashable {
  var row: Int
  var col: Int
}

func isWithinRange(_ coordinate: Coordinate, inMap map: Map) -> Bool {
  coordinate.row >= 0 && coordinate.row < map.lines.count && coordinate.col >= 0 && coordinate.col < map.lines.first?.count ?? 0
}

struct Day08: AdventDay {
  var data: String
  
  func part1() -> Int {
    let map = Map(data)
    var antinodeMap: Set<Coordinate> = []
    
    for (_, value) in map.antennaMap {
      let permutations = value.permutations(ofCount: 2)
      for permutation in permutations {
        
        let (rowA, colA) = permutation[0]
        let (rowB, colB) = permutation[1]
        let rowDistance = rowA - rowB
        let colDistance = colA - colB
        
        let ant1Row = rowA + rowDistance
        let ant1Col = colA + colDistance
        let ant2Row = rowB - rowDistance
        let ant2Col = colB - colDistance
        
        if isWithinRange(Coordinate(row: ant1Row, col: ant1Col), inMap: map) {
          antinodeMap.insert(Coordinate(row: ant1Row, col: ant1Col))
        }
        
        if isWithinRange(Coordinate(row: ant2Row, col: ant2Col), inMap: map) {
          antinodeMap.insert(Coordinate(row: ant2Row, col: ant2Col))
        }
      }
    }
    
    print(antinodeMap)
    return antinodeMap.count
  }

  func part2() -> Int {
    let map = Map(data)
    var antinodeMap: Set<Coordinate> = []

    
    for (_, value) in map.antennaMap {
      for (row, col) in value {
        antinodeMap.insert(Coordinate(row: row, col: col))
      }
      
      let permutations = value.permutations(ofCount: 2)
      for permutation in permutations {
        
        let (rowA, colA) = permutation[0]
        let (rowB, colB) = permutation[1]
        let rowDistance = rowA - rowB
        let colDistance = colA - colB
        
        let ant1Row = rowA + rowDistance
        let ant1Col = colA + colDistance
        let ant2Row = rowB - rowDistance
        let ant2Col = colB - colDistance
        
        let ant1Coordinate = Coordinate(row: ant1Row, col: ant1Col)
        if isWithinRange(ant1Coordinate, inMap: map) {
          
          var newCoordinate = ant1Coordinate
          while isWithinRange(newCoordinate, inMap: map) {
            antinodeMap.insert(newCoordinate)
            newCoordinate.row += rowDistance
            newCoordinate.col += colDistance
          }
        }
        
        let ant2Coordinate = Coordinate(row: ant2Row, col: ant2Col)
        if isWithinRange(ant2Coordinate, inMap: map) {
          antinodeMap.insert(ant2Coordinate)
          
          var newCoordinate = ant2Coordinate
          while isWithinRange(newCoordinate, inMap: map) {
            antinodeMap.insert(newCoordinate)
            newCoordinate.row -= rowDistance
            newCoordinate.col -= colDistance
          }
        }
      }
    }
    
    return antinodeMap.count
  }
}
