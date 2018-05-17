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
end
