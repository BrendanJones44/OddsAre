(function() {
  var Notifications, start_notifictations,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Notifications = (function() {
    console.log("inside notifications coffee script");

    function Notifications() {
      this.handleSuccess = bind(this.handleSuccess, this);
      this.handleClick = bind(this.handleClick, this);
      console.log("inside notifications coffee script");
      this.notifications = $("[data-behavior='notifications']");
      $("[data-behavior='unread-count']").text(this.notifications.length);
      this.setup();
    }

    Notifications.prototype.setup = function() {
      console.log("inside notifications coffee script");
      $("[data-behavior='notifications-link']").on("click", this.handleClick);
      return $.ajax({
        url: "/notifications.json",
        dataType: "JSON",
        method: "GET",
        success: this.handleSuccess
      });
    };

    Notifications.prototype.handleClick = function(e) {
      console.log("inside notifications coffee script");
      return $.ajax({
        url: "/notifications/mark_as_read",
        dataType: "JSON",
        method: "POST"
      });
    };

    Notifications.prototype.handleSuccess = function(data) {
      var item, items;
      console.log("inside notifications coffee script");
      if (data.length > 0) {
        items = $.map(data, function(notification) {
          return "<a class='dropdown-item' href='" + notification.url + "'>" + notification.actor.first_name + " " + notification.actor.last_name + " (@" + notification.actor.user_name + ") " + notification.action + "</a>";
        });
        $("[data-behavior='notification-items']").html(items);
        return $("[data-behavior='unread-count']").text(items.length);
      } else {
        item = "<a class='dropdown-item' href=''#'>No New Notifications</a>";
        return $("[data-behavior='notification-items']").html(item);
      }
    };

    return Notifications;

  })();

  start_notifictations = function() {
    return new Notifications;
  };

  console.log("inside coffee file");

  $(document).ready(start_notifictations);

  $(document).on('page:load', start_notifictations);

  document.addEventListener('turbolinks:request-start', start_notifictations);

  document.addEventListener('turbolinks:load', start_notifictations);

}).call(this);
