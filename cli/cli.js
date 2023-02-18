#!/usr/bin/env node
// based from https://github.com/tornadocash/tornado-core/blob/master/src/cli.js

const fs = require('fs')
const snarkjs = require('snarkjs')
const crypto = require('crypto')
const circomlib = require('circomlibjs')
const bigInt = snarkjs.bigInt
const merkleTree = require('fixed-merkle-tree')
const program = require('commander')

const MERKLE_TREE_HEIGHT = 20;

/** Generate random number of specified byte length */
const rbigint = nbytes => snarkjs.bigInt.leBuff2int(crypto.randomBytes(nbytes))

/** Compute pedersen hash */
const pedersenHash = data => circomlib.babyJub.unpackPoint(circomlib.pedersenHash.hash(data))[0]

/** BigNumber to hex string of specified length */
function toHex(number, length = 32) {
    const str = number instanceof Buffer ? number.toString('hex') : bigInt(number).toString(16)
    return '0x' + str.padStart(length * 2, '0')
}

/**
 * Create deposit object from secret and nullifier
 */
function createDeposit({ nullifier, secret }) {
    const deposit = { nullifier, secret }
    deposit.preimage = Buffer.concat([deposit.nullifier.leInt2Buff(31), deposit.secret.leInt2Buff(31)])
    deposit.commitment = pedersenHash(deposit.preimage)
    deposit.commitmentHex = toHex(deposit.commitment)
    deposit.nullifierHash = pedersenHash(deposit.nullifier.leInt2Buff(31))
    deposit.nullifierHex = toHex(deposit.nullifierHash)
    return deposit
}

function generateMerkleProof(depositEventsJsonPath, leafIndex) {
    const depositEventsJson = JSON.parse(fs.readFileSync(__dirname + "/../" + depositEventsJsonPath))
    const leaves = depositEventsJson.commitments.map(commitment => bigInt(commitment).toString())
    const tree = new merkleTree(MERKLE_TREE_HEIGHT, leaves)
    const { pathElements, pathIndices } = tree.path(leafIndex)
    return { pathElements, pathIndices, root: tree.root() }
}

async function generateInput({ depositEventsJsonPath, nullifier, nullifierHash, secret, leafIndex, recipient, relayerAddress = 0, fee = 0 }) {
    // Compute merkle proof of our commitment
    const { root, pathElements, pathIndices } = generateMerkleProof(depositEventsJsonPath, leafIndex)

    // Prepare circuit input
    const input = {
        // Public snark inputs
        root: root,
        nullifierHash: bigInt(nullifierHash).toString(),
        recipient: bigInt(recipient).toString(),
        relayer: bigInt(relayerAddress).toString(),
        fee: bigInt(fee).toString(),

        // Private snark inputs
        nullifier: bigInt(nullifier).toString(),
        secret: bigInt(secret).toString(),
        pathElements: pathElements,
        pathIndices: pathIndices,
    }

    return input
}

async function main() {
    program
        .command('gen-deposit')
        .description('Generate a deposit object (nullifier, secret, preimage, and commitment) and print it to stdout as JSON data')
        .action(() => {
            const deposit = createDeposit({ nullifier: rbigint(31), secret: rbigint(31) })
            const output = {
                nullifier: toHex(deposit.nullifier),
                nullifierHash: toHex(deposit.nullifierHash),
                secret: toHex(deposit.secret),
                preimage: `0x${deposit.preimage.toString("hex")}`,
                commitment: deposit.commitmentHex
            }
            console.log(JSON.stringify(output))
        })
    program
        .command('gen-input <deposit_events_json_path> <nullifier> <nullifier_hash> <secret> <leaf_index> <recipient>')
        .description('Generate the witness of specified deposit commitment and deposit events and print it to stdout as JSON data')
        .action(async (depositEventsJsonPath, nullifier, nullifierHash, secret, leafIndex, recipient) => {
            const input = await generateInput({ depositEventsJsonPath, nullifier, nullifierHash, secret, leafIndex, recipient })
            console.log(JSON.stringify(input))
        })

    try {
        await program.parseAsync(process.argv)
        process.exit(0)
    } catch (e) {
        console.log('Error:', e)
        process.exit(1)
    }
}

main()