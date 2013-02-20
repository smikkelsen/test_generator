class ApplicationController < ActionController::Base
  protect_from_forgery

  def error_log(heading, print = nil)
    print_formatted_to_log(heading, print)
  end

  def inspect_obj(heading, obj)
    string = ""
    #if obj.is_a?(Object)
    #  obj.attributes.each { |k, v| hash[k] = v }
    #end
    if obj.is_a?(Array) || obj.is_a?(Hash)
      obj.each do |key, attr|
        string +="    * #{key} = #{attr}\n"
      end
      print_formatted_to_log(heading, string)
    else
      print_formatted_to_log(heading, obj.inspect)
    end

  end

  #def set_error(error, tag = 'li')
  #  set_flash(:error, error, tag)
  #end
  #
  #def set_notice(notice, tag = 'li')
  #  set_flash(:notice, notice, tag)
  #end
  #
  #def set_warning(warning, tag = 'li')
  #  set_flash(:warning, warning, tag)
  #end
  #
  #def set_message(message, tag = 'li')
  #  set_flash(:message, message, tag)
  #end
  #
  #def empty_error()
  #  flash[:error] = nil
  #end
  #
  #def empty_notice()
  #  flash[:notice] = nil
  #end
  #
  #def empty_warning()
  #  flash[:warning] = nil
  #end
  #
  #def empty_message()
  #  flash[:message] = nil
  #end
  #
  #def empty_all_flash()
  #  empty_error
  #  empty_message
  #  empty_notice
  #  empty_warning
  #end


  protected
  # ---------------------------------------------------------------------------------
  #                             Protected Methods
  #     set_flash   = used by flash helper methods. Sets text to session
  # ---------------------------------------------------------------------------------

  #def set_flash(type, message, tag)
  #  tag_1, tag_2 = set_tag(tag)
  #  if flash[type].nil?
  #    flash[type] = ["#{tag_1}#{message}#{tag_2}"]
  #  else
  #    flash[type] << "#{tag_1}#{message}#{tag_2}"
  #  end
  #end
  #
  #def set_tag(tag)
  #
  #  case tag
  #
  #    when 'br'
  #      tag_1 = ''
  #      tag_2 = '<br />'
  #    else
  #      tag_1 = "<#{tag}>"
  #      tag_2 = "</#{tag}>"
  #
  #  end
  #  return tag_1, tag_2
  #end

  def print_formatted_to_log(heading = nil, print = nil)
    # set vars
    border_width = 80
    h_border_padding = 6
    b_char = "="
    hb_char = "-"

    # Init vars
    heading_len = heading.length
    border = ""
    h_border = ""

    unless heading_len > border_width
      heading_pad = (border_width - heading_len) / 2

      heading_pad.times do
        heading = " " + heading
      end

      if (heading_len - (h_border_padding * 2)) >= border_width
        padding = border_width - (heading_len - (h_border_padding * 2))
      else
        padding = h_border_padding
      end
      padding.times do
        h_border = " " + h_border
      end
      (border_width - padding * 2).times do
        h_border = h_border + hb_char
      end
    end

    border_width.times do
      border = b_char + border
    end

    Rails.logger.debug(border)
    if print.nil?
      Rails.logger.debug()
      Rails.logger.debug(heading)
    else
      Rails.logger.debug(heading)
      Rails.logger.debug(h_border)
      Rails.logger.debug()
      Rails.logger.debug(print)
    end
    Rails.logger.debug()
    Rails.logger.debug(border)
  end
end
