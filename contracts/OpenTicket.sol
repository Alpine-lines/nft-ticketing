// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";

/**
 * @title OpenTicket
 * @dev It is an implementation of ERC721Token that provides ability to view information about tickets.
 */
contract OpenTicket is
    ERC721Token("Jet Gang Benefit Concert Series NFTicket", "JGBT")
{
    struct Ticket {
        uint256 event_id;
        bool vip;
        uint256 seat;
        string image;
    }

    mapping(address => mapping(uint256 => uint256)) public ownedEventTickets;

    mapping(uint256 => bool) internal ticketValidity;

    Ticket[] internal tickets;

    /**
     * @dev Throws if ticket is not valid.
     * @param _ticketId - ID of event.
     */
    modifier validTicket(uint256 _ticketId) {
        require(ticketValidity[_ticketId], "Ticket is not valid");
        _;
    }

    /**
     * @dev Function to show all tickets of the specified address.
     * @param _owner - The address to query the tickets of.
     * @return uint[] - Array of tickets ID.
     */
    function ticketsOf(address _owner) public view returns (uint256[] memory) {
        return ownedTokens[_owner];
    }

    /**
     * @dev Function to show balance of all tickets for specified event and address.
     * @param _owner - The address to query the event ticket balance of.
     * @param event_id - The event ID to query for owner ticket balance.
     * @return uint - Owner event ticket balance.
     */
    function eventTicketBalanceOf(address _owner, uint256 event_id)
        public
        view
        returns (uint256)
    {
        return ownedEventTickets[_owner][event_id];
    }

    /**
     * @dev Function to show ticket information.
     * @param _id - Ticket ID.
     * @return uint - Event ID.
     * @return uint - Ticket seat.
     * @return bool - Ticket validity.
     * @return string - Ticket image IPFS URL.
     */
    function getTicket(uint256 _id)
        public
        view
        returns (
            uint256,
            uint256,
            bool,
            string memory
        )
    {
        require(_id < tickets.length);
        Ticket memory _ticket = tickets[_id];
        return (
            _ticket.event_id,
            _ticket.seat,
            ticketValidity[_id],
            _ticket.image
        );
    }

    /**
     * @dev Internal function to add a token ID to the list of a given address
     * @param _to - representing the new owner of the given token ID
     * @param _tokenId - ID of the token to be added to the tokens list of the given address
     */
    function addTokenTo(address _to, uint256 _tokenId) internal {
        super.addTokenTo(_to, _tokenId);
        uint256 _eventId = tickets[_tokenId].event_id;
        ownedEventTickets[_to][_eventId] += 1;
    }

    /**
     * @dev Internal function to remove a token ID from the list of a given address
     * @param _from - representing the previous owner of the given token ID
     * @param _tokenId - ID of the token to be removed from the tokens list of the given address
     */
    function removeTokenFrom(address _from, uint256 _tokenId) internal {
        super.removeTokenFrom(_from, _tokenId);
        uint256 _eventId = tickets[_tokenId].event_id;
        ownedEventTickets[_from][_eventId] -= 1;
    }
}
