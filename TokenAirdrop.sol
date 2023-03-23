// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20{
    constructor() ERC20("Token","Arnur"){
        _mint(msg.sender, 100*10**18);
    }
    
    function airdrop(address[] memory recipients, uint256[] memory values) public {
        require(recipients.length == values.length);
        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], values[i]);
        }
    }
}   
