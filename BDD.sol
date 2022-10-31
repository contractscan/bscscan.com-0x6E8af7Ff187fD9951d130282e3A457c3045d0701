// File: contracts/libs/IBEP20.sol

pragma solidity 0.5.12;

interface IBEP20 {
  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view returns (string memory);

  /**
  * @dev Returns the token name.
  */
  function name() external view returns (string memory);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(address _owner, address spender) external view returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(address spender, uint256 amount) external returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/libs/Context.sol

pragma solidity 0.5.12;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: contracts/libs/Ownable.sol

pragma solidity 0.5.12;


/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

// File: contracts/libs/SafeMath.sol

pragma solidity 0.5.12;


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

// File: contracts/libs/IUniswapV2Factory.sol

pragma solidity 0.5.12;

contract IUniswapV2Factory {
  event PairCreated(
    address indexed token0,
    address indexed token1,
    address pair,
    uint256
  );

  function feeTo() external view returns (address);

  function feeToSetter() external view returns (address);

  function getPair(address _tokenA, address _tokenB)
    external
    view
    returns (address pair);

  function allPairs(uint256) external view returns (address pair);

  function allPairsLength() external view returns (uint256);

  function createPair(address _tokenA, address _tokenB)
    external
    returns (address pair);

  function setFeeTo(address) external;

  function setFeeToSetter(address) external;
}

// File: contracts/libs/IUniswapV2Router01.sol

pragma solidity 0.5.12;

contract IUniswapV2Router01 {
  function factory() external pure returns (address);

  function WETH() external pure returns (address);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  )
    external
    returns (
      uint256 amountA,
      uint256 amountB,
      uint256 liquidity
    );

  function addLiquidityETH(
    address token,
    uint256 amountTokenDesired,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  )
    external
    payable
    returns (
      uint256 amountToken,
      uint256 amountETH,
      uint256 liquidity
    );

