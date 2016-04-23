//: StateMachinePlayground: a very simple state machine

import Cocoa

// -------------------------------------------------------------------
public enum TransitionError : ErrorType {
    //TODO: deal with errors
}

public typealias TransitionHandler = (data:Any?) -> ()

public class State<T:Hashable> : CustomDebugStringConvertible {
    let state:T
    required public init(_ data:T) {
        self.state = data
    }
    public var debugDescription:String {
        return "[state:\(state)]"
    }
}

struct Transition<T:Hashable> : CustomDebugStringConvertible {
    let from:State<T>?
    let to:State<T>?
    var handler:TransitionHandler?
    
    var debugDescription:String {
        return "[\(from)->\(to): \(handler)]"
    }
    
}

public class StateMachine<T:Hashable> : CustomPlaygroundQuickLookable{
    
    var state:State<T>?
    var transitions:[Transition<T>] = []
    
    required public init() {
    }
    required public init(_ initialState: T) {
        self.state = State(initialState)
    }
    
    public func onEnter(state:T, handler:TransitionHandler) {
        onEnter(State(state), handler: handler)
    }
    
    func onEnter(state:State<T>, handler:TransitionHandler) {
        let t = Transition(from:nil, to:state, handler:handler)
        transitions.append(t)
    }
    
    public func onLeave(state:T, handler:TransitionHandler) {
        onLeave(State(state), handler: handler)
    }
    
    public func onLeave(state:State<T>, handler:TransitionHandler) {
        let t = Transition(from:state, to:nil, handler:handler)
        transitions.append(t)
    }
    
    public func transitionTo(state:T) {
        transitionTo(State(state), data: nil)
    }
    func transitionTo(state:State<T>) {
        transitionTo(state, data: nil)
    }
    public func transitionTo(state:T, data:Any?) {
        transitionTo(State(state), data: data)
    }
    
    func transitionTo(state:State<T>, data:Any?) {
        if let current = self.state {
            do {
                try? performTransition(current, to: state, data: data)
                self.state = state
            } catch {
                //TODO: errors
            }
        } else {
            
        }
    }
    
    public func getState() -> State<T>? {
        return state
    }
    
    func performTransition(from:State<T>, to:State<T>, data:Any?) throws {
        let source = transitions.filter { (t) in
            return t.from?.state == from.state
        }
        let target = transitions.filter { (t) in
            return t.to?.state == to.state
        }
        source.forEach { $0.handler?(data: data) }
        target.forEach { $0.handler?(data: data) }
    }
    
    public func customPlaygroundQuickLook() -> PlaygroundQuickLook {
        var s = ""
        for t in self.transitions {
            s += (t.debugDescription + " ")
        }
        return .Text("[\(s)]")
    }
}

// -------------------------------------------------------------------

public enum GameState {
    case UNINITIALIZED
    , INITIALIZE
    , COMPUTER_PLAY
    , USER_PLAY
    , ENDED
}

var sm = StateMachine(GameState.UNINITIALIZED)
sm.onEnter(.INITIALIZE) { (data) in
    print("init1: \(data)")
}
sm.onEnter(.INITIALIZE) { (data) in
    print("init2: \(data)")
}
sm.onEnter(.USER_PLAY) { (data) in
    print("USER_PLAY \(data)")
}

sm.transitionTo(.INITIALIZE, data:"TEST")
sm.transitionTo(.USER_PLAY)
