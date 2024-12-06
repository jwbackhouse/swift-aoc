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
    guard let bracketIndex = string.firstIndex(of: ")"),
      string.distance(from: string.startIndex, to: bracketIndex) <= 7
    else {
      return 0
    }

    let substring = string[string.startIndex..<bracketIndex]
    let commaSplit = substring.split(separator: ",")
    guard commaSplit.count == 2,
      let firstInt = Int(commaSplit[0]),
      let secondInt = Int(commaSplit[1])
    else {
      return 0
    }
    return firstInt * secondInt
  }

  func part1() -> Int {
    data.split(separator: "mul(").reduce(0) { result, split in
      result + calculateResult(for: String(split))
    }
  }

  func part2() -> Int {
    var remaining = data
    var isLive = true
    var result = 0

    while !remaining.isEmpty {

      let mulIndex = remaining.range(of: "mul(")
      let doIndex = remaining.range(of: "do()")
      let dontIndex = remaining.range(of: "don't()")
      let swapIndex = isLive ? dontIndex : doIndex

      guard let swapStart = swapIndex?.lowerBound else {
        result += remaining.split(separator: "mul(").reduce(0) {
          result, split in
          result + calculateResult(for: String(split))
        }
        break
      }

      let swapDistance = remaining.distance(
        from: remaining.startIndex,
        to: swapStart
      )

      if isLive {
        let validSubString = remaining.prefix(swapDistance)
        result += validSubString.split(separator: "mul(").reduce(0) {
          result, split in
          result + calculateResult(for: String(split))
        }
      }
      // Bail if in a don't state

      remaining.removeFirst(swapDistance + 4)
      isLive.toggle()
    }

    return result
  }
}
