struct Calculations  {
  private var calculations: [(answer: Int, params: [Int])]
  
  init(_ input: String) {
    var calcs: [(answer: Int, params: [Int])] = []
    
    let lines = input.split(separator: "\n")
    for line in lines {
      let parts = line.split(separator: ": ")
      calcs.append((
        answer: Int(parts[0]) ?? 0,
        params: parts[1].split(separator: " ").compactMap {Int($0)}
      ))
    }
    calculations = calcs
  }
  
  var allCalculations: [(answer: Int, params: [Int])] {
    calculations
  }
}

let choices = ["*", "+"]

func generatePermutations (forLength length: Int) -> [[String]] {
  var result: [[String]] = [[]]
  
  for _ in 0..<length {
    result = result.flatMap{ perm in
      choices.map { choice in
        perm + [choice]
      }}
  }
  
  return result
}

let choicesWithJoin = ["*", "+", "&"]

func generatePermutationsWithJoin (forLength length: Int) -> [[String]] {
  var result: [[String]] = [[]]
  
  for _ in 0..<length {
    result = result.flatMap{ perm in
      choicesWithJoin.map { choice in
        perm + [choice]
      }}
  }
  
  return result
}
func generateParamsWithJoin (_ params: [Int]) -> [[Int]] {
  var result: [[Int]] = []
  
  for idx in 0..<params.count - 1 {
    let joinedNumber = Int("\(params[idx])\(params[idx + 1])") ?? 0
    let startingParams = Array(params[0..<idx])
    let endingParams = Array(params[(idx + 2)...])
    let newParams = startingParams + [joinedNumber] + endingParams
    result.append(newParams)
    
  }
  return result
}

struct Day07: AdventDay {
  var data: String
  
  func part1() -> Int {
    var result = 0
    
    let calculations = Calculations(data).allCalculations
    for  calculation in calculations {
      let permutations = generatePermutations(forLength: calculation.params.count - 1)
      for permutation in permutations {
        var total = calculation.params[0]
        for (idx, op) in permutation.enumerated() {
          if op == "*" {
            total = total * calculation.params[idx + 1]
          } else {
            total += calculation.params[idx + 1]
          }
        }
        if total == calculation.answer {
          result += calculation.answer
          break
        }
      }
    }
    
    return result
  }
  
  func part2() -> Int {
    var result = 0
    
    let calculations = Calculations(data).allCalculations
    outerloop: for calculation in calculations {
      let permutations = generatePermutations(forLength: calculation.params.count - 1)
      for permutation in permutations {
        var total = calculation.params[0]
        for (idx, op) in permutation.enumerated() {
          if op == "*" {
            total = total * calculation.params[idx + 1]
          } else {
            total += calculation.params[idx + 1]
          }
        }
        if total == calculation.answer {
          result += calculation.answer
          continue outerloop
        }
      }
      
      // Try joining numbers instead
      let permutationsWithJoin = generatePermutationsWithJoin(forLength: calculation.params.count - 1)
      for permutation in permutationsWithJoin {
        var total = calculation.params[0]
        for (idx, op) in permutation.enumerated() {
          if op == "*" {
            total = total * calculation.params[idx + 1]
          } else if op == "+" {
            total += calculation.params[idx + 1]
          } else {
            total = Int("\(total)\(calculation.params[idx + 1])") ?? 0
          }
        }
        if total == calculation.answer {
          result += calculation.answer
          break
        }
      }
    }
    return result
  }
}
