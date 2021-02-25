@setlocal enableextensions enabledelayedexpansion
@echo off
Title Free TON Simple Operations 
REM
REM Just a simple script file for SubGovs and other who find it helpful :)
REM by @axelfoly in Freeton.one
REM 2020, December 
REM 

echo Loading...

set walletFile=addr.ini
set depoolFile=depool.ini
set signmethodFile=signmethod.ini

color 3
:MENU

if exist %walletFile% (
	set /P ADDR=<%walletFile%

		if "!ADDR!"=="" (
			set ADDR_DESKTOP=
			) else (
			set ADDR_DESKTOP=^(!ADDR:~0,13!...!ADDR:~-13!^)
			)
	)

if exist %depoolFile% (
	set /P DEPOOL=<%depoolFile%

		if "!DEPOOL!"=="" (
			set DEPOOL_DESKTOP=
			) else (
			set DEPOOL_DESKTOP=^(!DEPOOL:~0,13!...!DEPOOL:~-13!^)
			)
	)

if exist %signmethodFile% (
	set /P SIGN_METHOD=<%signmethodFile%
	) else (
	set SIGN_METHOD=seedphrase
	)

if "%SIGN_METHOD%"=="" set SIGN_METHOD=seedphrase

tonos-cli --version 2>nul | find "tonos_cli">tonos-cli-version.tmp
for /f %%i in ("tonos-cli-version.tmp") do set size=%%~zi
if %size% gtr 0 (
	for /f "tokens=2" %%G in (tonos-cli-version.tmp) do SET TONOSCLI_VERSION=%%G
	set TONOSCLI_VERSION=!TONOSCLI_VERSION:"=!
	set TONOSCLI_VERSION=!TONOSCLI_VERSION:,=!
	del tonos-cli-version.tmp
	) else (
	set TONOSCLI_VERSION="n/a"
	)


cls
echo  *------------------------------------------------------*
echo  *     Free TON Simple Operations (tonos-cli !TONOSCLI_VERSION!)     *
echo  *------------------------------------------------------*
echo  1  - My wallet address %ADDR_DESKTOP%
echo  2  - Generate msig.keys.json file
echo  3  - Change the sign method (%SIGN_METHOD%)
echo  4  - Show wallet balance and stakes
echo  5  - Send tokens
echo  6  - Get transactions to sign
echo  7  - Sign the transaction
echo  8  - Stake to DePool
echo  9  - Withdraw entire Stake from DePool
echo  10 - Withdraw part of the Stake from DePool
echo  11 - Remove Stake from DePool
echo  12 - Cancel all withdrawals
echo  13 - DePool address %DEPOOL_DESKTOP%
echo  *------------------------------------------------------*
set /P CHOICE=Type your option and press enter or 'q' to exit: 


if %CHOICE%==q  exit
if %CHOICE%==1  goto MY_WALLET
if %CHOICE%==2  goto GENERATE_KEYS_FILE
if %CHOICE%==3  goto SIGN_METHOD
if %CHOICE%==4  goto GET_ACCOUNT
if %CHOICE%==5  goto SEND_TOKENS
if %CHOICE%==6  goto GET_TRANSACTIONS
if %CHOICE%==7  goto SIGN_TRANSACTION
if %CHOICE%==8  goto STAKE_TO_DEPOOL
if %CHOICE%==9  goto WITHDRAW_STAKE_ENTIRE
if %CHOICE%==10 goto WITHDRAW_STAKE_PART
if %CHOICE%==11 goto REMOVE_STAKE
if %CHOICE%==12 goto WITHDRAW_CANCEL
if %CHOICE%==13 goto DEPOOL_SETTINGS

goto :MENU

:MY_WALLET
cls
echo.
echo Your current addr in %walletFile%: %ADDR%
set /P NEWADDR=Enter the new wallet address:

	if "%NEWADDR%"=="" (
		goto MENU
		) else (
		echo Saving to %walletFile%...
		echo %NEWADDR%>%walletFile%
		echo Wallet address has been saved into %walletFile%
		)

pause
goto MENU


:DEPOOL_SETTINGS
cls
echo.
echo Current DePool addr in %walletFile%: %DEPOOL%
set /P NEWDEPOOL=Enter new DePool address:

	if "%NEWDEPOOL%"=="" (
		goto MENU
		) else (
		echo Saving to %depoolFile%...
		echo %NEWDEPOOL%>%depoolFile%
		echo New DePool address has been saved into %depoolFile%
		)

pause
goto MENU


:GET_ACCOUNT
CLS
if not defined ADDR (
	goto :MY_WALLET
	)

