# Configure Multikey for OneFinity Validators

Here is the process required to be run on the OneFinity validator node to implement a Multikey configuration. 

These instructions assume that the OneFinity testnet is installed according to the document published by the OneFinity team 2025-Jan-23, in the "OneFinity Testnet Live" announcement made in the OneFinity Validators Telegram group. 

For a detailed description of the Multikey architecture you can refer to: 
[OneFinity Docs - Multikey Nodes](https://docs.onefinity.network/technology/run-a-onefinity-node/keys/multikey-nodes)
for details.

To complete the Multikey setup we will need to complete three separate tasks, as follows:

- generate N validator keys using `keygenerator`,
- concatenate all `validatorKey.pem` files into `allValidatorsKeys.pem`,
- extract all BLS public keys from `allValidatorsKeys.pem`, format them, and add them to `prefs.toml`.

Examples presented here are based on my setup on OneFinity Testnet for a staking agency named _Pale Blue Dot_, consisting of one observer node name named _Pale Blue Dot 0_, and 16 validator nodes named _pale-blue-00_ .. _pale-blue-15_. 


## Generate validator keys using the keygenerator utility

We'll be doing our work in the `onefinity/config` directory, so let's start by going there now.
~~~
$ cd ~/onefinity-testnet-validators/onefinity/config
~~~

We'll need to run the `keygenerator` utility, so add `~/onefinity-utils` to our PATH. 

~~~
$ export PATH=$PATH:~/onefinity-utils
~~~

A Multikey node requires that the node be configured to run as an observer.  If you already staked a node, we need to save the validatorKey.pem file, otherwise we skip that step as it is not required. 

- **If your node is already staked** - Rename your `validatorKey.pem` file to `allValidatorsKeys.pem`, otherwise proceed to the next step.

~~~
$ mv validatorKey.pem allValidatorsKeys.pem
~~~

Generate a series of validator keys. 

- Use the `keygenerator` utility to generate a series of validator keys. Set `--num-keys=` to the number of keys you wish to generate. Adding `--no-split` puts all of the keys in a single file named `validatorKey.pem`.

~~~
$ keygenerator --num-keys=16 --key-type=validator --no-split
~~~

- **If you have not yet staked any nodes** - Rename the `validatorKey.pem` file to `allValidatorsKeys.pem`.

~~~
$ mv validatorKey.pem allValidatorsKeys.pem
~~~


- **If you have staked a node**, the `validatorKey.pem` was renamed to `allValidatorsKeys.pem` in a previous step, so copy the contents of  `validatorKey.pem`  to the end of `allValidatorsKeys.pem`.

~~~
$ cat validatorKey.pem >> allValidatorsKeys.pem
~~~

The `allValidatorsKeys.pem` file is ready. 


## Add the BLS public keys to prefs.toml.

The BLS public key is the 192 hex character string in the BEGIN and END lines found in files containing validator keys. 

- Run the following command to extract each BLS public key from `allValidatorsKeys.pem` and store the result in a file named `BLS_KEYS.txt`. 

~~~
$ cat allValidatorsKeys.pem | awk -F'[ -]*' '/BEGIN/{print $(NF-1)}' > BLS_KEYS.txt
~~~

When we paste the list of BLS keys in `prefs.toml`, the strings will need to conform to the TOML specification. The strings need to be surrounded by double quotes, indented by 6 spaces. Each item in the list needs to end with a comma, except the last one. 

- Run the following command to quote the keys and format them. 

~~~
$ sed -i -e 's/^/      "/g' -e 's/$/",/g' BLS_KEYS.txt
~~~

- The resulting `BLS_KEYS.txt` file will look similar to this.  

~~~
      "10177728 ... 477f3609",
      "2d0a36dd ... 0f6c1b89",
...
~~~

We're ready to add the BLS keys to prefs.toml. 

- Use `cat` to print the lines to the terminal, then select everything from the beginning of the first line, to the end of the last line, and copy to your clipboard.

~~~
$ cat BLS_KEYS.txt
~~~

- Open `prefs.toml` using your favourite editor. 

- Move to the bottom of the file, where you will see these lines.

~~~
# NamedIdentity represents an identity that runs nodes on the multikey
# There can be multiple identities set on the same node, each one of them having different bls keys, just by duplicating the NamedIdentity
[[NamedIdentity]]
   # Identity represents the GitHub identity for the current NamedIdentity
   Identity = ""
   # NodeName represents the name that will be given to the names of the current identity
   NodeName = ""
   # BLSKeys represents the BLS keys assigned to the current NamedIdentity
   BLSKeys = [
      "",
      ""
   ]
~~~

- Replace the two empty BLS keys in the list, with the text from your clipboard. The last key in the list must not have a comma at the end, so you will need to delete it. The result will look similar to this. 

~~~
# NamedIdentity represents an identity that runs nodes on the multikey
# There can be multiple identities set on the same node, each one of them having different bls keys, just by duplicating the NamedIdentity
[[NamedIdentity]]
   # Identity represents the GitHub identity for the current NamedIdentity
   Identity = ""
   # NodeName represents the name that will be given to the names of the current identity
   NodeName = "pale-blue"
   # BLSKeys represents the BLS keys assigned to the current NamedIdentity
   BLSKeys = [
      "10177728 ... 477f3609",
      "2d0a36dd ... 0f6c1b89",
      "36882474 ... 411eb782",
      "388bd521 ... 8c3dad83",
      "4641b45c ... 988da68d",
      "4d4f1399 ... 972f4682",
      "662238fd ... 5e365988",
      "6868f130 ... da1cb10a",
      "87979a31 ... f3292302",
      "8e5dac93 ... 39968c83",
      "971753b9 ... 64c4e597",
      "99ea210c ... fbd53498",
      "a7c2582e ... 4f8fe30d",
      "a84fcdba ... f1e4898f",
      "acc577b6 ... e773418e",
      "b1429b50 ... 33988882"
   ]
~~~

Refer to the example above. When configured for Multikey, node names are generated using the string set in NodeName with a numeric suffix added. In this example there are 16 entries in the BLSKeys list, which will result in 16 nodes named pale-blue-00 .. pale-blue-15. 

This setting is different and separate from the NodeDisplayName setting near the top of prefs.toml. NodeDisplayName will be the display name of your observer node.  

The series of names generated using the NodeName prefix will initially be visible as observers in the Explorer. As you stake nodes using `mxpy validator stake`, the staked nodes will show as Validator. Refreshing the Explorer page may be necessary to see the change. 

The `prefs.toml` file is ready. 


## Restart your node

Your Multikey configuration is complete. You can restart your node and in a few minutes you should see your new list of nodes in the [OneFinity - Testnet Explorer](https://explorer.validators.onefinity.network/nodes?type=validator). 

Restart your node. 

~~~
$ sudo systemctl restart onefinity-validator.service
~~~

- In the explorer, search for your observer node using the value you set in NodeDisplayName of prefs.toml. You should see one observer node in the list. 

- In the explorer, search for your Multikey nodes using the string you set in NodeName of prefs.toml. You should see the list of Multikey nodes where each node name ends with a sequence number. 
    - if you click All, all keys present in `prefs.toml` having a corresponding key in `allVlidatorsKeys.pem` will be listed
    - If you click Validators, nodes staked as validators will be listed
    - if you click Observers, nodes not yet staked will be listed


## Stake individual, or even a group of nodes using mxpy

When Staking validator nodes using `mxpy validator stake`,  individual validatorKey.pem files are required. 

When we generated our validator BLS keys using `keygenerator`, we added `--no-split` to put all of the keys in a single file named `validatorKey.pem` which we subsequently renamed to `allValidatorsKeys.pem`. 

We will now split/extract each validator BLS key into individual, numbered files named validatorKey-n.pem. 

~~~
$ cat allValidatorsKeys.pem | awk '/BEGIN/,/END/{if (/BEGIN/) {a++}; out="validatorKey-"a".pem"; print>out;}'
~~~

We should now have a set of files, such as these.

~~~
validatorKey-1.pem
validatorKey-2.pem
validatorKey-3.pem
validatorKey-4.pem
validatorKey-5.pem
validatorKey-6.pem
validatorKey-7.pem
validatorKey-8.pem
validatorKey-9.pem
validatorKey-10.pem
validatorKey-11.pem
validatorKey-12.pem
validatorKey-13.pem
validatorKey-14.pem
validatorKey-15.pem
validatorKey-16.pem
~~~

In the staking transaction we will submit using `mxpy`, we need to prepare a `validator.json` file which contains a list of validatorKey.pem filenames. 

- To stake an individual BLS key, we can use this sample `validator.json`. 

~~~
{
  "validators": [
    {
      "pemFile": "validatorKey-1.pem"
    }
  ]
}
~~~

With a Multikey setup we will have more than one BLS key so we may want to stake more than one BLS key at a time (assuming we have the required funds to do so available in our staking wallet).  

- Here is a sample `validator.json` file with 4 BLS keys. Notice that each "pemFile": line ends with a comma "," except for the last entry in the list. Keep this in mind if editing the sample to add or remove "pemFile": lines. 

~~~
{
  "validators": [
    {
      "pemFile": "validatorKey-1.pem"
    },
    {
      "pemFile": "validatorKey-2.pem"
    },
    {
      "pemFile": "validatorKey-3.pem"
    },
    {
      "pemFile": "validatorKey-4.pem"
    }
  ]
}
~~~

We can use this sample to stake our nodes. Replace the `<staking-value>` with the amount required based on the total number of nodes that will be staked by this transaction.  

~~~
mxpy validator stake \
    --pem=walletKey.pem \
    --validators-file=validator.json \
    --value=<staking-value> \
    --proxy=https://gateway.validators.onefinity.network \
    --gas-limit 25000000 \
    --recall-nonce 
    --send
~~~

Here's a handy way to compute the `<staking-value>` based on the number of nodes to be staked, when the amount required is 2500 $ONE per node. 

~~~
$ NODES=1
$ echo "2500 * $NODES * 10^18" | bc
2500000000000000000000
~~~

To stake other than 1 node, change the number of NODES and run the command again. 

~~~
$ NODES=4
$ echo "2500 * $NODES * 10^18" | bc
10000000000000000000000
~~~

This is a completed ransaction from OneFinity explorer showing 4 nodes being staked. 

[transaction details](https://explorer.validators.onefinity.network/transactions/1c4a138bca136be643e5a9267d146c8528bbe313db9679cbb9abfa8becbdd1e2)
