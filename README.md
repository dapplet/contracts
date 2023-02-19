# Dapplet Contracts

Contracts for Dapplet; an ecosystem for collaborative dApp development and end-user dApp composability.

### The Package (PKG, dapplet, etc):

A package is an external 'simple storage' contract that holds arguments for a `diamondCut(FacetCut[] cuts, address target, bytes data)` function. It has the ability to provide arguments for both installing and uninstalling a collection of facets. This should be simple to understand by looking at the IPKG.sol interface:

```solidity
interface IPKG is IERC4626Base {

  enum UPGRADE { INSTALL, UNINSTALL }

  struct CUT {
    IDiamondWritable.FacetCut[] cuts;
    address target;
    bytes data;
  }

  function set(
    address _token,
    IDiamondWritable.FacetCut[] memory _cuts,
    address _target,
    bytes memory _data
  ) external;

  function get(UPGRADE action) external view returns (
    IDiamondWritable.FacetCut[] memory,
    address,
    bytes memory
  );
}
```

### The Client

The very first thing a user must do when interacting with Dapplet is to **Create a Client (an [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535) Diamond)**. Upon doing so, a Client (the Proxy/Diamond) is a created for the user. This Client uses Diamond.sol to store function-selector mappings to facets. The following facets (implementation contracts) are used by default:

- DiamondLoupeFacet.sol: A standard DiamondLoupeFacet as described in [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535)
- ERC165Facet.sol: A standard Interface Detection facet.
- OwnershipFacet.sol: A standard EIP-173 Ownership contract facet.
- Installer.sol: Arguably the most important facet is Installer.sol. It implements the following functions:

```solidity
  function install(address _pkg) external payable;

  function uninstall(address _pkg) external;

  function create(
    IPKG.CUT memory _pkg,
    string memory _ipfsCid
  ) external payable returns (address pkg);
```

Installer.sol is the main portal by which the Client interacts with the 'Shell'.

### Wtf is the 'Shell'?

The Shell is the Diamond in which most of the system's relevant data is securely stored. The Shell has the following facets:

- AdminFacet: Responsible for managing systemwide changes (ex: setting fees, setting default client cuts, etc)
- ClientRegistry: The entry point by which a user deploys their Client (diamond).
- ConnectorFacet: This is the portal for which the Installer.sol accesses the Shell.
- DiamondCutFacet: A standard DiamondCutFacet as explained in [EIP-2535](https://eips.ethereum.org/EIPS/eip-2535).
- ViewerFacet: This is meant to contain all "view" functions. Here we can get closer looks at packages and their stake, owner, and metadata IPFS CID.
- WETHFacet: A simple deposit/withdraw Wrapped Ether contract facet.

Most of the internal logic for these facets is stored inside the [storage contracts](/contracts/shell/storage/).

### Modifiers

The Shell contains a few modifiers that act as security or disincentivization checks. The following [inherited contracts](/contracts/shell/inherited/) implement such modifiers:

- AccessControllable.sol: modifiers that check that the caller possesses a 'role'
  - client role = `onlyClient`
  - admin role = `onlyAdmin`
- TokenControllable.sol: modifiers that control WETH transfers to either the system diamond or the pkg vaults / owners
  - `sendSystemFee` sends a fee to the Shell multisig, used on `createClient` and `createPkg` functions.
  - `sendPkgFees` sends a fee to the PKG, which implements an [EIP-4626](https://eips.ethereum.org/EIPS/eip-4626) vault. This allows a PKG/dapplet to accumulate and payout WETH to those staking on the PKG. `sendPkgFees` also sends a fee to the owner of the PKG, but in the future, this may be substituted for supplying voting power in the DAO to the PKG owner.

### Contributors / Special Thanks

- TJ VanSlooten (@tjvsx)
- John Reynolds (@gweiworld)
- Nick Mudge (@mudgen)
- Marco Castignoli (@marcocastignoli)
- Nick Barry (@ItsNickBarry)
- Florian Rappl (@florianrappl)
- Cory LaViska (@corylaviska)
- Cyotee Doge (@cyotee)
- Max Kaay (@maxkaay)
- Vitalik Buterin (@vitalikbuterin)
- Victor (@fractalscaling)
- Roleengineer (@roleengineer)
- 0xHabitat (@0xHabitat)
