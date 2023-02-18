pragma circom 2.1.2;

template Multiplier3 () {
    signal input a;
    signal input b;
    signal input c;
    signal ab;
    signal output abc;

    ab <== a * b;
    abc <== ab * c;
}

component main = Multiplier3();
