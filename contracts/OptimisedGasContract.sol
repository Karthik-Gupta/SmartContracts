// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";

contract GasContract is Ownable {

    uint128 public totalSupply;
    uint128 paymentCounter = 1;

    address [5] public administrators;
    enum PaymentType { Unknown, BasicPayment, Refund, Dividend, GroupPayment }
    PaymentType constant defaultPayment = PaymentType.Unknown;

    mapping(address => uint256) balances;
    mapping(address => Payment[]) payments;
    //mapping(address=>uint256) lastUpdateRecord; // when a payment record was last for a user   


    struct Payment {
      uint128 paymentID;
      uint128 amount;
      PaymentType paymentType;
      address recipient;
      string recipientName;  // max 12 characters
      //uint256 lastUpdate;
      //address updatedBy;
    }

    modifier onlyAdmin {
        require (checkForAdmin(msg.sender), "Caller not admin" );
        _;
    }

    event supplyChanged(address indexed, uint128);
    event Transfer(address indexed, uint128);
    event PaymentUpdated(address indexed admin, uint128 ID, uint128 amount, string recipient);


   constructor(address[] memory _admins) {
      totalSupply = 10000;
      balances[msg.sender] = totalSupply;
      setUpAdmins(_admins);
   }
   
   function welcome() public pure returns (string memory){
       return "hello !";
   }
   
    function setUpAdmins(address[] memory _admins) public onlyOwner{
        address[5] memory _addresses=administrators;
        for (uint256 ii = 0;ii<_addresses.length ;ii++){
            if(_admins[ii] != address(0)){ 
                _addresses[ii] = _admins[ii];
            } 
        }
        administrators=_addresses;
    }

   function updateTotalSupply() public onlyOwner {
      uint128 tSupply = totalSupply + 1000;
      balances[msg.sender] = tSupply;
      emit supplyChanged(msg.sender,tSupply);
      totalSupply = tSupply;
   }

   function checkForAdmin(address _user) public view returns (bool) {
       for (uint256 ii = 0; ii< administrators.length;ii++ ){
          if(administrators[ii] ==_user){
              return true;
          }
       }
       return false;
   }
   
   function transfer(address _recipient, uint128 _amount, string memory _name) external {
      require(balances[msg.sender] >= _amount,"Insufficient Balance");
      require(bytes(_name).length < 13,"Recipient can have max 12 char");
      balances[msg.sender] -= _amount;
      balances[_recipient] += _amount;
      emit Transfer(_recipient, _amount);
      payments[msg.sender].push(Payment(++paymentCounter, _amount, PaymentType.BasicPayment, _recipient, _name));
   }
     
    function updatePayment(address _user, uint128 _ID, uint128 _amount) external onlyAdmin {
        require(_ID > 0,"ID must be greater than 0");
        require(_amount > 0,"Amount must be greater than 0");
        require(_user != address(0) ,"Admin must have a non 0 addr");
        uint length = payments[_user].length;
        for (uint256 ii=0;ii<length;ii++){
            if(payments[_user][ii].paymentID==_ID){
               //payments[_user][ii].lastUpdate =  block.timestamp;
               //payments[_user][ii].updatedBy = msg.sender;
               payments[_user][ii].amount = _amount;
               //lastUpdateRecord[msg.sender] = block.timestamp;
               emit PaymentUpdated(msg.sender, _ID, _amount,payments[_user][ii].recipientName);
               break;
            }
        }
    }


   function getPayments(address _user) public view returns (Payment[] memory) {
       require(_user != address(0) ,"User must have a non 0 addr");
       return payments[_user];
   }
}
