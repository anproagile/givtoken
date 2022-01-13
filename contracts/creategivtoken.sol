//SPDX-License-Identifier: Sablockchain0

pragma solidity ^0.4.24;
 
//Safe Math Interface
 
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
 
//ERC Token Standard #20 Interface
 
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
//Contract function to receive approval and execute function in one call
 
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
 
//Actual token contract
 
contract GIVToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
    address _rewardholderWallet;
    address _charitypoolWallet;

 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        symbol = "GIV";
        name = "Giving Token";
        decimals = 2; // Decimals to 2, Generally 18. so I will discuss with Joseph at the end.
        _totalSupply = 1000000;  // Discuss with joseph for totalsupply amount. So it will be 10000 token in Max
        // ownerWallertAddress = 0x764cF690A710853B4ac02A3d48cb12c12eB18f4A;
        balances[0x764cF690A710853B4ac02A3d48cb12c12eB18f4A] = _totalSupply;
        emit Transfer(address(0), 0x764cF690A710853B4ac02A3d48cb12c12eB18f4A, _totalSupply);
    }
 
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
 
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
 
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
 
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        // balances[from] = safeSub(balances[from], tokens);
        // allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        // balances[to] = safeAdd(balances[to], tokens);
        // emit Transfer(from, to, tokens);

        uint256 _tTotransfer = (tokens.mul(90)).div(100);

        uint256 _tToRewardHolder = (tokens.mul(5)).div(100);
        _tTotransfer = _tTotransfer.sub((tokens.mul(5)).div(100));

        uint256 _tToCharityPool = (tokens.mul(3)).div(100);
        _tTotransfer = _tTotransfer.sub((tokens.mul(3)).div(100));

        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        emit Transfer(from, _msgSender(), _tTotransfer); 

        balances[_rewardholderWallet] = safeAdd(balances[_rewardholderWallet], _tToRewardHolder);        
        emit Transfer(from, _rewardholderWallet, _tToRewardHolder); 

        balances[_charitypoolWallet] = safeAdd(balances[_charitypoolWallet], _tToCharityPool);        
        emit Transfer(from, _charitypoolWallet, _tToCharityPool);

        balances[to] = safeAdd(balances[to], _tTotransfer);        
        emit Transfer(from, to, _tTotransfer);

        return true;
    }
 
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }
 
    function () public payable {
        revert();
    }
}