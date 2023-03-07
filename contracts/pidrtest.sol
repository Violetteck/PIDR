// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract PIDRTest {

    uint seed = 0;
    uint salePrice = 0.01 ether;
    bool transforming = false;
    mapping (uint => address) public artworkToOwner;
    mapping (uint => string) public artworkToUri;

    event TransformUri();

    struct Artwork {
        uint idArtwork;
        address owner;
        string uri;
    }

    Artwork internal artwork;

    constructor() {
        artwork = Artwork(0, msg.sender, "");
        transforming = true;
        emit TransformUri();
        transforming = false;
        _updateMaps();
    }

    modifier ownerOnly() {
        require(msg.sender == artwork.owner);
        _;
    }

    modifier minted(uint tokenId) {
        require(tokenId <= artwork.idArtwork);
        _;
    }

    modifier isTransforming() {
        require(transforming);
        _;
    }

    function _updateMaps() private {
        artworkToOwner[artwork.idArtwork] = artwork.owner;
        artworkToUri[artwork.idArtwork] = artwork.uri;
    }

    function _generateRandom() private returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, seed)));
        seed ++;
        return rand;
    }

    function _changeID() private {
        artwork.idArtwork = _generateRandom();
    }

    function _transfer(address _to) internal {
        artwork.owner = _to;
        //_changeID();
        artwork.idArtwork++;
        transforming = true;
        emit TransformUri();
        transforming = false;
        _updateMaps();
    }

    function setArtworkUri(string calldata _uri) public ownerOnly isTransforming {
        artwork.uri = _uri;
    }
}