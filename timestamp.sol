pragma solidity >=0.4.22 <0.7.0;

contract Event {
    uint8 public myInt;
    
    uint public timeStamp;

    constructor () public{
        timeStamp = now;
    }
    
    function setMyInt(uint8 _myInt) public{
        require(timeStamp + 10 seconds < now);
        myInt = _myInt;
    }
    
}