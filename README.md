<div align="center">

<img src="./assets/ethernaut-CTF.webp" width="1200px"/>
<br><br>
<h1><strong>OpenZeppelin Ethernaut Solutions</strong></h1>

</div>
<br></br>

## Description

This repository contains the solutions for the [Ethernaut CTF challenges](https://ethernaut.openzeppelin.com/) from OpenZeppelin. The Ethernaut is a Web3/Solidity based wargame inspired by [overthewire.org](https://overthewire.org/wargames/). Each level is a smart contract that needs to be hacked in order to advance to the next level. The challenges are designed to teach the basics of smart contract security and the vulnerabilities that can be found in Solidity code.

- The `challenges` folder contains all the initial Ethernaut smart contracts.
- The `solutions` folder contains the explanations to understand how to beat each level.
- The `src` folder contains the solutions for each level (solidity and/or scripts in the browser console).
- The `script` folder contains the scripts to deploy the solutions contained in the `src` folder.
- The `helpers` folder contains some older OpenZeppelin contracts that are needed to compile the challenges.
- The `test` folder contains tests for some levels.

## Tutorial

```shell
await contract.password()
await contract.authenticate("ethernaut0")
```

```
FORK_URL=https://eth-sepolia.g.alchemy.com/v2/{API_KEY}
forge test -vvvv --fork-url $FORK_URL --match-path test/13_GateKeeperOne.test.sol
```

## Solutions

- [x] [Lvl 0 Hello Ethernaut](./solutions/00_HelloEthernaut.md)
- [x] [Lvl 1 Fallback](./solutions/01_Fallback.md)
- [x] [Lvl 2 Fal1out](./solutions/02_Fal1out.md)
- [x] [Lvl 3 Coin Flip](./solutions/03_CoinFlip.md)
- [x] [Lvl 4 Telephone](./solutions/04_Telephone.md)
- [x] [Lvl 5 Token](./solutions/05_Token.md)
- [x] [Lvl 6 Delegation](./solutions/06_Delegation.md)
- [x] [Lvl 7 Force](./solutions/07_Force.md)
- [x] [Lvl 8 Vault](./solutions/08_Vault.md)
- [x] [Lvl 9 King](./solutions/09_King.md)
- [x] [Lvl 10 Re-entrancy](./solutions/10_Reentrancy.md)
- [x] [Lvl 11 Elevator](./solutions/11_Elevator.md)
- [x] [Lvl 12 Privacy](./solutions/12_Privacy.md)
- [x] [Lvl 13 Gate Keeper 1](./solutions/13_GateKeeperOne.md)
- [x] [Lvl 14 Gate Keeper 2](./solutions/14_GateKeeperTwo.md)
- [x] [Lvl 15 Naught Coin](./solutions/15_NaughtCoin.md)
- [x] [Lvl 16 Preservation](./solutions/16_Preservation.md)
- [x] [Lvl 17 Recovery](./solutions/17_Recovery.md)
- [x] [Lvl 18 MagicNumber](./solutions/18_MagicNumber.md)
- [x] [Lvl 19 Alien Codex](./solutions/19_AlienCodex.md)
- [x] [Lvl 20 Denial](./solutions/20_Denial.md)
- [x] [Lvl 21 Shop](./solutions/21_Shop.md)
- [x] [Lvl 22 Dex](./solutions/22_Dex.md)
- [x] [Lvl 23 Dex Two](./solutions/23_DexTwo.md)
- [x] [Lvl 24 Puzzle Wallet](./solutions/24_PuzzleWallet.md)
- [ ] [Lvl 25 Motorbike](./solutions/25_Motorbike.md) (unbeatable since Dencun upgrade, issue with selfdestruct new behavior, see EIP6780)
- [x] [Lvl 26 Double Entry Point](./solutions/26_DoubleEntryPoint.md)
- [x] [Lvl 27 Gate Keeper 3](./solutions/27_GateKeeperthree.md)
- [x] [Lvl 28 Good Samaritan](./solutions/28_GoodSamaritan.md)
- [x] [Lvl 29 Switch](./solutions/29_Switch.md)
