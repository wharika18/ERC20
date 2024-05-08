//SPDX License Identifier: MIT
pragma solidity ^0.8.19;

//import "@openzeppelin/contracts/utils/math/SafeMath.sol";
contract TokenERC20 {
    //  using SafeMath for uint256;
    uint256 public totalSupply;
    address public owner;
    uint256 public decimals;
    string public name;
    string public symbol;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed to, uint256 value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    event Burnt(uint256 value);
    event Burn(address indexed from, uint256 value);

    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol
    ) {
        owner = msg.sender;
        totalSupply = initialSupply * 10 ** uint256(decimals); // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply; // Give the creator all initial tokens
        name = tokenName; // Set the name for display purposes
        symbol = tokenSymbol; // Set the symbol for display purposes
        decimals = 18; // Initialize decimals
    }

    function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(_to, _value);
    }

    /* function transfer(address _to, uint256 _value) public {
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        emit Transfer(_to, _value);
    } */

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(allowance[_from][msg.sender] >= _value);
        allowance[_from][msg.sender] -= _value;
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        return true;
    }

    function getBalance(address _acc) public view returns (uint256) {
        uint256 bal = balanceOf[_acc]; // this is not erc20 balanceOf function, it is the mapping so , [] to be used..
        return bal;
    }

    function burn(uint256 _burnAmt) public returns (bool burnt) {
        require(msg.sender == owner); // stipulation that only the owner could burn
        require(balanceOf[owner] >= _burnAmt);
        totalSupply -= _burnAmt;
        balanceOf[owner] -= _burnAmt;
        emit Burnt(_burnAmt);
        return true;
    }

    function burnFrom(
        address _acc,
        uint256 _burnAmt
    ) public returns (bool burnt) {
        require(msg.sender == owner); // only owner, but he should be given allowance of that much amount by the burn from acct.
        require(_burnAmt >= allowance[_acc][msg.sender]);
        require(balanceOf[_acc] >= _burnAmt);
        totalSupply -= _burnAmt;
        balanceOf[_acc] -= _burnAmt;
        emit Burn(_acc, _burnAmt);
        return true;
    }

    function mint(uint256 _mint) public returns (bool minted) {
        require(msg.sender == owner);
        totalSupply += _mint;
        balanceOf[msg.sender] += _mint;
        return true;
    }
}
