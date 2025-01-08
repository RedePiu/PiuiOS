import Foundation

enum MainResponse<T> {
    case success(model: T)
    case error(error: String)
}
