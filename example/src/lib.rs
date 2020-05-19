use lazy_static::lazy_static;
use libc::size_t;
use prost::Message;
use rand::seq::SliceRandom;
use std::ffi::c_void;
use std::sync::{Arc, RwLock};
use std::time::Duration;

pub mod protos {
    include!(concat!(env!("OUT_DIR"), "/example.protos.rs"));
}

type CallbackFunction = extern "C" fn(
    *const c_void, /* c_context */
    *const u8,     /* proto_data */
    size_t,        /* proto_length */
) -> ();

struct Callback {
    context: Option<*const c_void>,
    callback: Option<CallbackFunction>,
}

unsafe impl Sync for Callback {}
unsafe impl Send for Callback {}

type SharedCallback = Arc<RwLock<Callback>>;

fn send_bytes(callback: &'static SharedCallback, proto_data: &[u8]) {
    let callback = callback.read().unwrap();
    let cb_function = callback.callback.unwrap();
    let cb_context = callback.context.unwrap();
    cb_function(cb_context, proto_data.as_ptr(), proto_data.len());
}

lazy_static! {
    static ref CB: SharedCallback = Arc::new(RwLock::new(Callback {
        context: None,
        callback: None
    }));
    static ref UI_DATA: Arc<RwLock<protos::UpdateUi>> = Arc::new(RwLock::new(protos::UpdateUi {
        intro: "Here's an update".to_owned(),
        lines: vec![
            "hello".to_owned(),
            "there".to_owned(),
            "from rust".to_owned()
        ]
    }));
}

#[no_mangle]
pub extern "C" fn rs_register_callback(c_context: *const c_void, callback: CallbackFunction) {
    println!("rs_register_callback called");
    let mut cb = CB.write().unwrap();
    cb.context = Some(c_context);
    cb.callback = Some(callback);
    wait_and_emit(|v| {
        send_bytes(&CB, v);
    });
}

#[no_mangle]
pub extern "C" fn rs_run_command(proto_data: *const u8, proto_length: size_t) {
    unsafe {
        let proto_vec = std::slice::from_raw_parts(proto_data, proto_length);
        let proto = protos::UiCommand::decode(proto_vec).unwrap();
        dispatch_command(proto)
    };
}

fn dispatch_command(proto: protos::UiCommand) {
    if let Some(c) = proto.command {
        match c {
            protos::ui_command::Command::Shuffle(_) => shuffle(),
        }
    }
}

fn update_ui(proto: &protos::UpdateUi) -> Result<(), Box<dyn std::error::Error>> {
    let cb = CB.read()?;
    match cb.callback {
        Some(cb_fn) => match cb.context {
            Some(cb_ctx) => {
                let mut buf = vec![];
                proto.encode(&mut buf)?;
                cb_fn(cb_ctx, buf.as_ptr(), buf.len());
                Ok(())
            }
            None => Err(From::from("no context registered for callback")),
        },
        None => Err(From::from("no callback registered")),
    }
}

fn shuffle() {
    let mut rng = rand::thread_rng();
    println!("ui data: {:?}", UI_DATA.read().unwrap());
    UI_DATA.write().unwrap().lines.shuffle(&mut rng);
    println!("ui data: {:?}", UI_DATA.read().unwrap());
    update_ui(&UI_DATA.read().unwrap());
}

fn wait_and_emit<F>(handler: F)
where
    F: Fn(&[u8]) -> () + Sync + Send + 'static,
{
    std::thread::spawn(move || {
        std::thread::sleep(Duration::from_secs(2));
        let p = UI_DATA.read().unwrap();
        let mut v = vec![];
        p.encode(&mut v);
        handler(&v);
    });
}
