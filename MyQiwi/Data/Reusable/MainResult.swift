import Foundation

enum MainResult<Success, Failure> where Failure: Error {
  case success(Success)
  case failure(Failure)
}
