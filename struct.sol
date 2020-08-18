pragma solidity >=0.4.22 <0.7.0;
// pragma experimental ABIEncoderV2;

contract Struct {
 struct MyStruct{
     uint myStructUint;
     string myStructString;
 }

 MyStruct myStruct;
 MyStruct[] myStructArray;

 constructor() public{
     myStruct.myStructUint = 1;
     myStruct.myStructString = 'abc';
     myStructArray.push(myStruct);
 }

 function getUint() view public returns (uint){
     return myStruct.myStructUint;
 }

 function getString() view public returns (string memory){
     return myStruct.myStructString;
 }
 
//編譯器出錯，無法這樣使用。替代方案是pragma experimental ABIEncoderV2
//但是這個功能還在測試，在生產環境使用不安全。
//  function getMystructArray() view public returns (MyStruct memory){
//      return myStructArray[0];
//  }
 
}