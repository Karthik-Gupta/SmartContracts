// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract VolcanoCoin {
    uint totalSupply = 10000;
    address owner;
 
    struct Payment {
        uint transferAmount;
        address recipientAddress;
    }

    mapping(address => uint) public balances;
    mapping(address => Payment[]) payments;

    event totalSupplyEvent(uint);
    event tranferEvent(uint, address);

    modifier ownerPrivilege {
        require(msg.sender == owner, "You are not permitted");
        _;
    }

    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function getTotalSupply() public view returns(uint supply) {
        return totalSupply;
    }

    function changeTotalSupply() external ownerPrivilege {
        totalSupply += 1000;
        balances[owner] = totalSupply;
        emit totalSupplyEvent(totalSupply);
    }

    function transfer(uint _amount, address _recipient) external {
        require(balances[msg.sender] >= _amount, "Not enough funds to fulfil this order!");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;

        payments[msg.sender].push(Payment(_amount, _recipient));
        emit tranferEvent(_amount, _recipient);
    }

    function getPaymentsHistory(address _userAdd) external view returns(Payment[] memory) {
        return payments[_userAdd];
    }
}