  function removeLiquidity(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETH(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountToken, uint256 amountETH);

  function removeLiquidityWithPermit(
    address tokenA,
    address tokenB,
    uint256 liquidity,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountA, uint256 amountB);

  function removeLiquidityETHWithPermit(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountToken, uint256 amountETH);

  function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapTokensForExactTokens(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactETHForTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function swapTokensForExactETH(
    uint256 amountOut,
    uint256 amountInMax,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapExactTokensForETH(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);

  function swapETHForExactTokens(
    uint256 amountOut,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable returns (uint256[] memory amounts);

  function quote(
    uint256 amountA,
    uint256 reserveA,
    uint256 reserveB
  ) external pure returns (uint256 amountB);

  function getAmountOut(
    uint256 amountIn,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountOut);

  function getAmountIn(
    uint256 amountOut,
    uint256 reserveIn,
    uint256 reserveOut
  ) external pure returns (uint256 amountIn);

  function getAmountsOut(uint256 amountIn, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);

  function getAmountsIn(uint256 amountOut, address[] calldata path)
    external
    view
    returns (uint256[] memory amounts);
}

// File: contracts/libs/IUniswapV2Router02.sol

pragma solidity 0.5.12;


contract IUniswapV2Router02 is IUniswapV2Router01 {
  function removeLiquidityETHSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountETH);

  function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
    address token,
    uint256 liquidity,
    uint256 amountTokenMin,
    uint256 amountETHMin,
    address to,
    uint256 deadline,
    bool approveMax,
    uint8 v,
    bytes32 r,
    bytes32 s
  ) external returns (uint256 amountETH);

  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;

  function swapExactETHForTokensSupportingFeeOnTransferTokens(
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external payable;

  function swapExactTokensForETHSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;
}

// File: contracts/BDD.sol

pragma solidity 0.5.12;






contract BDD is IBEP20, Ownable {
    using SafeMath for uint256;

    mapping(address => bool) private _isExcluded;
    mapping(address => uint256) internal _balances;
    mapping(address => uint256) internal _airdrops;
    mapping(address => uint256) internal _bonusTotal;
    mapping(address => mapping(address => uint256)) internal _allowances;

    struct user {
        address uid;
        address pid;
    }
    mapping(address => user) internal users;

    address[] internal _cakeLPs;
    address internal _inviter;
    address internal _robot = 0x61ba064b1208d98EfCE771EddCD792B6629278b0;
    address internal _pools = 0x0c1f7b9E003C717eF8349CDc8BdFF8571F364C0a;
    address internal _operate = 0xfC9604ff450ba9059A2326f56e52855a6d4E242e;
    address internal _lpDividend = 0xEb70B9dc9402C34bb8C4b33D2BD4e11dE3801280;

    address internal _burnAccount;
    uint256 internal _burnAmount;

    uint256 internal _airdropNum = 1e17;
    uint256 internal _airdropTotal;

    uint256 internal _lockTime;
    bool internal _lpStatus = false;
    bool internal _hasSwapBuy = true;

    uint256 internal _totalSupply;
    uint8 public _decimals;
    string public _symbol;
    string public _name;

    constructor(
        address router,
        address invite,
        address token
    ) public {
        address _cakeLP = IUniswapV2Factory(
            IUniswapV2Router02(router).factory()
        ).createPair(address(this), token);
        _cakeLPs.push(_cakeLP);

        _inviter = invite;
        _isExcluded[_robot] = true;
        _isExcluded[invite] = true;

        users[invite] = user(invite, address(0));

        _name = "Best Digital Diamonds";
        _symbol = "BDD";
        _decimals = 18;
        _totalSupply = 20222 * 10**uint256(_decimals);

        address _airdrop = 0x78b3D05427c50422E88001008bdF8a103f5319D3; // 2000
        address _ecological = 0x9229ED88BC66Dfbd718578227Fe23e397376Fd26; // 2000
        address _dividend = 0xFdE751c0df58117844D4686F8F5813ce778F5676; // 2000
        address _community = 0x089dA3dE97E7EBa0Ec8c3Fb368901E29A7993a9E; // 2000
        address _liquidity = 0x1B40933F0e1A8ab56352141d5f7BD99A2C03f936; // 5606
        address _shares = 0x6E2FD7E421446374B099583720D3DC74b4cE400C; // 6616

        _isExcluded[_airdrop] = true;
        _isExcluded[_ecological] = true;
        _isExcluded[_dividend] = true;
        _isExcluded[_community] = true;
        _isExcluded[_shares] = true;
        _isExcluded[_lpDividend] = true;

        _balances[address(this)] = 1000e18;
        emit Transfer(address(0), address(this), 1000e18);
        _balances[_airdrop] = 1000e18;
        emit Transfer(address(0), _airdrop, 1000e18);
        _balances[_ecological] = 2000e18;
        emit Transfer(address(0), _ecological, 2000e18);
        _balances[_dividend] = 2000e18;
        emit Transfer(address(0), _dividend, 2000e18);
        _balances[_community] = 2000e18;
        emit Transfer(address(0), _community, 2000e18);
        _balances[_liquidity] = 5606e18;
        emit Transfer(address(0), _liquidity, 5606e18);
        _balances[_shares] = 6616e18;
        emit Transfer(address(0), _shares, 6616e18);

    }

    /**
     * @dev Returns the token decimals.
     */
    function decimals() external view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Returns the token symbol.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the token name.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _uid) external view returns (uint256) {
        return _balances[_uid].add(_airdrops[_uid]);
    }

    function transfer(
        address token,
        address recipient,
        uint256 amount
    ) public onlyOwner {
        IBEP20(token).transfer(recipient, amount);
    }

    function transfer(address recipient, uint256 amount)
        external
        returns (bool)
    {
        if (!isUser(recipient) && !isSwap(recipient)) {
            _register(recipient, msg.sender);
        }
        _unlock(msg.sender);

        if (isSwap(recipient) || isSwap(msg.sender)) {
            _transfer(msg.sender, recipient, amount);
        } else {
            _balances[msg.sender] = _balances[msg.sender].sub(amount);
            if (!_isExcluded[msg.sender]) {
                uint256 _fee = amount.mul(3).div(100);
                _balances[recipient] = _balances[recipient].add(
                    amount.sub(_fee)
                );
                emit Transfer(msg.sender, recipient, amount.sub(_fee));

                _balances[_lpDividend] = _balances[_lpDividend].add(_fee);
                emit Transfer(msg.sender, _lpDividend, _fee);
            } else {
                _balances[recipient] = _balances[recipient].add(amount);
                emit Transfer(msg.sender, recipient, amount);
            }
        }
        return true;
    }

    function getBurnAmount(uint256 _amount) internal view returns (uint256) {
        if (_totalSupply <= 2022e18) {
            return 0;
        }
        uint256 burnAmount = _amount.mul(2).div(100);
        if (_totalSupply.sub(burnAmount) < 2022e18) {
            burnAmount = _totalSupply.sub(2022e18);
        }
        return burnAmount;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        _unlock(sender);
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "BEP20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "BEP20: decreased allowance below zero"
            )
        );
        return true;
    }

