pragma circom 2.1.2;

template Multiplier2 () {  
    signal input a;  
    signal input b;  
    signal output out;

    out <== a * b;  
}

template MultiplierN (N) {
    signal input in[N];
    signal output out;
    component multiplier[N-1];

    for (var i = 0; i < N-1; i++) {
        multiplier[i] = Multiplier2();
    }

    multiplier[0].a <== in[0];
    multiplier[0].b <== in[1];
    for (var i = 0; i < N-2; i++) {
        multiplier[i+1].a <== multiplier[i].out;
        multiplier[i+1].b <== in[i+2];
    } 
    out <== multiplier[N-2].out;
}

component main = MultiplierN(10);
