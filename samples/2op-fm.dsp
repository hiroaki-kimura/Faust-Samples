
// Simple 2-operator FM synthesizer
//
// Hiroaki Kimura

declare nvoices "16";
import("stdfaust.lib");

//operator function
operator(freq, index, adsr, amp, phase) = os.oscp(freq*index, phase * amp) * adsr;


// UI elements
freq   = hslider("/freq",200,40,2000,0.01);
gain   = hslider("/gain",0.5,0,1,0.01);
gate   = button("/[1]gate");
freq_modulator = hslider("/modulator freq index",1,1,10,1);
amp_modulator = hslider("/modulator amplitude", 1,0,10,0.1);
feedback = hslider("/feedback", 0, 0, 10, 0.01);

adsr(ch, g) = vgroup("op %ch", en.adsr(a, d, s, r, g))
    with {
        a = hslider("[1]attack", 0.1, 0, 10, 0.01);
        d = hslider("[2]decay", 0.1, 0, 10, 0.01);
        s = hslider("[3]sustain", 0.9, 0, 1, 0.01);
        r = hslider("[4]release", 0.5, 0, 10, 0.01);
    };


adsr_carrier = adsr(2, gate);
adsr_modulator = adsr(1, gate);

// op1 has self feedback
op1 = operator(freq, freq_modulator, adsr_modulator, feedback) ~ _;
op2 = operator(freq, 1, adsr_carrier, amp_modulator);
process = op1:op2*gain;