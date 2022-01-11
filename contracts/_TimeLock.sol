// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

contract TimeLock {
    using SafeMath for uint;

    //amount deposited by address is stored in balances
    mapping(address => uint) public balances;

    // when you can withdraw deposited ether is saved in lockTime
    mapping(address => uint) public lockTime;

    function deposit() public payable{

        // update balance of address in balances
        balances[msg.sender] += msg.value;

        // add lock time period of 1 week to the address to withdraw.
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function addLockTime(uint _secondsToAdd) public {
        lockTime[msg.sender] = lockTime[msg.sender].add(_secondsToAdd);
    }

    function withdraw() public {
        require(balances[msg.sender] > 0,'Insufficient Funds');
        require(block.timestamp > lockTime[msg.sender],'Lock Time has not expired.');

        // update balance
        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent,) = msg.sender.call{value:amount}("");
        require(sent,"Failed to send");
    }

    function getCurrentTime() view external returns(uint _currentTime){
        return(block.timestamp);
    }
}