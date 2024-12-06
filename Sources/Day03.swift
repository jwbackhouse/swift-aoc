import Algorithms

struct Day03: AdventDay {
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").map { Int($0) ?? 0 }
    }
  }

  func calculateResult(for string: String) -> Int {
    if let bracketIndex = string.firstIndex(of: ")") {
      let distance = string.distance(from: string.startIndex, to: bracketIndex)
      // discard if closing parenthensis too far away
      if distance > 7 {
        return 0
      }

      let substring = string[string.startIndex..<bracketIndex]
      //        print("valid: '\(substring)'")

      let commaSplit = substring.split(separator: ",")
      // discard if no separating comma
      if commaSplit.count != 2 {
        return 0
      }
      let first = commaSplit[0]
      let second = commaSplit[1]
      if first.allSatisfy({ $0.isNumber })
        && second.allSatisfy(
          {
            $0.isNumber
          })
      {
        if let firstInt = Int(first), let secondInt = Int(second) {
          return firstInt * secondInt
        }
      }
    }
    return 0
  }

  func part1() -> Int {
    let stringSplits = data.split(separator: "mul(")
    var result = 0

    for split in stringSplits {
      result += calculateResult(for: String(split))
    }
    return result
  }

  func part2() -> Int {
    var remaining = data
    var isLive = true
    var result = 0
    var count = 0

    while remaining.count > 0 {
      let mulIndex = remaining.range(of: "mul(")
      let doIndex = remaining.range(of: "do()")
      let dontIndex = remaining.range(of: "don't()")
      let swapIndex = isLive ? dontIndex : doIndex

      if mulIndex != nil,
        let swapStart = swapIndex?.lowerBound
      {
        let swapDistance = remaining.distance(
          from: remaining.startIndex,
          to: swapStart
        )

        // Bail if in a don't state
        if !isLive {
          remaining.removeFirst(swapDistance + 4)
          isLive = true
          count += 1
          continue
        }

        let validSubString = remaining.prefix(swapDistance)
        let stringSplits = validSubString.split(separator: "mul(")
        for split in stringSplits {
          result += calculateResult(for: String(split))
        }
        remaining.removeFirst(swapDistance + 4)
        isLive = false
      }

      if doIndex == nil || dontIndex == nil {
        let stringSplits = remaining.split(separator: "mul(")
        for split in stringSplits {
          result += calculateResult(for: String(split))
        }
        break
      }

    }

    return result
  }
}
