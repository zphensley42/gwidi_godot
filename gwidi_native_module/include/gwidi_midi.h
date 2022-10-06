#ifndef GWIDI_NATIVE_MODULE_GWIDI_MIDI_H
#define GWIDI_NATIVE_MODULE_GWIDI_MIDI_H

#include <Godot.hpp>
#include <Node.hpp>

namespace godot {

class GwidiMidi : public Node {
    GODOT_CLASS(GwidiMidi, Node)

private:
    godot::String state;
    float time_passed;

public:
    static void _register_methods();

    GwidiMidi();
    ~GwidiMidi();

    void _init();
    void _process(float delta);

    void importMidi(const char* filename);
};

}
#endif //GWIDI_NATIVE_MODULE_GWIDI_MIDI_H
