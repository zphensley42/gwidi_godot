#include "gwidi_midi.h"
#include <sstream>

#include "gwidi/gwidi_midi_parser.h"
#include "gwidi/GwidiOptions2.h"
#include "gwidi/GwidiTickHandler.h"

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
    auto data = gwidi::midi::GwidiMidiParser::getInstance().readFile(filename, gwidi::midi::MidiParseOptions {
            gwidi::midi::Instrument(gwidi::midi::Instrument::HARP)
    });
    auto tickHandler = gwidi::tick::GwidiTickHandler();
    tickHandler.setOptions(gwidi::tick::GwidiTickOptions {
            gwidi::tick::GwidiTickOptions::ActionOctaveBehavior::HIGHEST
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
    buildDefaultData();
}

void GwidiMidi::_process(float delta) {
    time_passed += delta;

    std::stringstream ss;
    ss << "time_passed: " << time_passed;
    // Godot::print(ss.str().c_str());
}

void GwidiMidi::buildDefaultData() {
    m_data = new GwidiData();
    std::vector<Note> notes{};
    m_data->addTrack("Piano", "Default", notes, 300);
    // need to ensure that we update the track duration when we add notes
}

// TODO: Another idea instead of doing individual toggles is to treat the GUI data separately and translate it all to
// TODO: GwidiData when we attempt to play it?
void GwidiMidi::toggleNote(int octave, double timeOffset, const std::string &letter) {
    // assume we are always editing track 0 (for now, probably need to ensure this for cases where we have imported a midi file)
    // TODO: probably just enforce a single track after import

    // 'toggling' a note in our sense means adding or removing it from the data
    // the existence of a note in the tickMap will cause that note to play during tick handling
    // so, we just need to ensure that we can remove from the map if it exists and add it if it does not

    auto &tickMap = m_data->getTickMap();
    auto &track1 = tickMap[0];
    auto noteIt = track1.find(timeOffset);
    if(noteIt != track1.end()) {
        auto &notes = noteIt->second;
        for(auto &note : notes) {
            if(note.key == letter && note.octave == octave) {
                // TODO: Can do this with a find_if or something
                // TODO: if we find it, we need to remove it
                // TODO: if we can't find it, we need to add it

                // TODO: adding to tick map works to ensure it plays, but tick map is just a mapping of the tracks themselves
                // TODO: so, we need to eventually propagate the tick map changes back to the track listing (maybe when we save the file?)
                break;
            }
        }
    }
}


}
