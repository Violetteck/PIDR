// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NFTLamuse is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string private _artworkUri;
    bool busy = false;
    mapping (uint => address) public artworkToOwner;

    event Transform(address callerAddress);

    constructor() ERC721("NFTLamuse", "LAM") {}

    modifier notBusy() {
        require(busy == false);
        _;
    }


    function safeMint(address _to, string _uri) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        artworkToOwner[tokenId] = msg.sender;
        _safeMint(_to, tokenId);
        _setTokenURI(tokenId, _uri);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public onlyOwner {
        busy = true;
        emit Transform(_from);

        safeMint(_to, _artworkUri);
        _burn(_tokenId);
        busy = false;
    }

    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return artworkToOwner[_tokenId];
    }

    function _burn(uint256 tokenId) internal override {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function setArtworkUri(string _uri) public onlyOwner, notBusy {
        _artworkUri = _uri;
    }
}