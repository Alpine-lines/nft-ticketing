// SPDX-License-Identifier: MIT
pragma solidity ^0.4.24;

import "./OpenTicket.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * @title OpenEvents
 * @dev It is a main contract that provides ability to create events, view information about events and buy tickets.
 */
contract OpenEvents is Ownable, OpenTicket, Pausable {
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
        string ipfs;
    }

    struct VIPSettings {
        uint256 price;
        uint256 seats;
        uint256 sold;
        bool bottleService;
        bool exclusive;
    }

    OpenEvent[] private openEvents;

    // Mapping from owner to list of owned events IDs.
    mapping(address => uint256[]) private ownedEvents;

    mapping(uint256 => VIPSettings[]) private eventVIPSettings;

    // mapping(uint256 => mapping(uint256 => uint256))
    // private eventIdToVIPIdToEventVIPSettingsIndex;

    mapping(address => uint256) internal adminEvents;

    mapping(address => mapping(uint256 => uint256)) internal promoterEventComps;

    mapping(uint256 => uint256) public vipTickets;

    uint256 public latestEvent; 
    event CreatedEvent(address indexed owner, uint256 eventId);
    event CreatedVIPPackage(uint256 eventId, uint256 vipId);
    event SoldTicket(
        address indexed buyer,
        uint256 indexed eventId,
        uint256 ticketId,
        uint256 vip
    );
    event RedeemedTicket(
        uint256 indexed eventId,
        uint256 ticketId,
        uint256 vip
    );

    // event MintedTicket(address indexed buyer, uint indexed eventId, uint ticketId, bool vip);

    /**
     *	General TODOs
     *	- Add uint guestListSupply to OpenEvent struct.
     *	- Update createEvent params.
     *	* Add promoterEventTickets mapping(address => mapping(uint => uint)). Respresenting # of guest tix a promoter can give out.
     * 	* Add eventPromoterHasNComps modifier.
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
     *	URGENT/IMPORTANT TODOs
     *	- Replace existing admin frontend with dapp hosted at https://admin.jetgangbenefit.com/
     *	* Add uint vipPrice and vipSold to OpenEvent struct.
     *	* Add uint vipAvailable, vipTicketSupply, to OpenEvent struct.
     *	X Add vipAvailable modifier.
     *	* Update createEvent params.
     *	* Add bool vip to OpenTicket struct.
     *	* Update buyTicket and grantTicket with param bool _vip and related control flow for utilizing vipPrice from
     *	  openEvents[_eventId].
     *	* Update redeemTicket to return true if vip, false if not.
     *	* Update getEvent and getTicket accordingly.
     *	- Accept additional donation.
     *	- Add setters for OpenEvent struct.
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

    modifier eventVIPExists(uint256 _eventId, uint256 _vipId) {
        require(eventVIPSettings[_eventId].length.sub(1) >= _vipId);
        _;
    }

    // uint256 _qty
    //  * @param _qty - Quantity of VIP tickets to confirm availability of.

    /**
     * @dev Throws if there are not enough VIP tickets remaining in vipTicketSupply for a given event.
     * @param _eventId - ID of the event to validate VIP ticket supply for.
     * @return uint - Number of remaining VIP tickets.
     **/
    function vipRemaining(uint256 _eventId, uint256 _vipId)
        public
        view
        returns (uint256)
    {
        VIPSettings memory _vipSettings = eventVIPSettings[_eventId][_vipId];
        return _vipSettings.seats.sub(_vipSettings.sold);
    }

    /**
     * @dev Function creates the event.
     * @param _name - The name of the event.
     * @param _time - The time of the event. Should be in the future.
     * @param _token - If true the price will be in tokens, else the price will be in ethereum.
     * @param _limited - If true event has limited seats.
     * @param _price - The ticket price.
     * @param _seats - If event has limited seats, says how much tickets can be sold.
     * @param _vipAvailable - If true event has vip available.
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
        string _ipfs
    ) public goodTime(_time) whenNotPaused onlyOwner {
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
            ipfs: _ipfs
        });
        uint256 _eventId = openEvents.push(_event).sub(1);
        ownedEvents[msg.sender].push(_eventId);
        latestEvent = _eventId;
        emit CreatedEvent(msg.sender, _eventId);
    }

    /**
     * @dev Function to set VIP package settings for event.
     * @param _eventId - ID of event.
     * @param _price - Price of VIP ticket in ETH.
     * @param _seats - Number of seats/tickets available.
     * @param _sold - Number of seats/tickets sold.
     * @param _bottleService - Boolean indicating package includes bottle service.
     * @param _exclusive - Boolean indicating that a ticket holder is eligible to receive package exclusive.
     */
    function addVIPPackage(
        uint256 _eventId,
        uint256 _price,
        uint256 _seats,
        uint256 _sold,
        bool _bottleService,
        bool _exclusive
    ) public onlyEventOwner(_eventId) {
        VIPSettings memory _vipPackage = VIPSettings({
            price: _price,
            seats: _seats,
            sold: _sold,
            bottleService: _bottleService,
            exclusive: _exclusive
        });
        eventVIPSettings[_eventId].push(_vipPackage);
        uint256 _vipId = eventVIPSettings[_eventId].length.sub(1);
        vipTickets[_eventId] = _vipId;
        // eventVIPPackages[_eventId][
        // _vipId
        // ] = _vipPackage;
        emit CreatedVIPPackage(_eventId, _vipId);
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
     * @param _eventId - Event ID.
     * @notice Requires that the events exist.
     * @return price uint256 - If true event has vip available.
     * @return seats uint256 - The VIP ticket price.
     * @return sold uint256 - Says how much tickets can be sold.
     * @return bottleService bool - If event has limited seats, says how much tickets can be sold.
     * @return exclusive bool - If event has limited seats, says how much tickets can be sold.
     * @return ipfs string - The IPFS hash containing additional information about the event.
     **/
    function getEventVIP(uint256 _eventId, uint256 _vipId)
        public
        view
        eventExist(_eventId)
        returns (
            uint256 price,
            uint256 seats,
            uint256 sold,
            bool bottleService,
            bool exclusive
        )
    {
        VIPSettings memory _vipPackage = eventVIPSettings[_eventId][_vipId];
        return (
            _vipPackage.price,
            _vipPackage.seats,
            _vipPackage.sold,
            _vipPackage.bottleService,
            _vipPackage.exclusive
        );
    }

    /**
     * @dev Function returns number of all events.
     * @return uint - Number of events.
     */
    function getEventsCount() public view returns (uint256) {
        return openEvents.length;
    }

    // uint256 _qty
    //  * @param _qty - Ticket quantity to mint.

    /**
     * @dev Function to grant ticket to address on guest list.
     * @param _guest - The address of guest list member.
     * @param _eventId - The ID of event.
     * @notice Requires that the events exist.
     * @notice Requires that the events time is in the future.
     * @notice Requires that the contract is not paused.
     * @notice Reverts if event has limited seats and an amount of sold tickets bigger then the number of seats.
     */
    function grantTicket(address _guest, uint256 _eventId)
        public
        payable
        eventExist(_eventId)
        goodTime(openEvents[_eventId].time)
        whenNotPaused
        onlyEventAdmin(msg.sender, _eventId)
    {
        OpenEvent memory _event = openEvents[_eventId];

        if (_event.limited) {
            require(_event.seats > _event.sold);
        }

        uint256 seat = _event.sold.add(1);
        openEvents[_eventId].sold = seat;

        Ticket memory _ticket = Ticket({
            event_id: _eventId,
            vip: 0,
            seat: seat,
            image: _event.ipfs
        });

        uint256 _ticketId = tickets.push(_ticket).sub(1);
        ticketValidity[_ticketId] = true;
        _mint(_guest, _ticketId);
        emit SoldTicket(_guest, _eventId, _ticketId, 0);
    }

    // , uint256 _qty
    // * @param _qty - Ticket quantity to mint.

    /**
     * @dev Function to buy ticket to specific event.

     * @notice Requires that the events exist.
     * @notice Requires that the events time is in the future.
     * @notice Requires that the contract is not paused.
     * @notice Reverts if event has limited seats and an amount of sold tickets bigger then the number of seats.
     * @notice Reverts if ticket price is in ethereum and msg.value smaller then the ticket price.
     * @notice Reverts if ticket price is in tokens and token.transferFrom() does not return true.
     */
    function buyTicket()
        public
        payable
        eventExist(latestEvent)
        goodTime(openEvents[latestEvent].time)
        whenNotPaused
    {
        OpenEvent memory _event = openEvents[latestEvent];

        uint256 seat = _event.sold.add(1);
        openEvents[latestEvent].sold = seat;

        uint256 _ticketId;

        if (_event.limited) require(_event.seats > _event.sold, "Sold Out");

        require(msg.value >= _event.price, "Not enough sent");
        _event.owner.transfer(_event.price);

        Ticket memory _ticket = Ticket({
            event_id: latestEvent,
            vip: 0,
            seat: seat,
            image: _event.ipfs
        });

        _ticketId = tickets.push(_ticket).sub(1);

        ticketValidity[_ticketId] = true;
        _mint(msg.sender, _ticketId);
        emit SoldTicket(msg.sender, latestEvent, _ticketId, 0);
    }

    /**
     * @dev Function to purchase a VIP ticket.

     **/
    function buyVIPTicket()
        public
        payable
        eventExist(latestEvent)
        eventVIPExists(latestEvent, _vipId)
        goodTime(openEvents[latestEvent].time)
        whenNotPaused
    {   
        uint256 _vipId = vipTickets[latestEvent];
        VIPSettings memory _vipPackage = eventVIPSettings[latestEvent][_vipId];
        uint256 _qty = msg.value / _vipPackage.price;

        OpenEvent memory _event = openEvents[latestEvent];

        require(_qty < _vipPackage.seats.sub(_vipPackage.sold));
        // "Not enough VIP tickets remaining for this event."

        require(msg.value >= _vipPackage.price);
        _event.owner.transfer(_vipPackage.price);

        uint256 seat = _vipPackage.sold.add(1);
        eventVIPSettings[latestEvent][_vipId].sold = seat;

        Ticket memory _vipTicket = Ticket({
            event_id: latestEvent,
            vip: _vipId,
            seat: seat,
            image: _event.ipfs
        });

        uint256 _ticketId = tickets.push(_vipTicket).sub(1);
        _mint(msg.sender, _ticketId);
        //return dust
        if( _qty.mul(_vipPackage.price) < msg.value) {
            msg.sender.transfer(_qty.mul(_vipPackage.price).sub(msg.value));
        }
        emit SoldTicket(msg.sender, latestEvent, _ticketId, 0);
    }

    /**
     * @dev Function to redeem ticket to specific event.
     * @param _ticketId - The ID of ticket.
     * @param _eventId - The ID of event.
     * @notice Requires that the events exist.
     * @notice Requires that the contract is not paused.
     * @notice Requires that the caller is an event admin.
     * @notice Requires that the ticket is present.
     * @return vip uint256 - ID of the VIP package of redeemed ticket. 0 represents GA.
     */
    function redeemTicket(uint256 _ticketId, uint256 _eventId)
        public
        eventExist(_eventId)
        whenNotPaused
        onlyEventAdmin(msg.sender, _eventId)
        validTicket(_ticketId)
        returns (uint256)
    {
        ticketValidity[_ticketId] = false;
        uint256 vip = tickets[_ticketId].vip;
        emit RedeemedTicket(_eventId, _ticketId, vip);
        return vip;
    }

    /**
     * @dev Function to redeem VIP exclusive.
     * @param _eventId - ID of event.
     * @param _vipId - ID of event.
     * @return bool exclusive - Boolean representing status of VIP exclusive redemption.
     */
    function redeemVIPExclusive(uint256 _eventId, uint256 _vipId)
        public
        eventExist(_eventId)
        eventVIPExists(_eventId, _vipId)
        returns (bool)
    {
        bool exclusive = eventVIPSettings[_eventId][_vipId].exclusive;
        eventVIPSettings[_eventId][_vipId].exclusive = false;
        return exclusive;
    }
}
