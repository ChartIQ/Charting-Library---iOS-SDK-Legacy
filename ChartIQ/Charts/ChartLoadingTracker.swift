//
//  ChartLoadingTracker.swift
//  ChartIQ
//
//  Created by George Sotiropoulos on 22/08/2018.
//  Copyright © 2018 ROKO. All rights reserved.
//

import Foundation

protocol ChartLoadingTrackingDelegate: class {
    func chartDidFinishLoading(elapsedTimes: [ChartLoadingElapsedTime])
    func chartDidFailLoadingWithError(_ error: Error, elapsedTimes: [ChartLoadingElapsedTime], for url: String)
}


enum ChartLoadingState {
    case start(Date)
    case commit(Date)
    case htmlLoaded(Date)
    case studiesLoaded(Date)
    case loaded
    case failed(Error)
    
    var name: String {
        switch self {
        case .start:
            return "start"
        case .commit:
            return "commit"
        case .htmlLoaded:
            return "htmlLoaded"
        case .studiesLoaded:
            return "studiesLoaded"
        case .loaded:
            return "loaded"
        case .failed:
            return "failed"
        }
    }
}

public class ChartLoadingElapsedTime: NSObject {
    let from: ChartLoadingState
    let to: ChartLoadingState
    public let time: TimeInterval
    
    init(from: ChartLoadingState, to: ChartLoadingState, time: TimeInterval) {
        self.from = from
        self.to = to
        self.time = time
    }
    
    public var step: String {
        return "\(from.name) -> \(to.name)"
    }
}


extension Array where Element == ChartLoadingElapsedTime {
    public var steps: String {
        return self.map { "\($0.step) \($0.time)" }.joined(separator: "\n")
    }
    
    public var totalTime: Double {
        return self.reduce(0.0, { (result, elapsedTime) in
            return result + elapsedTime.time
        })
    }
}

enum ChartLoadingError: Error {
    case timeout
    case contentProcessDidTerminate
    case internalError(String)
}

extension ChartLoadingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .timeout:
            return "timeout"
        case .contentProcessDidTerminate:
            return "content process terminated"
        case .internalError(let message):
            return "internal error \(message)"
        }
    }
}

class ChartLoadingTracker {
    weak var delegate: ChartLoadingTrackingDelegate?
    
    private var elapsedTimes: [ChartLoadingElapsedTime] = []
    private var finished = false
    
    private var state: ChartLoadingState {
        didSet {
            guard !finished else {
                return
            }
            
            switch state {
            case .loaded, .failed:
                finished = true
            default:
                break
            }
            
            switch (oldValue, state) {
            case (.start(let date), .commit),
                 (.commit(let date), .htmlLoaded),
                 (.htmlLoaded(let date), .studiesLoaded),
                 (.studiesLoaded(let date), .loaded),
                 // transitions to failed
            (.start(let date), .failed),
            (.commit(let date), .failed),
            (.htmlLoaded(let date), .failed),
            (.studiesLoaded(let date), .failed):
                let now = Date()
                let elapsedTime = ChartLoadingElapsedTime(from: oldValue, to: state, time: now.timeIntervalSince(date))
                elapsedTimes.append(elapsedTime)
            default:
                assertionFailure("Invalid state transition: \(oldValue.name) -> \(state.name)")
            }
        }
    }
    
    
    init() {
        self.state = .start(Date())
    }
    
    func commit() {
        state = .commit(Date())
    }
    
    func htmlLoaded() {
        state = .htmlLoaded(Date())
    }
    
    func studiesLoaded() {
        state = .studiesLoaded(Date())
    }
    
    func loaded() {
        state = .loaded
        delegate?.chartDidFinishLoading(elapsedTimes: elapsedTimes)
    }
    
    func failed(with error: Error, for url: String) {
        state = .failed(error)
        delegate?.chartDidFailLoadingWithError(error, elapsedTimes: elapsedTimes, for: url)
    }
    
}
