# CircomLib

## `MiMCSponge`テンプレート

tornado-coreで指定されているバージョンではラウンドは固定で220でしたがが、現在はラウンドを指定できるようになっています。

## `Pedersen`テンプレート

```js
template Pedersen(n) {
    signal input in[n];
    signal output out[2];

	// 省略
}
```

## `Num2Bits`テンプレート

```js
template Num2Bits(n) {
    signal input in;
    signal output out[n];
    var lc1=0;

    var e2=1;
    for (var i = 0; i<n; i++) {
        out[i] <-- (in >> i) & 1;
        out[i] * (out[i] -1 ) === 0;
        lc1 += out[i] * e2;
        e2 = e2+e2;
    }

    lc1 === in;
}
```

