### Ethernaut Challenges Solutions

Tutorial

```shell
await contract.password()
await contract.authenticate("ethernaut0")
```

```
FORK_URL=https://eth-goerli.g.alchemy.com/v2/{API_KEY}
forge test -vvvv --fork-url $FORK_URL --match-path test/13_GateKeeperOne.test.sol
```