tonos-cli account %ADDR% | find "balance">account_balance.tmp
for /f "tokens=2" %%G in (account_balance.tmp) do SET BALANCE=%%G
for /f %%i in ("account_balance.tmp") do set size=%%~zi
if %size% gtr 0 (
	set BALANCE=!BALANCE:"=!
	set BALANCE=!BALANCE:,=!
	for /f %%# in ('nano2ton.cmd !BALANCE!') do set "BALANCE=%%#"
	) else (
	set BALANCE=Not found
	)
del account_balance.tmp
echo.
echo Addr: %ADDR%
echo  Balance: !BALANCE!

if defined DEPOOL (
	goto :GET_DEPOOL_PARTICIPANT_INFO
	) else (
	goto :GET_DEPOOL_PARTICIPANT_INFO_END
	)

:GET_DEPOOL_PARTICIPANT_INFO
echo.

tonos-cli run %DEPOOL% getParticipantInfo "{\"addr\":\"%ADDR%\"}" --abi DePoolv3.abi.json 2>nul | find "total">account_stakes.tmp
tonos-cli run %DEPOOL% getParticipantInfo "{\"addr\":\"%ADDR%\"}" --abi DePoolv3.abi.json 2>nul | find "reward">account_rewards.tmp

for /f %%i in ("account_stakes.tmp") do set size=%%~zi
if %size% equ 0 (
	del account_stakes.tmp
	del account_rewards.tmp
	tonos-cli run %DEPOOL% getParticipantInfo "{\"addr\":\"%ADDR%\"}" --abi DePool.abi.json 2>nul | find "total">account_stakes.tmp
	tonos-cli run %DEPOOL% getParticipantInfo "{\"addr\":\"%ADDR%\"}" --abi DePool.abi.json 2>nul | find "reward">account_rewards.tmp
	)

for /f %%i in ("account_stakes.tmp") do set size=%%~zi
if %size% gtr 0 (

	for /f "tokens=2" %%G in (account_stakes.tmp) do SET STAKE=%%G
	set STAKE=!STAKE:"=!
	set STAKE=!STAKE:,=!
	for /f %%# in ('nano2ton.cmd !STAKE!') do set "STAKE=%%#"

	for /f %%i in ("account_rewards.tmp") do set size=%%~zi
	if %size% gtr 0 (
		for /f "tokens=2" %%G in (account_rewards.tmp) do SET REWARDS=%%G
		set REWARDS=!REWARDS:"=!
		set REWARDS=!REWARDS:,=!

		for /f %%# in ('nano2ton.cmd !REWARDS!') do set "REWARDS=%%#"
		) else (
		set REWARDS=0)

	) else (
	set STAKE=0
	)

echo DePool: %DEPOOL%
echo  Stake: !STAKE!
echo  Rewards: !REWARDS!

del account_stakes.tmp
del account_rewards.tmp
:GET_DEPOOL_PARTICIPANT_INFO_END
echo.
pause
goto MENU


:SEND_TOKENS
set DEST=
set VALUE=
set SEED=
cls
if not defined ADDR (
	goto :MY_WALLET
	)
echo. 
set /P DEST=Enter destination address:

	if "!DEST!"=="" (goto :SEND_TOKENS)

:SEND_TOKENS_VALUE
set /P VALUE=Enter value in tokens (TON Crystals):

	if "!VALUE!"=="" (goto :SEND_TOKENS_VALUE)

set VALUE=%VALUE%000000000

if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	:SEND_TOKENS_SEED
	set /P SEED=Enter the seed phrase:

		if "!SEED!"=="" (goto :SEND_TOKENS_SEED)

	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)

echo.
echo Choose your wallet's contract:
:SEND_TOKENS_MENU_ABI
echo  1  - SetcodeMultisigWallet (Surf)
echo  2  - SafeMultisigWallet (Multisig "classic")
echo.
set /P CHOICE=Type your option and press enter or 'q' to MENU: 
if %CHOICE%==1 set CONTRACT_ABI=SetcodeMultisigWallet.abi.json
if %CHOICE%==2 set CONTRACT_ABI=SafeMultisigWallet.abi.json
if %CHOICE%==q goto :MENU

	if "!CONTRACT_ABI!"=="" (goto :SEND_TOKENS_MENU_ABI)


echo.
echo Contract: !CONTRACT_ABI!
echo Sign method: %SIGN_METHOD%
echo Destination: !DEST!
echo Value: !VALUE!
pause
echo Processing...
tonos-cli call %ADDR% submitTransaction "{\"dest\":\"%DEST%\",\"value\":%VALUE%,\"bounce\":true,\"allBalance\":false,\"payload\":\"\"}" --abi %CONTRACT_ABI% --sign %SIGNATURE%
pause
set DEST=
set VALUE=
set SEED=
goto MENU


:GENERATE_KEYS_FILE
echo Let's generate msig.keys.json file
echo.
:GENERATE_KEYS_FILE_SEED
set /P SEED=Enter your seed phrase:

	if "!SEED!"=="" (goto :GENERATE_KEYS_FILE_SEED)

