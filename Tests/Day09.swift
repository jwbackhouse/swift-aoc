import XCTest

@testable import AdventOfCode

final class Day09Tests: XCTestCase {
  // Smoke test data provided in the challenge question

//  let testData = "2333133121111131102"
  let testData = "2333133121414131402"

  func testPart1() throws {
    let challenge = Day09(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "1928")
  }

  func testPart2() throws {
    let challenge = Day09(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "2858")
  }

}

