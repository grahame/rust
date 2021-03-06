// error-pattern:fail

fn failfn() {
    fail;
}

resource r(v: *int) unsafe {
    let v2: ~int = unsafe::reinterpret_cast(v);
}

fn main() unsafe {
    let i1 = ~0;
    let i1p = unsafe::reinterpret_cast(i1);
    unsafe::forget(i1);
    let x = @r(i1p);
    failfn();
    log(error, x);
}