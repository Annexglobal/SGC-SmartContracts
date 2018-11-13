pragma solidity ^0.4.24;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Capped.sol";
import "../node_modules/openzeppelin-solidity/contracts/token/ERC20/ERC20Pausable.sol";


/**
 * @title SecuredGoldCoin
 * @dev 
 * -> SGC Coin is 60% Gold backed and 40% is utility coin
 * -> SGC per coin gold weight is 21.2784 Milligrams with certification of LBMA
 *    (London Bullion Market Association)
 * -> SGC Coin - Gold Description - 24 Caret - .9999 Purity - LMBA Certification
 * -> The price will be locked till 14 April 2019 - 2 Euro per coin
 * -> The merchants can start trading with all SGC users from 15 June 2019
 * -> The coin will be available for sale from 15 April 2019 on the basis of live price
 * -> Coins price can be live on the SGC users wallet from the day of activation
 *    of the wallet.
 * -> During private sale coins can be bought from VIVA Gold Packages
 * -> Coins will be available for public offer from November 2019
 * -> The coin will be listed on exchange by November 2019.
 * @author Junaid Mushtaq | Talha Yusuf
 */

contract SecuredGoldCoin is ERC20, ERC20Mintable, ERC20Detailed, ERC20Burnable, ERC20Pausable, ERC20Capped {
    string public name =  "Secured Gold Coin";
    string public symbol = "SGC";
    uint8 public decimals = 18;
    uint public intialCap = 1000000000 * 1 ether;

    constructor () public 
        ERC20Detailed(name, symbol, decimals)
        ERC20Mintable()
        ERC20Burnable()
        ERC20Pausable()
        ERC20Capped(intialCap)
        ERC20()
    {}
}
