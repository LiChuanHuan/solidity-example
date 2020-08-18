pragma solidity >=0.4.22 <0.7.0;

contract Abb {
    uint8 myInt;
    
    address public myAddress;
    
    
    constructor () public{
        myAddress = msg.sender;
    }
    
    function setMyInt(uint8 _myInt) public{
        if(myAddress == msg.sender){
             myInt = _myInt;
        }
    }
    
    function getMyInt() view public returns (uint8){
        return myInt;
    }
    
    
    function reciveMoney() public payable{
        
    }
    
    function withdrawlAllMoney() public {
        msg.sender.transfer(address(this).balance);
    }
}