import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [[Int]] {
    data.split(separator: "\n").map {
      $0.split(separator: "   ").map { Int($0) ?? 0 }
    }
  }

  func getLists(_ entities: [[Int]]) -> ([Int], [Int]) {
    var list1: [Int] = []
    var list2: [Int] = []

    entities.forEach {
      if $0.count == 2 {
        list1.append($0[0])
        list2.append($0[1])
      }
    }

    return (list1, list2)
  }

  func part1() -> Int {
    var (list1, list2) = getLists(entities)

    list2.sort()

    var result: Int = 0
    for (index, number) in list1.sorted().enumerated() {
      let diff = list2[index] - number
      result += abs(diff)
    }
    return result
  }

  func part2() -> Int {
    var (list1, list2) = getLists(entities)
    list2.sort()

    var result: Int = 0
    list1.forEach { num in
      let matches = list2.filter {
        $0 == num
      }
      result += matches.count * num
    }
    return result
  }
}
