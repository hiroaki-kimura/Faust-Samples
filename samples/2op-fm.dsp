
// Simple 2-operator FM synthesizer
//
// Hiroaki Kimura
// 2021-05-15


import("stdfaust.lib");

//operator function
operator(freq, index, adsr, power, phase) = os.oscp(freq*index, phase * power) * adsr;


// UI elements
gate = button("note on");
freq_carrier = hslider("carrier frequency",500,500,2000,0.1);
freq_modulator = hslider("modulator freq index",1,1,10,1);
power_modulator = hslider("modulator power", 1,0,10,0.1);
feedback = hslider("feedback", 0, 0, 10, 0.01);

//adsr settings
adsr_carrier = en.adsr(0.2, 0.5, 0.8, 0.5, gate);
adsr_modulator = en.adsr(0.8, 0.8, 0.7, 1.0, gate);

// op1 has self feedback
op1 = operator(freq_carrier, freq_modulator, adsr_modulator, feedback) ~ _;
op2 = operator(freq_carrier, 1, adsr_carrier, power_modulator);

// op1 and op2 are connected in series
process = op1:op2;
