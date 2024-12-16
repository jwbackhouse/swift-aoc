import Algorithms

struct Day05: AdventDay {
  var data: String
  
  var entities: (orderingRules: [[Int]], updates: [[Int]]) {
    let parts = data.split(separator: "\n\n")
    let orderingRules = parts[0].split(separator: "\n").map {
      $0.split(separator: "|").compactMap {Int($0)}
    }
    
    let updates = parts[1].split(separator: "\n").map {
      $0.split(separator: ",").compactMap {Int($0)}
    }
    
    return (orderingRules: orderingRules, updates: updates)
  }
  
  func getDictionary() -> [Int: [Int]] {
    let orderingRules = entities.orderingRules
    
    let rules: [Int: [Int]] = orderingRules.reduce(into: [:]) { dict, orderPair in
      dict[orderPair[1], default: []].append(orderPair[0])
    }
    
    return rules
  }
  
  
  func part1() -> Int {
    var validUpdates: [[Int]] = []
    let dict = getDictionary()
    let updates = entities.updates
    
    for update in updates {
      var reversedUpdate = Array(update.reversed())
      var removedNums = [reversedUpdate.removeFirst()]
      
      for num in reversedUpdate {
        if let dictValues = dict[num] {
          if removedNums.contains(where: dictValues.contains) {
            break
          }
        }
        if reversedUpdate.count == 1 {
          validUpdates.append(update)
        } else {
          removedNums.append(reversedUpdate.removeFirst())
        }
      }
    }
    
    // TIL that Swift floors the results of Integer division, so this 'just works'
    let result = validUpdates.map { $0[$0.count / 2] }.reduce(0, +)
    print(result)
    return result
  }
  
  func part2() -> Int {
    var invalidUpdates: [[Int]] = []
    var reorderedUpdates: [[Int]] = []
    let dict = getDictionary()
    let updates = entities.updates
    
    for update in updates {
      var reversedUpdate = Array(update.reversed())
      var removedNums = [reversedUpdate.removeFirst()]
      
      for num in reversedUpdate {
        if let dictValues = dict[num] {
          if removedNums.contains(where: dictValues.contains) {
            invalidUpdates.append(update)
            break
          }
        }
        if reversedUpdate.count == 1 {
          break
        } else {
          removedNums.append(reversedUpdate.removeFirst())
        }
      }
    }
    
    for var update in invalidUpdates {
      update.sort {
        let dictValues0 = dict[$0] ?? []
        let dictValues1 = dict[$1] ?? []
        if dictValues0.contains($1) {
          return false
        } else {
          return true
        }
      }
      reorderedUpdates.append(update)
    }
    
    let result = reorderedUpdates.map { $0[$0.count / 2] }.reduce(0, +)
    print(result)
    return result
  }
}
