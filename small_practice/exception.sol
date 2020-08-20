pragma solidity >=0.4.22 <0.7.0;

contract Abb {
    uint8 myInt;
    
    address public myAddress;
    
    
    constructor () public{
        myAddress = msg.sender;
    }
    
    //例外處理，當發生例外時，會自動執行回滾，所有改變的狀態會被回復到初始狀態
    //用來處理較輕微的錯誤，像是錯誤的輸入等，會退回未使用到的Gas
    function setMyInt(uint8 _myInt) public{
        require(myAddress == msg.sender);
        // require(myAddress == msg.sender,"Sender != Owner");未來會支持的寫法
        myInt = _myInt;
    }
    //例外處理，當發生例外時，會自動執行回滾，所有改變的狀態會被回復到初始狀態
    //用來處理較重的錯誤，像是安全性檢查等，會被扣取所有的Gas
    function setMyInt2(uint8 _myInt) public{
        assert(myAddress == msg.sender);
        // assert(myAddress == msg.sender,"Sender != Owner");未來會支持的寫法
        myInt = _myInt;
    }

    //直接回滾，並退回未被使用的Gas
    function setMyInt3(uint8 _myInt) public{
        myInt = _myInt;
        revert();
        //revert("just revert");revert("just revert");
    }
    
    function getMyInt() view public returns (uint8){
        return myInt;
    }
    
}