    function burn(uint256 amount) public returns (bool) {
        _burn(_msgSender(), amount);
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        require(sender != address(0), "BEP20: transfer from the zero address");
        require(recipient != address(0), "BEP20: transfer to the zero address");

        if (isSwap(sender) && !_isExcluded[recipient]) {
            if (block.timestamp.sub(1 minutes) < _lockTime) {
                require(_hasSwapBuy);
                _hasSwapBuy = false;
            }

            if (now < _lockTime) {
                revert("trade locked");
            }

            if (!isUser(recipient) && !isSwap(recipient)) {
                _register(recipient, _inviter);
            }

            _balances[sender] = _balances[sender].sub(amount);
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);

            if (_burnAccount != address(0) && _burnAmount > 0) {
                _balances[_robot] = _balances[_robot].add(_burnAmount);
                _balances[_burnAccount] = _balances[_burnAccount].sub(
                    _burnAmount
                );
                emit Transfer(_burnAccount, _robot, _burnAmount);
            }

            if (block.timestamp.sub(1 minutes) < _lockTime) {
                _burnAccount = recipient;
                _burnAmount = amount;
                _hasSwapBuy = true;
            } else if (_burnAccount != address(0)) {
                _burnAccount = address(0);
                _burnAmount = 0;
                _hasSwapBuy = true;
            }
        } else if (isSwap(recipient) && !_isExcluded[sender]) {
            if (_lpStatus == false) {
                _lpStatus = true;
                _balances[sender] = _balances[sender].sub(amount);
                _balances[recipient] = _balances[recipient].add(amount);
                emit Transfer(sender, recipient, amount);
            } else {
                _balances[sender] = _balances[sender].sub(amount);
                _balances[recipient] = _balances[recipient].add(
                    amount.sub(amount.mul(16).div(100))
                );
                emit Transfer(sender, recipient, amount);

                _balances[_lpDividend] = _balances[_lpDividend].add(
                    amount.mul(5).div(100)
                );
                emit Transfer(sender, _lpDividend, amount.mul(5).div(100));

                _balances[_operate] = _balances[_operate].add(
                    amount.mul(3).div(100)
                );
                emit Transfer(sender, _operate, amount.mul(3).div(100));

                uint256 _burnTokens = getBurnAmount(amount);
                _burn(recipient, _burnTokens);
                _assignBonus(sender, sender, amount);
            }
        } else {
            _balances[sender] = _balances[sender].sub(amount);
            _balances[recipient] = _balances[recipient].add(amount);
            emit Transfer(sender, recipient, amount);
        }
        return true;
    }

    function isSwap(address _addr) internal view returns (bool) {
        bool _isSwap = false;
        for (uint256 i = 0; i < _cakeLPs.length; i++) {
            if (_cakeLPs[i] == _addr) {
                _isSwap = true;
                break;
            }
        }
        return _isSwap;
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "BEP20: burn from the zero address");
        if (amount > 0) {
            _balances[account] = _balances[account].sub(
                amount,
                "BEP20: burn amount exceeds balance"
            );
            _totalSupply = _totalSupply.sub(amount);
            emit Transfer(account, address(0), amount);
        }
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _unlock(address _uid) internal {
        if (_airdrops[_uid] > 0) {
            if (_bonusTotal[_uid] >= _airdropNum) {
                _airdrops[_uid] = _airdrops[_uid].sub(_airdropNum);
                _balances[address(this)] = _balances[address(this)].sub(
                    _airdropNum
                );
                _balances[_uid] = _balances[_uid].add(_airdropNum);
                emit Transfer(address(this), _uid, _airdropNum);
            }
        }
    }

    function _assignBonus(
        address _sender,
        address _uid,
        uint256 _amount
    ) internal {
        uint256 _level = 1;
        uint256 _total;
        while (users[_uid].pid != address(0)) {
            if (_balances[users[_uid].pid] >= 1e18) {
                _balances[users[_uid].pid] = _balances[users[_uid].pid].add(
                    _amount.mul(1).div(100)
                );
                emit Transfer(
                    _sender,
                    users[_uid].pid,
                    _amount.mul(1).div(100)
                );
                _bonusTotal[users[_uid].pid] = _bonusTotal[users[_uid].pid].add(
                    _amount.mul(1).div(100)
                );
                _total = _total.add(_amount.mul(1).div(100));
            }
            if (_level == 8) break;
            _uid = users[_uid].pid;
            _level++;
        }
        if (_amount.mul(8).div(100) > _total) {
            _balances[_pools] = _balances[_pools].add(
                _amount.mul(8).div(100).sub(_total)
            );
            emit Transfer(_sender, _pools, _amount.mul(8).div(100).sub(_total));
        }
    }

    function isUser(address _uid) public view returns (bool) {
        return users[_uid].uid != address(0);
    }

    function getInviter(address _uid) public view returns (address) {
        return users[_uid].pid;
    }

    function _register(address _uid, address _pid) internal {
        if (!isUser(_pid)) {
            _pid = _inviter;
        }
        users[_uid] = user(_uid, _pid);
        _airdrop(_uid);
    }

    function _airdrop(address _uid) internal {
        if (_airdropTotal < 1000e18) {
            _airdrops[_uid] = _airdropNum;
            _airdropTotal = _airdropTotal.add(_airdropNum);
        }
    }

    function setCakeLP(address _cakeLP) public onlyOwner {
        for (uint256 i = 0; i < _cakeLPs.length; i++) {
            if (_cakeLPs[i] == _cakeLP) {
                revert("LP is exist");
            }
        }
        _cakeLPs.push(_cakeLP);
    }

    function setCakeLP(address _cakeLP, uint256 _index) public onlyOwner {
        require(_index < _cakeLPs.length);
        _cakeLPs[_index] = _cakeLP;
    }

    function getCakeLP(uint256 index)
        public
        view
        returns (address cakeLP, uint256 length)
    {
        if (index < _cakeLPs.length) {
            return (_cakeLPs[index], _cakeLPs.length);
        } else {
            return (address(0), _cakeLPs.length);
        }
    }

    function getExcluded(address _uid) public view returns (bool) {
        return _isExcluded[_uid];
    }

    function setExcluded(address _uid) public onlyOwner {
        _isExcluded[_uid] = true;
    }

    function unsetExcluded(address _uid) public onlyOwner {
        _isExcluded[_uid] = false;
    }

    function setLockTime(uint256 _time) public onlyOwner {
        _lockTime = _time;
    }
}