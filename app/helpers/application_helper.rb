module ApplicationHelper

  def flash_helper(instance_variable = nil)

    fl = ''

    if instance_variable && instance_variable.errors.any?
      fl += "<div class='error'>"
      fl += "<h2>#{pluralize(instance_variable.errors.count, "error")} prohibited this form from being submitted:</h2>"
      fl += "<ul>"
      instance_variable.errors.full_messages.each do |error|
        fl += "<li>#{error}</li>"
      end
      fl += "</ul></div>"
    else
      f_names = [:error, :notice, :warning, :message]

      for name in f_names
        unless flash[name].nil? || flash[name].empty?
          fl += "<div class='#{name}'>"

          # if it is an array, print each element
          last_message_ul = false #initialize ul check
          flash[name].each do |message|

            #check to see if last one included li, but current one doesn't, then close ul
            unless message.include? "<li>"
              if last_message_ul
                fl += "</ul>"
                last_message_ul = false
              end
            else
              unless last_message_ul
                fl += "<ul>"
                last_message_ul = true
              end
            end
            fl += "#{message}"
          end

          fl += "</div>"
        end
        flash[name] = nil
      end
    end

    fl = "<div class =\"custom_helper_flash\">" + fl + "</div>" unless fl.empty?

    fl.html_safe

    #rescue
    #  ""
  end


end