echo Processing...
tonos-cli getkeypair msig.keys.json "%SEED%"
echo Your keys placed to the msig.keys.json file
pause
goto SIGN_METHOD_MENU


:SIGN_METHOD
color 2
:SIGN_METHOD_MENU
cls
echo Choose the method to sign transaction:
echo.
echo  s - Using a seed phrase
echo  m - Using msig.keys.json file
echo.
set /P CHOICE=Select your option and press enter: 
if %CHOICE%==s set SIGN_METHOD_NEW=seedphrase
if %CHOICE%==m set SIGN_METHOD_NEW=msig.keys.json

	if "!SIGN_METHOD_NEW!"=="" (goto :SIGN_METHOD)

if %SIGN_METHOD_NEW%==msig.keys.json (
	if not exist msig.keys.json (
		echo File msig.keys.json not found
		goto :GENERATE_KEYS_FILE
		)
	)
echo !SIGN_METHOD_NEW!>%signmethodFile%
Color 3
goto MENU


:GET_TRANSACTIONS
echo Processing...
if not defined ADDR (
	goto :MY_WALLET
	)
tonos-cli run %ADDR% getTransactions {} --abi SafeMultisigWallet.abi.json

pause
goto MENU


:SIGN_TRANSACTION
if not defined ADDR (
	goto :MY_WALLET
	)
set /P TRANSACTION=Enter transaction ID:
if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	set /P SEED=Enter the seed phrase:
	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)
echo Transaction: !TRANSACTION!
echo Sign method: %SIGN_METHOD%
pause
echo "Processing..."
tonos-cli call %ADDR% confirmTransaction "{\"transactionId\":\"%TRANSACTION%\"}" --abi SafeMultisigWallet.abi.json --sign %SIGNATURE%
set SEED=
pause
goto MENU


:STAKE_TO_DEPOOL
if not defined ADDR (
	goto :MY_WALLET
	)
if not defined DEPOOL (
	goto :DEPOOL_SETTINGS
	)
echo DePool: %DEPOOL%
echo Wallet: %ADDR%
set /P VALUE=Enter value in tokens:
echo Value: !VALUE!

if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	:STAKE_TO_DEPOOL_ENTER_SEED
	set /P SEED=Enter the seed phrase:
	if "!SEED!"=="" (goto STAKE_TO_DEPOOL_ENTER_SEED)
	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)

echo Sign method: %SIGN_METHOD%
pause
echo "Processing..."
tonos-cli depool --addr %DEPOOL% stake ordinary --wallet %ADDR% --value %VALUE% --sign %SIGNATURE%
echo "You can check your stakes by select #4 in main menu"
pause
goto MENU


:REMOVE_STAKE
echo DePool: %DEPOOL%
echo Wallet: %ADDR% 
set /P VALUE=Enter value in tokens:
echo Remove value: !VALUE!

if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	set /P SEED=Enter the seed phrase:
	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)

echo Sign method: %SIGN_METHOD%
pause
echo "Processing..."
tonos-cli depool --addr %DEPOOL% stake remove --wallet %ADDR% --value %VALUE% --sign %SIGNATURE%
pause
goto MENU


:WITHDRAW_STAKE_ENTIRE
echo DePool: %DEPOOL%
echo Wallet: %ADDR%

if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	set /P SEED=Enter the seed phrase:
	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)


echo Sign method: %SIGN_METHOD%
pause
echo "Processing..."
tonos-cli depool --addr %DEPOOL% withdraw on --wallet %ADDR% --sign %SIGNATURE%
pause
goto MENU


:WITHDRAW_STAKE_PART
echo DePool: %DEPOOL%
echo Wallet: %ADDR% 
set /P VALUE=Enter value in tokens:
echo Withdraw value: !VALUE!

if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	set /P SEED=Enter the seed phrase:
	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)

echo Sign method: %SIGN_METHOD%
pause
echo "Processing..."
tonos-cli depool --addr %DEPOOL% stake withdrawPart --wallet %ADDR% --value %VALUE% --sign %SIGNATURE%
pause
goto MENU


:WITHDRAW_CANCEL
echo DePool: %DEPOOL%
echo Wallet: %ADDR% 

if "%SIGN_METHOD%"=="seedphrase" (
	echo.
	set /P SEED=Enter the seed phrase:
	echo.
	set SIGNATURE="!SEED!"
	) else (
	set SIGNATURE=!SIGN_METHOD!
	)

echo Sign method: %SIGN_METHOD%
pause
echo "Processing..."
tonos-cli depool --addr %DEPOOL% withdraw off --wallet %ADDR% --sign %SIGNATURE%
pause
goto MENU
