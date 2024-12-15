import Algorithms

struct Day04: AdventDay {
  var data: String
  
  var entities: [[String]] {
    data.split(separator: "\n").map {
      $0.split(separator: "").map { String($0) }
    }
  }
  
  func getDiagonal1(_ rows: [[String]]) -> [[String]] {
    var result: [[String]] = [[]]
    rows.enumerated().forEach { (rowIndex, row) in
      row.enumerated().forEach { (letterIndex, letter) in
        if result.count <= (letterIndex + rowIndex) {
          result.append([])
        }
        result[rowIndex + letterIndex].append(letter)
      }
    }
    
    return result
  }
  
  func getDiagonal2(_ rows: [[String]]) -> [[String]] {
    var result: [[String]] = [[]]
    rows.enumerated().forEach { (rowIndex, row) in
      row.reversed().enumerated().forEach { (letterIndex, letter) in
        if result.count <= (letterIndex + rowIndex) {
          result.append([])
        }
        result[rowIndex + letterIndex].append(letter)
      }
    }
    
    return result
  }

  func getRows() -> [[String]] {
    var result = [[String]]()
    
    data.split(separator: "\n").enumerated().forEach { (index, line) in
      let lineLetters = line.split(separator: "").map { String($0) }
      result.append(lineLetters)
    }
    
    return result
  }

  func part1() -> Int {
    var result = 0
    var possibleDirections: [[[String]]] = []
    
    let rows = getRows()
    possibleDirections.append(rows)

    var columns = [[String]]()
    rows.forEach { row in
      row.enumerated().forEach { (index, letter) in
        if columns.count <= index {
          columns.append([])
        }
        columns[index].append(letter)
      }
    }
    possibleDirections.append(columns)
    
    let diagonal1 = getDiagonal1(rows)
    possibleDirections.append(diagonal1)
    
    var diagonal2: [[String]] = [[]]
    rows.enumerated().forEach { (rowIndex, row) in
      row.reversed().enumerated().forEach { (letterIndex, letter) in
        if diagonal2.count <= (letterIndex + rowIndex) {
          diagonal2.append([])
        }
        diagonal2[rowIndex + letterIndex].append(letter)
      }
    }
    possibleDirections.append(diagonal2)
    
    for direction in possibleDirections {
      direction.forEach { array in
        var string = array.joined()
        let xmasMatches = string.ranges(of: "XMAS")
        let samxMatches = string.ranges(of: "SAMX")
        result += (xmasMatches.count + samxMatches.count)
      }
    }
    return result
  }
  
  func part2() -> Int {
    var result = 0
    let rows = getRows()
    let diagonal1 = getDiagonal1(rows)
    let diagonal2 = getDiagonal2(rows)
    var middleACoords: [(Int, Int)] = []
    let totalColumns = rows[0].count - 1
    let totalColsMinus1 = totalColumns - 1
    let totalRows = rows.count - 1
    print("totals", totalColumns, totalColsMinus1, totalRows)
    
    diagonal1.enumerated().forEach { index, array in
      let string = array.joined()
      
      let masMatches = string.ranges(of: "MAS")
      let samMatches = string.ranges(of: "SAM")
      let allMatches = masMatches + samMatches
      
      allMatches.forEach { masMatch in
        let startingIndex = string.distance(
          from: string.startIndex,
          to: masMatch
            .lowerBound)
        middleACoords.append((index, startingIndex))
      }
    }
    
    middleACoords.forEach { coords in
      let colIndex = coords.0
      let depthIndex = coords.1
      
      let newCol = colIndex - (
        max(0, (colIndex - totalColumns)) * 2 + (depthIndex * 2)
      ) - 1
      let d2Col = totalColumns + 1 - newCol
      let newDepth = max(0, colIndex - totalColumns) + depthIndex - max(
        0,
        d2Col - totalColumns
      )
      
      
      var d2 = diagonal2[d2Col]
      if newDepth > 0 {
        d2.removeSubrange(0...(newDepth - 1))
      }
      
      let first3Elements = d2.prefix(3)
      let first3String = first3Elements.joined()
     let isMatch = first3String == "MAS" || first3String == "SAM"
      if isMatch {
       result += 1
      }
    }
    return result


  }
}
