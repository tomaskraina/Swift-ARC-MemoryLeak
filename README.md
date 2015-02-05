# Swift-ARC-MemoryLeak
This project demonstrates a possible bug causing a memory leak in `Swift` and/or `ARC` for builds with `Optimization Level: Fastest [-O]`

The problem seems to be that the following line creates a strong reference to `delegate` that is never released:

```
if self.delegate?.modelDidSomething? == nil { return }
``` 

## How to reproduce the issue?

The App consists of two view controllers inside a navigation controller: `RootViewController` and `DetailViewController`.

1) Tap button `Show DetailViewController`
2) Tap button `Perform Model Action`
3) Go back to `Root View Controller`

You can notice that the console log looks like this:

```
<Swift_ARC_MemoryLeak.RootViewController: 0x7fc1b1c8b280> - prepareForSegue(_:sender:)
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - viewDidLoad()
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - viewDidAppear
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - performModelAction
<Swift_ARC_MemoryLeak.Model: 0x7fc1b1e52ac0> - doSomething()
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - modelDidSomething
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - viewDidDisappear
```

Now, try to the same just without tapping button `Perform Model Action`:

1) Tap button `Show DetailViewController`
2) Go back to `Root View Controller`

The whole console log looks like this:

```
<Swift_ARC_MemoryLeak.RootViewController: 0x7fc1b1c8b280> - prepareForSegue(_:sender:)
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - viewDidLoad()
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - viewDidAppear
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - performModelAction
<Swift_ARC_MemoryLeak.Model: 0x7fc1b1e52ac0> - doSomething()
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - modelDidSomething
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1f07850> - viewDidDisappear
<Swift_ARC_MemoryLeak.RootViewController: 0x7fc1b1c8b280> - prepareForSegue(_:sender:)
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1caf6e0> - viewDidLoad()
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1caf6e0> - viewDidAppear
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1caf6e0> - viewDidDisappear
<Swift_ARC_MemoryLeak.DetailViewController: 0x7fc1b1caf6e0> - deinit
```

Note that the second time the `DetailViewController` was released from memory (`deinit` called) but wasn't the first time.

A quick profiling session in `Instruments.app` shows that the first instance of `DetailViewController` is still hanging in memory (together with its `Model` instance).

![alt text](https://github.com/tomaskraina/Swift-ARC-MemoryLeak/raw/master/InstrumentsScreenshot1.png "")
![alt text](https://github.com/tomaskraina/Swift-ARC-MemoryLeak/raw/master/InstrumentsScreenshot2.png "")
![alt text](https://github.com/tomaskraina/Swift-ARC-MemoryLeak/raw/master/InstrumentsScreenshot3.png "")

