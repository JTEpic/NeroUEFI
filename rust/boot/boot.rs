#![no_main]
#![no_std]

use core::time::Duration;
use log::info;
use uefi::prelude::*;

#[entry]
fn main() -> Status {
    uefi::helpers::init().unwrap();
    info!("Booting");
    boot::stall(Duration::from_secs(10));

    // Returns/exits after success
    Status::SUCCESS
}