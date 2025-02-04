# Scripts to Facilitate Staking, Unstaking, Unbonding and Unjailing

Here we will find scripts and tools to facilitate working with OneFinity nodes on the OneFinity blockchain network.


## Stake nodes

Use `stake-node.sh` to stake your validator nodes. 

- add your pemFile names to `validator.json`, then 
- edit `stake-node.sh` and change the value of the `NODES=` variable to the number of pemFiles added to `validator.json`. 

Ensure you have sufficient funds in your staking wallet and run the script from the command line.

~~~
$ ./stake-node.sh
~~~

## Unstake nodes

Use `unstake-node.sh` to unstake your validator nodes.

- edit `unstake-node.sh` and paste the list of BLS keys you want to unstake between the lines beginning with `BLS_KEYS=(` and ending with `)`
- the provided script has 4 redacted BLS keys as shown below, replace the sample text with the BLS keys you want to unstake, and save your changes. 

Sample as distributed.

~~~
declare -a BLS_KEYS
BLS_KEYS=(
"10177728 ... 477f3609"
"2d0a36dd ... 0f6c1b89"
"36882474 ... 411eb782"
"388bd521 ... 8c3dad83"
)
~~~

Run the script at the command line.

~~~
$ ./unstake-node.sh
~~~

## Unbond nodes

When a node is unstaked, we have to wait a few epochs before the staked funds can be withdrawn. Once that period has passed we can release the funds back to our wallet by submitting an unbond transaction. 

Use `unbond-node.sh` to release unstaked funds once the waiting period has expired.

- edit `unbond-node.sh` and paste the list of BLS keys you want to unbond between the lines beginning with `BLS_KEYS=(` and ending with `)`
- the provided script has 4 redacted BLS keys as shown below, replace the sample text with the BLS keys you want to unbond, and save your changes. 

Sample as distributed.

~~~
declare -a BLS_KEYS
BLS_KEYS=(
"10177728 ... 477f3609"
"2d0a36dd ... 0f6c1b89"
"36882474 ... 411eb782"
"388bd521 ... 8c3dad83"
)
~~~

Run the script at the command line.

~~~
$ ./unbond-node.sh
~~~

## Unjail nodes

If you have a node that has been jailed due to low rating, you can activate your node again by sending an *unjail* transaction. The amount will be 2.5 $ONE for each jailed node. 

- edit `unjail-node.sh` and paste the list of BLS keys you want to unjail between the lines beginning with `BLS_KEYS=(` and ending with `)`
- the provided script has 4 redacted BLS keys as shown below, replace the sample text with the BLS keys you want to unstake, and save your changes. 

Sample as distributed.

~~~
declare -a BLS_KEYS
BLS_KEYS=(
"10177728 ... 477f3609"
"2d0a36dd ... 0f6c1b89"
"36882474 ... 411eb782"
"388bd521 ... 8c3dad83"
)
~~~

Run the script at the command line.

~~~
$ ./unjail-node.sh
~~~
