pragma circom 2.0.0;

template Multiplier2 () {  
   signal input a;  
   signal input b;  
   signal output out;

   out <== a * b;  
}

template Multiplier3 () {
   signal input a;
   signal input b;
   signal input c;
   signal output out;
   component multiplier2_1 = Multiplier2();
   component multiplier2_2 = Multiplier2();

   multiplier2_1.a <== a;
   multiplier2_1.b <== b;
   multiplier2_2.a <== multiplier2_1.out;
   multiplier2_2.b <== c;
   out <== multiplier2_2.out;
}

component main = Multiplier3();
