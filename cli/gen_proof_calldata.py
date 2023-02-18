import subprocess
import json

call = subprocess.run('snarkjs generatecall build/public.json build/proof.json'.split(), capture_output=True, text=True).stdout
a, b, c, _input = eval(call)
proof = a[0][2:] + a[1][2:] \
    + b[0][0][2:] + b[0][1][2:] + b[1][0][2:] + b[1][1][2:] \
    + c[0][2:] + c[1][2:]
json.dump({"proof": "0x" + proof}, open("tmp/proof_calldata.json", "w"))
