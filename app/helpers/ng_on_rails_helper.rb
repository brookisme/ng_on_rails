module NgOnRailsHelper
  def locals_to_json ng_data
    j = ActiveSupport::JSON
    locals_hash = {}
    instance_variable_names.each do |var_name|
      unless !!var_name.match(/^@_/)
        unless ignorables.include? var_name
          name = var_name.gsub("@","")
          instance_var = instance_variable_get(var_name)
          unless instance_var.blank?
            if ng_data.blank?
              rv = instance_var
            else
              unless ng_data[name] == "IGNORE"                
                if instance_var.is_a?(ActiveRecord::Base) || instance_var.is_a?(ActiveRecord::Relation)
                  if !ng_data[name]
                    if !!ng_data["BUILD"]
                      rv = build(name,instance_var)
                    else
                      rv = instance_var
                    end
                  elsif ng_data[name]=="BUILD"
                    rv = build(name,instance_var)
                  elsif ng_data[name].class==Hash
                    path = ng_data[name][:path]
                    model_name = ng_data[name][:as] || name
                    rv = build(model_name,instance_var,path)
                  else
                    rv = instance_var
                  end
                else
                  rv = instance_var
                end
              end
            end
            unless !defined?(rv) || rv.blank?
              if (rv.is_a?(String) && !is_json?(rv)) || rv.is_a?(Numeric)
                locals_hash[name] = rv
              elsif is_json?(rv)
                locals_hash[name] = j.decode(rv)
              else
                locals_hash[name] = j.decode(rv.to_json)
              end
            end  
          end
        end
      end
    end
    return escape_javascript(locals_hash.to_json)
  end

private
  
  def ignorables
    [
      "@view_renderer",
      "@view_flow",
      "@output_buffer",
      "@virtual_path",
      "@fixture_connections",
      "@example", 
      "@fixture_cache", 
      "@loaded_fixtures", 
      "@controller", 
      "@request", 
      "@output_buffer", 
      "@rendered",
      "@marked_for_same_origin_verification"
    ]
  end

  def is_json? string
    begin
      !!JSON.parse(string)
    rescue
      false
    end
  end

  def build name, var, path=nil
    path = name unless !!path
    render(path.to_s+'.json',  name.to_sym => var)
  end
end