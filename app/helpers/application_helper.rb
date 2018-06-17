# Collection of helper methods used throughout the application
module ApplicationHelper
  def flash_class_name(class_name)
    case class_name
    when 'notice' then 'success'
    when 'alert'  then 'danger'
    else
      ''
    end
  end

  def odds_are_title(odds_are)
    return 'Odds Are in progress' if odds_are.finalized_at.nil?
    'Completed Odds Are'
  end
end
