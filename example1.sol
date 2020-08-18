pragma solidity >=0.4.22 <0.7.0;

contract Abb {
    uint8 myInt;
    
    address public myAddress;
    
    
    constructor () public{
        //msg.sender值接取得使用此合約的address
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
    
    //支付貨幣至此合約
    function reciveMoney() public payable{
        
    }
    
    //從此合約取款
    function withdrawlAllMoney() public {
        //使用address中的transfer方法來發送貨幣
        msg.sender.transfer(address(this).balance);
    }
}