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
                end
              end        
            end
            unless !defined?(rv) || rv.blank?
              locals_hash[name.to_s] = j.decode(rv)
            end  
          end
        end
      end
    end
    return locals_hash.to_json
  end

private
  
  def ignorables
    [
      "@view_renderer",
      "@view_flow",
      "@output_buffer",
      "@virtual_path"
    ]
  end

  def build name, var, path=nil
    path = name unless !!path
    render(path.to_s+'.json',  name.to_sym => var)
  end
end