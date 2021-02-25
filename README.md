# Free TON Simple Operations

# What is it? 
Windows BATCH based tool for the simplest interaction with Free TON blockchain. Tested on Windows 8/10 and Windows 7 SP1 with updates: KB3087873, KB2990941.


This bundle (FreeTONSO.zip) contains:
tonoscli.exe - official tonos-cli ver. 0.6.2 built from official repository source codes (https://github.com/tonlabs/tonos-cli) for Windows systems.
freetonso.cmd - open source batch script supplied with a convenient menu which helps you to execute more than 12 different tasks.
hex2dec.cmd - script converter integer value from hex to decimal. For older tonos-cli versions.
nano2ton.cmd - script converter nanoton (1^9) into ton.
depool.ini - address of the DePool y'd like to stake TONs.
*.abi.json - official ABI json files for correct interaction with smartcontracts.


# To get started:
1. Download archive FreeTONSO.zip
2. Unzip it in any folder on your PC, go to this folder and run freetonso.cmd file.
3. FreeTONSO tools works only if freetonso.cmd started in the folder it unzipped. Do not start it directly from the .zip file.
5. To select a function enter its number and press ‘Enter’ or ‘q’ to exit.


# FreeTONSO functions description:
1 - My wallet address
2 - Generate msig.keys.json file
3 - Change the sign method
4 - Show wallet balance and stakes
5 - Send Tokens
6 - Get transaction to sign
7 - Sign the transaction
8 - Stake to DePool
9 - Withdraw entire Stake from DePool
10 - Withdraw part of Stake from DePool
11 - Remove stake from DePool
12 - Cancel all Withdrawals
13 - DePool Address


# 1 - My wallet address
Allows you to enter your wallet address and save it to a file. Without a wallet address, all functions do not work.

Steps: 
  Press 1 (choose #1 function), then press Enter
  Enter your wallet address and press Enter

Result: 
  Wallet address is saved to the addr.ini file in the current folder.


# 2 - Generate msig.keys.json file 
This function allows you to generate a PUBLIC/PRIVATE key pair into the msig.keys.json file and save it to disk. This can be useful to avoid using the seed phrase every time you need to sign a transaction. Works with all types of multisig wallets (relevant for initial members of SG’s, co-owners of depools, and other msig Users).

Steps:
  Press 2, then press Enter 
  Enter your seed phrase, press Enter. 

Result: 
  You have just generated the msig.keys.json, which means that you no longer need a seed phrase to use the FreeTONSO functions (this is legal and allowed by the Free TON network). 


# 3 - Change the sign method
This function allows you to change the way a transaction is signed. For example, after msig.keys.json is generated.

Steps: 
  Press 3, then press Enter 
  Press “s” to use the seed phrase, “m” to use msig.keys.json, press Enter. 

Result:
  Preferred signing method changed. 


# 4 - Show wallet balance and stakes
This function gathers wallet balance, stakes and rewards data at the current time.

Steps:
  Press 4, then press Enter

Result: 
	You see the actual balance in TON Crystals of the wallet, the  address of DePool, the stake amount and its reward. 


# 5 - Send Tokens 
This feature allows you to send TON Crystals to another wallet. It also means you can create transactions for multi-custodians multisig wallets and sign them later.

Steps:
  Press 5, then press Enter
  Enter destination wallet address
  Enter amount of tokens 
  Enter seed phrase if you don’t use msig.keys.json file
  Choose your wallet’s contract (type): 1 if you use “Surf” or 2 for classic multisig, then press Enter.
  You will see amount in nanotons (N^9), that is okay. Verify your transaction info and press Enter


# 6 - Get transaction to sign
If you use a multisig wallet with more than one custodians (owner) and signature request more than one, your colleague can create a transaction which you need to sign. 
To get a transaction ID of that transaction (to sign it) use this function.

Steps: 
  Press 6, then press Enter

Result: 
	Transaction ID like “0x601a8b0545e74341”


# 7 - Sign the transaction 
This function allows you to sign the transaction. At first you need to get transaction id with #6 option or any other way

Steps:
  Press 7, then press Enter
  Enter transaction id like 0x601a8b0545e74341, press Enter
  If you use msig.keys.json you do not have to enter seed phrase, otherwise enter seed phrase.

Result:
  Transaction signed on. If you request function #6 again you will see signsReceived field’s value has been increased by 1.


# 8 - Stake to DePool
Use this function to stake your TON Crystals to Freetone.one DePool.

Steps: 
  Press 8, then press Enter
  Enter the amount of TON Crystals (tokens) you want to stake into DePool, then press enter.
  If you use msig.keys.json you do not have to enter seed phrase, otherwise enter seed phrase. Press enter

Results:
	You will see the “Succeed” status of the transaction.


# 9 - Withdraw entire Stake from DePool
 This function allows you to withdraw the entire Stake and its rewards from DePool. It can take a while because your stake can be “busy” in the current validation cycle and should wait until blockchain elections. The maximum withdrawal time can be up to 36 hours. 

Steps: 
  Press 9, press Enter
  Enter seed phrase, press Enter 

Results: 
	After a while check your wallet balance.


# 10 - Withdraw part of Stake from DePool
This function allows you to withdraw a part of your Stake from DePool. It can take a while because your stake can be “busy” in the current validation cycle and should wait until blockchain elections. The maximum withdrawal time can be up to 36 hours. 

Steps: 
  Press 10, press Enter
  Enter value in TON Crystals, press Enter
  Enter seed phrase, press Enter 

Results: 
	After a while check your wallet balance. 


# 11 - Remove stake from DePool
This feature allows you to cancel a Stake into DePool and return it back to your wallet if, for example, you change your mind. 

You are able to do it only before your stake goes to validation cycle. To get your stake back with rewards use withdrawal functions #9 and #10. 

Steps:
  Press 11, then press Enter


# 12 - Cancel all Withdrawals 

The title speaks for itself - you can cancel all the withdrawals (entire or part) you made before. This operation will only be successful if the DePool has not already returned your Stake back to your wallet.


# 13 - DePool Address
Allows you to specify DePool address and save it to the depool.ini file.

Steps:
  Type 13, then press Enter
  Enter the new DePool address and press Enter




# TRICKS and TIPS: 
When you enter a seed phrase use space between words. Do not place space before/after the last word of the seed phrase. 


# STAKING Shortcut:

STEP 1:
Type 1. Press enter. This will select item 1 - My wallet address. 
Type (or paste) the address (wallet) with tokens you want to stake, i.e. 0:0sdf0…. Press enter. This will save your address.
After the address saved - press any key.
If you are on the “home screen” of the app and see your address in item 1 - My wallet address (0:0sdf0…) - everything is ok.

STEP 2:
Type 8. Press enter. This will select item 8 - Stake to DePool. Press enter.
This command will show your address and the depool address and request the amount of tokens you want to stake with further seed phrase verification.

Note
Please split your stake into two validation cycles, if you consider staking a significant amount of tokens. For example, a total of 250k tokens better to stake in an amount of 125k in two days (24 hours interval).
In addition, do not leave your balance empty. At least keep 1 TON to be sure you could generate further transactions (withdrawal require balance on the wallet).

Enter value in tokens: - here you should type an ordinary amount of tokens, i.e. 125000 for 125k tokens. This is not in nano tokens!). Press enter.

Enter the seed phrase: - When you enter a seed phrase use one space between words (no dashes or other symbols) and don’t type space after the last word of the seed phrase. Press enter to make a transaction.
Your seed phrase wouldn't be stored or used and will disappear after transaction.
Please be patient, it could take some time (less than a minute, but still not immediate) to connect to blockchain and generate the transaction. After everything is done press any key to return to “home screen”.

STEP 3 (make it in couple of minutes after step 2 to be sure, that everything in blockchain):
Type 4. Press enter. This will select item  4  - Show wallet balance and stakes.
You will see the following info:
Addr:
0:0sdf0…
 Balance: xxx

DePool: 0:0000000dead8e176b391df7e6d79e3cf52fa8dbcd457a88220507dde8f6676fe
 Stake: yyy
 Rewards: zzz

Press any key to continue …

It means that you have staked in depool! Hurray!
