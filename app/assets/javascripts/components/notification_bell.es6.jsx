class NotificationBell extends React.Component {
  render () {
    return(
    <div>
      <i class="fa fa-bell" aria-hidden="true"></i>
      <li class="nav-item btn-group" data-behavior="notifications">
        <a class="dropdown-toggle nav-link" data-behavior="notifications-link" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true">
          <i class="fa fa-bell" aria-hidden="true"></i> <span data-behavior="unread-count"></span>
        </a>
        <div class="dropdown-menu" aria-labelledby="dropdownMenu1" data-behavior="notification-items">
        </div>
      </li>
    </div>
    );
  }
}
