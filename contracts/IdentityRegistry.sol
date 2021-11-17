// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

contract IdentityRegistry {

    address private owner;
    uint constant PENDING = 0;
    uint constant ACTIVE = 1;
    uint constant REJECTED = 2;

    constructor() {
        owner = msg.sender;
    }

    struct IDocument {
        bytes32 docHash;
        address submitter;
        uint status;
    }

    mapping(bytes32 => IDocument) public idocuments;

    modifier onlyBy(address _account) {
        require(msg.sender == _account, "You are not permitted");
        _;
    }

    function submitDocument(bytes32 _docHash) 
    public
    returns(bool) 
    {
        IDocument storage idocument = idocuments[_docHash];
        idocument.docHash = _docHash;
        idocument.submitter = msg.sender;
        idocument.status = PENDING;
        return true;
    }

    function approveDocument(bytes32 _docHash) 
    public
    onlyBy(owner) 
    returns(bool) 
    {
        IDocument storage idocument = idocuments[_docHash];
        idocument.status = ACTIVE;
        return true;
    }

    function rejectDocument(bytes32 _docHash) 
    public
    onlyBy(owner) 
    returns(bool) 
    {
        IDocument storage idocument = idocuments[_docHash];
        idocument.status = REJECTED;
        return true;
    }
}
