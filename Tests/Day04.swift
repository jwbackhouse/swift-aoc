import XCTest

@testable import AdventOfCode

final class Day04Tests: XCTestCase {
  // Smoke test data provided in the challenge question

   let testData = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """

  func testPart1() throws {
    let challenge = Day04(data: testData)
    XCTAssertEqual(String(describing: challenge.part1()), "18")
  }

  func testPart2() throws {
    let challenge = Day04(data: testData)
    XCTAssertEqual(String(describing: challenge.part2()), "9")
  }
}
