// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract KarthikCoin is Ownable, ERC20("Karthik Gupta Coin", "KGC") {
    uint private id;
    address private admin;
    
    enum PaymentType { Unknown, BasicPayment, Refund, Dividend, GroupPayment }
    PaymentType constant defaultPayment = PaymentType.Unknown;

    struct Payment {
        uint id;
        uint timestamp;
        uint transferAmount;
        address recipientAddress;
        PaymentType paymentType;
        string comment;
    }

    mapping(address => Payment[]) payments;
    address[] addressCollection;
    
    event totalSupplyEvent(uint);
    event tranferEvent(uint, address);
    
    modifier ownerPrivilege {
        require(msg.sender == owner(), "You are not permitted!");
        _;
    }
    
    modifier adminPrivilege() {
        require(msg.sender == administrator(), "You are not permitted!");
        _;
    }

    constructor(address _admin) {
        admin = _admin;
        _mint(owner(), 10000);
    }
    
    function administrator() public view returns (address) {
        return admin;
    }
    
    function genId() internal returns (uint) { 
        return ++id; 
        
    }
    
    function mintMoreTokens() external ownerPrivilege {
        _mint(owner(), 1000);
        emit totalSupplyEvent(totalSupply());
    }
    
    function transfer(address _recipient, uint _amount) public virtual override returns (bool) {
        super.transfer(_recipient, _amount);

        Payment memory payment = Payment(genId(), block.timestamp, _amount, _recipient, defaultPayment, "");
        payments[msg.sender].push(payment);
        addressCollection.push(msg.sender);
        emit tranferEvent(_amount, _recipient);
        return true;
    }
    
    function getPaymentsHistory(address _userAdd) public view returns(Payment[] memory) {
        return payments[_userAdd];
    }
    
    function updatePayment(uint _id, PaymentType _paymentType, string memory _comment) external returns (bool) {
        require(updatePaymentIfValid(msg.sender, _id, _paymentType, _comment), "Payment info not found!");

        return true;
    }
    
    function managePayment(uint _id, PaymentType _paymentType) external adminPrivilege returns (bool) {
        require(addressCollection.length != 0, "Payment not found!");
        require(manageIfValid(_id, _paymentType), "Paymnet not found!");
        
        return true;
    }
    
    function manageIfValid(uint _id, PaymentType _paymentType) internal returns (bool) {
        for (uint i=0; i<addressCollection.length; i++) {
            for (uint j=0; j<payments[addressCollection[i]].length; j++) {
                if (payments[addressCollection[i]][j].id == _id) {
                    payments[addressCollection[i]][j].paymentType = _paymentType;
                    string memory com = string(abi.encodePacked(payments[addressCollection[i]][j].comment, " updated by ", Strings.toHexString(uint256(uint160(administrator())))));
                    payments[addressCollection[i]][j].comment = com;
                    return true;
                }
            }
        }
        return false;
    }
    
    function updatePaymentIfValid(address _requestor, uint _id, PaymentType _paymentType, string memory _comment) internal returns (bool) {
        for (uint i=0; i< payments[_requestor].length; i++) {
            if (payments[_requestor][i].id == _id) {
                 payments[_requestor][i].paymentType = _paymentType;
                 payments[_requestor][i].comment = _comment;
                return true;
            }
        }
        return false;
    }
}
