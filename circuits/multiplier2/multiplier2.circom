pragma circom 2.1.2;

// 回路の定義
template Multiplier2 () {  

   // シグナルの宣言  
   signal input a;  
   signal input b;  
   signal output d;

   // 制約
   c <== a * b;  
}

// インスタンス化
component main = Multiplier2();
