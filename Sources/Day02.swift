import Algorithms

struct Day02: AdventDay {
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: " ").map { Int($0) ?? 0 }
    }
  }

  func isInvalid(first: Int, prev: Int, isAsc: Bool) -> Bool {
    return (isAsc && first <= prev)
      || (!isAsc && first >= prev)
      || abs(first - prev) > 3
  }

  func check(_ report: [Int]) -> (Bool, Int?) {
    let isAsc = report[1] > report[0]

    for i in 0..<report.count {
      if i >= report.count - 1 {
        break
      }

      if isInvalid(first: report[i + 1], prev: report[i], isAsc: isAsc) {
        return (false, i)
      }
    }
    return (true, nil)
  }

  func part1() -> Int {
    var result = 0

    outerloop: for report in entities {
      let isAsc = report[1] > report[0]

      for i in 1..<report.count {
        if isInvalid(first: report[i], prev: report[i - 1], isAsc: isAsc) {
          continue outerloop
        }
      }
      result += 1
    }

    return result
  }
  
  func part2() -> Int {
    var result = 0

    for rawReport in entities {
      let (isValid, _err) = check(rawReport)
      if isValid {
        result += 1
        continue
      }
      
      for i in 0..<rawReport.count {
        var report = rawReport
        report.remove(at: i)
        
        let (isValid, _err) = check(report)
        if isValid {
          result += 1
          break
        }
        
      }
    }
    return result
  }
}
