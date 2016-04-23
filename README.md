StateMachinePlayground
======================

A very simple state machine utility (WIP)

```swift
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
```

will produce the following output

```
init1: Optional("TEST")
init2: Optional("TEST")
USER_PLAY nil
```
