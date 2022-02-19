// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

import "./OpenTicket.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

/**
 * @title OpenEvents
 * @dev It is a main contract that provides ability to create events, view information about events and buy tickets.
 */
contract OpenEvents is OpenTicket, Pausable {
    using SafeMath for uint256;

    struct OpenEvent {
        address owner;
        string name;
        uint256 time;
        bool token;
        bool limited;
        uint256 price;
        uint256 seats;
        uint256 sold;
        bool vipAvailable;
        uint256 vipPrice;
        uint256 vipTicketSupply;
        uint256 vipSold;
        string ipfs;
    }

    OpenEvent[] private openEvents;

    // Mapping from owner to list of owned events IDs.
    mapping(address => uint256[]) private ownedEvents;

    mapping(address => uint256) internal adminEvents;

    mapping(address => mapping(uint256 => uint256)) internal promoterEventComps;

    event CreatedEvent(address indexed owner, uint256 eventId);
    event SoldTicket(
        address indexed buyer,
        uint256 indexed eventId,
        uint256 ticketId,
        bool vip
    );
    event RedeemedTicket(uint256 indexed eventId, uint256 ticketId, bool vip);

    // event MintedTicket(address indexed buyer, uint indexed eventId, uint ticketId, bool vip);

    /**
     *	General TODOs
     *	- Add uint guestListSupply to OpenEvent struct.
     *	- Update createEvent params.
     *	* Add promoterEventTickets mapping(address => mapping(uint => uint)). Respresenting # of guest tix a promoter can give out.
     * 	* Add eventPromoterHasNComps modifier.
     *	- Replace existing admin frontend with dapp hosted at https://admin.jetgangbenefit.com/
     *	- Add batchRedeem and ability to read user event ticket balance before initiating variable quantity redeem in second step.
     *	  with intuitive interface and resposnive design.
     *	- Add purchase modals w/ ticket options (art work, vip settings, contact info, email opt-in).
     *	- CRM.
     *	- Email list.
     *	/ Rename SoldTicket event.
     *	- Rename OpenEvent.seats field.
     *	X Move ticket supply related require statements, using OpenEvent.seats field, to modifier seatsAvailable.
     *	- Design functionality to support assigned seating.
     *	- Design open-access customer ticketing platform and revenue model.
     *	- Resale royalties for vendor bulk orders.
     **/

    /**
     *	VIP TODOs
     *	* Add uint vipPrice and vipSold to OpenEvent struct.
     *	* Add uint vipAvailable, vipTicketSupply, to OpenEvent struct.
     *	X Add vipAvailable modifier.
     *	* Update createEvent params.
     *	* Add bool vip to OpenTicket struct.
     *	* Update buyTicket and grantTicket with param bool _vip and related control flow for utilizing vipPrice from
     *	  openEvents[_eventId].
     *	* Update redeemTicket to return true if vip, false if not.
     *	* Update getEvent and getTicket accordingly.
     *	-
     *	-
     *	- Update admin frontend w/ ability to read redeemTicket ret value beyond the existing alert/toast indicating success.
     **/

    constructor() public {}

    /**
     * @dev Throws is address is not event owner.
     * @param _eventId - ID of event.
     **/
    modifier onlyEventOwner(uint256 _eventId) {
        require(msg.sender == openEvents[_eventId].owner);
        _;
    }

    /**
     * @dev Throws if address is not event admin.
     * @param _admin - Address of admin.
     * @param _eventId - ID of event.
     */
    modifier onlyEventAdmin(address _admin, uint256 _eventId) {
        require(adminEvents[_admin] == _eventId);
        // "You must be event an admin."
        _;
    }

    /**
     * @dev Throws if address is not event admin.
     * @param _promoter - Address of admin.
     * @param _eventId - ID of event.
     * @param _qty - Number of comps required.
     */
    modifier eventPromoterHasNComps(
        address _promoter,
        uint256 _eventId,
        uint256 _qty
    ) {
        require(promoterEventComps[_promoter][_eventId] > _qty);
        // "You must be an event promoter and have sufficient comps available."
        _;
    }

    /**
     * @dev Throws if events time is in the past.
     * @param _time - Time of event.
     */
    modifier goodTime(uint256 _time) {
        require(_time > now);
        _;
    }

    /**
     * @dev Throws if event does not exist.
     * @param _eventId - Event ID.
     */
    modifier eventExist(uint256 _eventId) {
        require(_eventId < openEvents.length);
        _;
    }

    /**
     * @dev Throws if there are not enough VIP tickets remaining in vipTicketSupply for a given event.
     * @param _eventId - ID of the event to validate VIP ticket supply for.
     * @param _qty - Quantity of VIP tickets to confirm availability of.
     * @return uint - Number of remaining VIP tickets.
     **/
    function vipRemaining(uint256 _eventId, uint256 _qty)
        public
        view
        returns (uint256)
    {
        return openEvents[_eventId].vipTicketSupply.sub(_qty);
    }

    /**
     * @dev Function creates the event.
     * @param _name - The name of the event.
     * @param _time - The time of the event. Should be in the future.
     * @param _price - The ticket price.
     * @param _vipPrice - The VIP ticket price.
     * @param _token - If true the price will be in tokens, else the price will be in ethereum.
     * @param _limited - If true event has limited seats.
     * @param _vipAvailable - If true event has vip available.
     * @param _seats - If event has limited seats, says how much tickets can be sold.
     * @param _vipTicketSupply - If event has limited seats, says how much tickets can be sold.
     * @param _ipfs - The IPFS hash containing additional information about the event.
     * @notice Requires that the events time is in the future.
     * @notice Requires that the contract is not paused.
     */
    function createEvent(
        string _name,
        uint256 _time,
        bool _token,
        bool _limited,
        uint256 _price,
        uint256 _seats,
        bool _vipAvailable,
        uint256 _vipPrice,
        uint256 _vipTicketSupply,
        string _ipfs
    ) public goodTime(_time) whenNotPaused {
        OpenEvent memory _event = OpenEvent({
            owner: msg.sender,
            name: _name,
            time: _time,
            token: _token,
            limited: _limited,
            price: _price,
            seats: _seats,
            sold: 0,
            vipAvailable: _vipAvailable,
            vipPrice: _vipPrice,
            vipTicketSupply: _vipTicketSupply,
            vipSold: 0,
            ipfs: _ipfs
        });
        uint256 _eventId = openEvents.push(_event).sub(1);
        ownedEvents[msg.sender].push(_eventId);
        emit CreatedEvent(msg.sender, _eventId);
    }

    /**
     * @dev Function to show all events of the specified address.
     * @param _owner - The address to query the events of.
     * @return uint[] - Array of events IDs.
     */
    function eventsOf(address _owner) public view returns (uint256[] memory) {
        return ownedEvents[_owner];
    }

    /**
     * @dev Function to set event admins.
     * @param _admin - The address to set as admin.
     * @param _eventId - The event ID admin priveledges will be granted for.
     */
    function setEventAdmin(address _admin, uint256 _eventId)
        public
        onlyEventOwner(_eventId)
    {
        adminEvents[_admin] = _eventId;
    }

    /**
     * @dev Function to set event admins.
     * @param _promoter - The address to set as admin.
     * @param _eventId - The event ID admin priveledges will be granted for.
     * @param _comps - The number of comp tickets to grant promoter permission to mint.
     */
    function setEventPromoterComps(
        address _promoter,
        uint256 _eventId,
        uint256 _comps
    ) public onlyEventOwner(_eventId) {
        promoterEventComps[_promoter][_eventId] = _comps;
    }

    /**
     * @dev Function to set event admins.
     * @param _admin - The address to set as admin.
     */
    function getAdminEvent(address _admin) public view returns (uint256) {
        return adminEvents[_admin];
    }

    /**
     * @dev Function to set event admins.
     * @param _promoter - The address to set as admin.
     * @param _eventId - The event ID admin priveledges will be granted for.
     * @return comps uint - The number of comp tickets to grant promoter permission to mint.
     */
    function getEventPromoterComps(address _promoter, uint256 _eventId)
        public
        view
        returns (uint256 comps)
    {
        return promoterEventComps[_promoter][_eventId];
    }

    /**
     * @dev Function to show general adminssions information for the event.
     * @param _eventId - Event ID.
     * @notice Requires that the events exist.
     * @return name string - The name of the event.
     * @return time uint - The time of the event. Should be in the future.
     * @return token bool - If true the price will be in tokens, else the price will be in ethereum.
     * @return limited bool - If true event has limited seats.
     * @return price uint - The ticket price.
     * @return seats uint - If event has limited seats, says how much tickets can be sold.
     * @return sold uint - If event has limited seats, says how much tickets can be sold.
     * @return ipfs string - The IPFS hash containing additional information about the event.
     * @return owner address - The owner of the event.
     */
    function getEvent(uint256 _eventId)
        public
        view
        eventExist(_eventId)
        returns (
            string memory name,
            uint256 time,
            bool token,
            bool limited,
            uint256 price,
            uint256 seats,
            uint256 sold,
            string memory ipfs,
            address owner
        )
    {
        OpenEvent memory _event = openEvents[_eventId];
        return (
            _event.name,
            _event.time,
            _event.token,
            _event.limited,
            _event.price,
            _event.seats,
            _event.sold,
            _event.ipfs,
            _event.owner
        );
    }

    /**
     * @dev Function to show VIP information for the event.
     * @param _eventId - Event ID.
     * @notice Requires that the events exist.
     * @return vipAvailable bool - If true event has vip available.
     * @return vipPrice uint - The VIP ticket price.
     * @return vipTicketSupply uint - Says how much tickets can be sold.
     * @return vipSold uint - If event has limited seats, says how much tickets can be sold.
     * @return ipfs string - The IPFS hash containing additional information about the event.
     **/
    function getEventVIP(uint256 _eventId)
        public
        view
        eventExist(_eventId)
        returns (
            bool vipAvailable,
            uint256 vipPrice,
            uint256 vipTicketSupply,
            uint256 vipSold
        )
    {
        OpenEvent memory _event = openEvents[_eventId];
        return (
            _event.vipAvailable,
            _event.vipPrice,
            _event.vipTicketSupply,
            _event.vipSold
        );
    }

    /**
     * @dev Function returns number of all events.
     * @return uint - Number of events.
     */
    function getEventsCount() public view returns (uint256) {
        return openEvents.length;
    }

    /**
     * @dev Function to grant ticket to address on guest list.
     * @param _guest - The address of guest list member.
     * @param _eventId - The ID of event.
     * @param _vip - Is ticket VIP?
     * @param _qty - Ticket quantity to mint.
     * @notice Requires that the events exist.
     * @notice Requires that the events time is in the future.
     * @notice Requires that the contract is not paused.
     * @notice Reverts if event has limited seats and an amount of sold tickets bigger then the number of seats.
     */
    function grantTicket(
        address _guest,
        uint256 _eventId,
        bool _vip,
        uint256 _qty
    )
        public
        payable
        eventExist(_eventId)
        goodTime(openEvents[_eventId].time)
        whenNotPaused
        onlyEventAdmin(msg.sender, _eventId)
    {
        OpenEvent memory _event = openEvents[_eventId];

        Ticket memory _ticket;

        uint256 seat;

        if (!_vip) {
            if (_event.limited) {
                require(_event.seats > _event.sold);
            }

            seat = _event.sold.add(1);
            openEvents[_eventId].sold = seat;

            _ticket = Ticket({
                event_id: _eventId,
                vip: false,
                seat: seat,
                image: _event.ipfs
            });
        } else {
            if (_event.vipAvailable) {
                require(_qty < _event.vipTicketSupply.sub(_event.vipSold));
                // "Not enough VIP tickets remaining for this event."
            }

            seat = _event.sold.add(1);
            openEvents[_eventId].sold = seat;

            uint256 vipSold = _event.vipSold.add(1);
            openEvents[_eventId].vipSold = vipSold;

            _ticket = Ticket({
                event_id: _eventId,
                vip: true,
                seat: seat,
                image: _event.ipfs
            });
        }

        uint256 _ticketId = tickets.push(_ticket).sub(1);
        ticketValidity[_ticketId] = true;
        _mint(_guest, _ticketId);
        emit SoldTicket(_guest, _eventId, _ticketId, _vip);
        // emit MintedTicket(_guest, _eventId, _ticketId, _vip);
    }

    /**
     * @dev Function to buy ticket to specific event.
     * @param _eventId - The ID of event.
     * @param _vip - Is ticket VIP?
     * @param _qty - Ticket quantity to mint.
     * @notice Requires that the events exist.
     * @notice Requires that the events time is in the future.
     * @notice Requires that the contract is not paused.
     * @notice Reverts if event has limited seats and an amount of sold tickets bigger then the number of seats.
     * @notice Reverts if ticket price is in ethereum and msg.value smaller then the ticket price.
     * @notice Reverts if ticket price is in tokens and token.transferFrom() does not return true.
     */
    function buyTicket(
        uint256 _eventId,
        bool _vip,
        uint256 _qty
    )
        public
        payable
        eventExist(_eventId)
        goodTime(openEvents[_eventId].time)
        whenNotPaused
    {
        OpenEvent memory _event = openEvents[_eventId];

        uint256 seat = _event.sold.add(1);
        openEvents[_eventId].sold = seat;

        uint256 _ticketId;

        if (!_vip) {
            if (_event.limited) require(_event.seats > _event.sold);

            // if (!_event.token) {
            require(msg.value >= _event.price);
            _event.owner.transfer(_event.price);
            // } else {
            // if (!ERC20(tokenAddress).transferFrom(msg.sender, _event.owner, _event.price)) {
            // revert();
            // }
            // }

            Ticket memory _ticket = Ticket({
                event_id: _eventId,
                vip: false,
                seat: seat,
                image: _event.ipfs
            });

            _ticketId = tickets.push(_ticket).sub(1);
        } else {
            if (_event.vipAvailable) {
                require(_qty < _event.vipTicketSupply.sub(_event.vipSold));
                // "Not enough VIP tickets remaining for this event."
            }

            // if (!_event.token) {
            require(msg.value >= _event.vipPrice);
            _event.owner.transfer(_event.vipPrice);
            // } else {
            //  if (!ERC20(tokenAddress).transferFrom(msg.sender, _event.owner, _event.vipPrice)) {
            // revert();
            // }
            // }

            uint256 vipSold = _event.vipSold.add(1);
            openEvents[_eventId].vipSold = vipSold;

            Ticket memory _vipTicket = Ticket({
                event_id: _eventId,
                vip: true,
                seat: seat,
                image: _event.ipfs
            });

            _ticketId = tickets.push(_vipTicket).sub(1);
        }

        ticketValidity[_ticketId] = true;
        _mint(msg.sender, _ticketId);
        emit SoldTicket(msg.sender, _eventId, _ticketId, _vip);
        // emit MintedTicket(msg.sender, _eventId, _ticketId, _vip);
    }

    /**
     * @dev Function to redeem ticket to specific event.
     * @param _ticketId - The ID of ticket.
     * @param _eventId - The ID of event.
     * @param _vip - Boolean representing the VIP status of the ticket to redeem.
     * @notice Requires that the events exist.
     * @notice Requires that the contract is not paused.
     * @notice Requires that the caller is an event admin.
     * @notice Requires that the ticket is present.
     */
    function redeemTicket(
        uint256 _ticketId,
        uint256 _eventId,
        bool _vip
    )
        public
        eventExist(_eventId)
        whenNotPaused
        onlyEventAdmin(msg.sender, _eventId)
        validTicket(_ticketId)
        returns (bool)
    {
        ticketValidity[_ticketId] = false;
        emit RedeemedTicket(_eventId, _ticketId, _vip);
        return _vip;
    }
}
