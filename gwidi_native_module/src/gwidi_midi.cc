#include "include/gwidi_midi.h"
#include <sstream>

namespace godot {

void GwidiMidi::_register_methods() {
    register_method("_process", &GwidiMidi::_process);
    register_property<GwidiMidi, float>("time_passed", &GwidiMidi::time_passed, 0.f);
    register_property<GwidiMidi, godot::String>("state", &GwidiMidi::state, "");
}


GwidiMidi::GwidiMidi() {

}

GwidiMidi::~GwidiMidi() {

}

void GwidiMidi::_init() {
    state = "Started!";
    time_passed = 0.f;
}

void GwidiMidi::_process(float delta) {
    time_passed += delta;

    std::stringstream ss;
    ss << "time_passed: " << time_passed;
    Godot::print(ss.str().c_str());
}

}
