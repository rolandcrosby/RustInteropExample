# Rust/Swift Interop Example

This is an attempt to write a library in Rust and build a SwiftUI app around it, passing data between the two using protocol buffers. I have it working on my laptop, which is running macOS 10.15 with Xcode 11.4.

## Rust code

The `example/` directory contains the Rust library project. Entry points from the Swift side are the `rs_register_callback` and `rs_run_command` functions. `rs_register_callback` is used to set up a callback function so Rust can send values to Swift at its discretion, while Swift code can use `rs_run_command` to send a protobuf that Rust can do something with.

I'm storing the callback info in a struct inside a static `Arc<RWLock<>>`. I _think_ this should help make it safe to pass C function/opaque pointers across threads; in any event adding empty `unsafe impl Sync`/`Send` implementations seemed to work. I could use some advice as to whether this is proper or if I should be doing something different here.

## Swift code

On the Swift side, `RustInterface.swift` handles the calls to the functions mentioned above. I am really not sure what I'm doing with the pointers that I'm passing from Swift to Rust - everything here seems to work but I'm not sure why or whether something is going to explode.

The rest of the Swift code is mainly my attempt to figure out how to use SwiftUI and Combine. It's not pretty, but I'm less concerned about that part since it seems to have a friendly API and good error messages that I can generally use to figure out what's broken.

## Protobufs

I have a couple of message types that I've defined; these are in `example/src/example.proto`. `UpdateUI` contains all the data that's shown in the main screen of the UI, while `UICommand` is used for sending commands from Swift to Rust. I'm not sure what an appropriate pattern is for encapsulating this kind of thing so would appreciate any advice. Specifically, for `UICommand`, I'm trying to make an extensible type that I can add more variants to in the future; is the `oneof` implementation I've done here appropriate or are there better patterns? 

## Building

I used [`cargo-xcode`][cargo-xcode] to generate an Xcode project for the Rust library. 

To generate `example.pb.swift`, I manually ran `protoc` after installing the [Swift plugin][protoc-swift]; I haven't yet figured out a good way to build this into the dev workflow.

[cargo-xcode]: https://crates.io/crates/cargo-xcode
[protoc-swift]: https://github.com/apple/swift-protobuf

