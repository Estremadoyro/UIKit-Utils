import UIKit

func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
  var numList = nums

  for i in 0 ..< nums.count {
    let currentNumber = numList.remove(at: i)
    for j in 0 ..< numList.count {
      if currentNumber + numList[j] == target {
        print("current: \(currentNumber), j: \(numList[j])")
        return [i, j + 1]
      }
    }
    numList.insert(currentNumber, at: i)
  }
  return [100]
}

// doesnt work
func twoSum2(_ nums: [Int], _ target: Int) -> [Int] {
  // greater to lower
  let possibleNums = nums.filter { $0 < target }
  print(possibleNums)
  for i in 0 ..< possibleNums.count - 1 {
    let missing = target - possibleNums[i]
    print("missing: \(missing)")
    if possibleNums[i + 1] == missing {
      return [i, i + 1]
    }
  }
  return [100]
}

// 2 7 11 15

let result = twoSum([0, 4, 3, 0], 0)
// let result2 = twoSum2([3, 2, 3], 6)
print(result)
