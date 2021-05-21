
// Simple 2-operator FM synthesizer
//
// Hiroaki Kimura

declare nvoices "16";
import("stdfaust.lib");

//operator function
operator(freq, index, adsr, amp, phase) = os.oscp(freq * index, phase) * amp * adsr;


// UI elements
freq   = hslider("/[2]freq",200,40,2000,0.01);
gain   = hslider("/[3]gain",0.5,0,1,0.01);
gate   = button("/[1]gate");
feedback = hslider("/[4]op1 feedback", 0, 0, 7, 1);


adsr(g) = vgroup("[9]ADSR", en.adsr(a, d, s, r, g))
    with {
        a = hslider("[1]attack", 0.1, 0, 10, 0.01);
        d = hslider("[2]decay", 0.1, 0, 10, 0.01);
        s = hslider("[3]sustain", 0.9, 0, 1, 0.01);
        r = hslider("[4]release", 0.5, 0, 10, 0.01);
    };

operator_control(ch, phase) = hgroup("[9]Operator #%ch", operator(freq, _index, _adsr, _amp, phase))
    with {
        _adsr = adsr(gate);
        _index = vslider("[1]freq index",1,1,10,1);
        _amp = vslider("[0]amp", 1,0,10,0.1);
    };

//0, PI/16, PI/8, PI/4, PI/2, PI, PI x 2, PI x 4
feedbacktable = waveform{0,0.1963495,0.392699,0.785398,1.570796,3.141592,6.2831,12.566};
fbvalue = feedbacktable,int(feedback):rdtable;
op1 = operator_control(1) ~ * (fbvalue);
op2 = operator_control(2);
process = tgroup("[5]Operator control", op1:op2)*gain;
