struct DiskMap {
  private(set) var data: [Int] = []
  private(set) var gaps: [Int] = []
  
  init(_ input: String) {
    let numbers = input.compactMap { Int(String($0)) }
    data = stride(from: 0, to: numbers.count, by: 2).map { numbers[$0] }
    gaps = stride(from: 1, to: numbers.count, by: 2).map { numbers[$0] }
  }
}

struct Day09: AdventDay {
  var data: String
  
  func part1() -> Int {
    let diskMap = DiskMap(data)
    var data = diskMap.data
    var filledGaps = [[Int]]()
    
    for (index, gap) in diskMap.gaps.enumerated() {
      if gap == 0 {
        continue
      }
      if index >= data.count - 1 {
        break
      }
      while filledGaps.count <= index + 1 {
        filledGaps.append([])
        
      }
      
      var remainingGap = gap
      while remainingGap > 0 {
        let count = min(remainingGap, data.last!)
        let newData = Array(repeating: data.count - 1, count: count)
        filledGaps[index].append(contentsOf: newData)
        
        data[data.endIndex - 1] -= count
        if data.last! == 0 {
          data.removeLast()
        }
        remainingGap -= count
      }
    }
    
    var result = 0
    var rollingIndex = 0
    for (index, entry) in data.enumerated() {
      for _ in 1...entry {
        result += index * rollingIndex
        rollingIndex += 1
      }
      if index >= filledGaps.count {
        break
      }
      
      for gapEntry in filledGaps[index] {
        result += gapEntry * rollingIndex
        rollingIndex += 1
        
      }
    }
    return result
  }
  
  func part2() -> Int {
    let diskMap = DiskMap(data)
    var dataReversed = Array(diskMap.data.reversed())
    let datalength = dataReversed.count
    var updatedGaps = diskMap.gaps
    var filledGaps = [[Int]]()
    
    // Create empty array to hold files
    while filledGaps.count < (dataReversed.count - 1) {
      filledGaps.append([])
    }
    
    // Loop over each file, starting at the end
    for (dataIndex, data) in dataReversed.enumerated() {
      for (gapIndex, gap) in updatedGaps.enumerated() {
        if gapIndex > datalength - dataIndex {
          // Files can only be moved left, not right
          break
        }
        
        if gap >= data {
          let newData = Array(
            repeating: datalength - dataIndex - 1, count: data)
          filledGaps[gapIndex].append(contentsOf: newData)
          // Update remaining gap that could hold later files
          updatedGaps[gapIndex] -= data
          // Mark data as having been moved
          dataReversed[dataIndex] = -data
          
          break
        }
      }
    }
    
    // Populate 'filledGaps' with all unused gaps
    for (gapIndex, gap) in updatedGaps.enumerated() {
      if gap > 0 {
        filledGaps[gapIndex].append(contentsOf: Array(repeating: 0 , count: gap))
      }
    }
    let finalData = Array(dataReversed.reversed())
    
    // Calculate result
    var result = 0
    var rollingIndex = 0
    for (index, entry) in finalData.enumerated() {
      if entry < 0 {
        // File has moved, but still need to increment index
        for _ in 1...abs(entry) {
          rollingIndex += 1
        }
      } else {
        // Add file position to result
        for _ in 1...entry {
          result += index * rollingIndex
          rollingIndex += 1
        }
      }
      if index >= filledGaps.count {
        break
      }
      
      // Add moved files to result
      for gapEntry in filledGaps[index] {
        result += gapEntry * rollingIndex
        rollingIndex += 1
      }
    }
    return result
  }
}

