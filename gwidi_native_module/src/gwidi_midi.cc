#include "include/gwidi_midi.h"
#include <sstream>

#include "GwidiOptions.h"
#include "GwidiTickHandler.h"

#define TEST_FILE R"(/home/zhensley/repos/gwidi_godot/gwidi_midi_parser/assets/moana.mid)"

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

// TODO: For proof of concept, begin converting the data here to something we can use in the editor?
// TODO: Need methods of adding data when we perform actions in the editor
// TODO: The below worked as a test to link to gwidi and output a parsed midi file (now we just need this to be per a user action
// TODO: originating from godot first, with options for the file)

void GwidiMidi::importMidi(const char* filename) {
    {
        std::stringstream ss;
        ss << "Importing MIDI: " << filename;
        Godot::print(ss.str().c_str());
    }
    auto data = GwidiMidiParser::getInstance().readFile(filename, gwidi::options::MidiParseOptions{
            gwidi::options::InstrumentOptions::Instrument::HARP
    });
    auto tickHandler = GwidiTickHandler();
    tickHandler.setOptions(GwidiTickOptions{
            GwidiTickOptions::ActionOctaveBehavior::HIGHEST
    });
    tickHandler.assignData(data);

    auto &tracks = data->getTracks();
    {
        std::stringstream ss;
        ss << "number of tracks detected: : " << tracks.size();
        Godot::print(ss.str().c_str());
    }

    {
        std::stringstream ss;
        ss << "MIDI imported: " << filename;
        Godot::print(ss.str().c_str());
    }
}

void GwidiMidi::_init() {
    state = "Started!";
    time_passed = 0.f;

    // For testing, just import as soon as we start
    importMidi(TEST_FILE);
}

void GwidiMidi::_process(float delta) {
    time_passed += delta;

    std::stringstream ss;
    ss << "time_passed: " << time_passed;
    Godot::print(ss.str().c_str());
}

}
