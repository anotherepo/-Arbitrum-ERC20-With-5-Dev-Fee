// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FeeToken
 * @dev ERC20 token with a 5% transfer fee sent to the dev wallet, non-mintable after deployment.
 */

contract FeeToken {
    string public name;
    string public symbol;
    uint8 public immutable decimals = 18;
    uint256 public immutable totalSupply;
    address public owner;
    address public devWallet;
    uint256 public constant FEE_BASIS_POINTS = 500; // 5% (500 / 10000)
    address public constant DEAD_WALLET = 0x000000000000000000000000000000000000dEaD;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event DevWalletChanged(address indexed previousWallet, address indexed newWallet);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _devWallet
    ) {
        require(_devWallet != address(0), "Dev wallet can't be zero address");
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        devWallet = _devWallet;
        totalSupply = _initialSupply * 10 ** decimals;
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
        emit OwnershipTransferred(address(0), owner);
        emit DevWalletChanged(address(0), devWallet);
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    // 5% fee, rest goes to recipient
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 allowed = allowance[from][msg.sender];
        require(allowed >= amount, "ERC20: transfer amount exceeds allowance");
        allowance[from][msg.sender] = allowed - amount;
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(_balances[from] >= amount, "ERC20: transfer amount exceeds balance");

        // Calculate fee (5%)
        uint256 fee = amount * FEE_BASIS_POINTS / 10000;
        uint256 amountAfterFee = amount - fee;

        // Update balances
        _balances[from] -= amount;
        _balances[to] += amountAfterFee;
        _balances[devWallet] += fee;

        emit Transfer(from, to, amountAfterFee);
        emit Transfer(from, devWallet, fee);
    }

    // Owner can change dev wallet before renouncing ownership
    function setDevWallet(address newDevWallet) external onlyOwner {
        require(newDevWallet != address(0), "Cannot set zero address");
        emit DevWalletChanged(devWallet, newDevWallet);
        devWallet = newDevWallet;
    }

    // Owner can renounce ownership (transfers to DEAD_WALLET)
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(owner, DEAD_WALLET);
        owner = DEAD_WALLET;
    }
}
