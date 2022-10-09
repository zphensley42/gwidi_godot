#ifndef GWIDI_NATIVE_MODULE_GWIDI_MIDI_H
#define GWIDI_NATIVE_MODULE_GWIDI_MIDI_H

#include <Godot.hpp>
#include <Node.hpp>
#include <string>
#include "GwidiData.h"

namespace godot {

class GwidiMidi : public Node {
    GODOT_CLASS(GwidiMidi, Node)

private:
    void buildDefaultData();

    godot::String state;
    float time_passed;

    GwidiData* m_data;

public:
    static void _register_methods();

    GwidiMidi();
    ~GwidiMidi();

    void _init();
    void _process(float delta);

    void importMidi(const char* filename);

    void toggleNote(int octave, double timeOffset, const std::string &letter);
};

}
#endif //GWIDI_NATIVE_MODULE_GWIDI_MIDI_H
