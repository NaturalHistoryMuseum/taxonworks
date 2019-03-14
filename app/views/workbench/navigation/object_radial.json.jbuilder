resource = @klass.tableize

json.type @klass

if @object
  json.id @object.id
  json.object_label object_tag(@object) 

  json.resource_path "/#{resource}/#{@object.id}" 
  json.global_id @object.to_global_id.to_s
else
  json.resource_path resource
end

json.tasks do
  if @data
    @data['tasks'].each do |t|
      json.set! t do
        json.name UserTasks::INDEXED_TASKS[t].name
        if @object
          json.path send("#{t}_path", "#{resource.singularize}_id" => @object.id)
        else
          json.path send("#{t}_path")
        end
      end
    end
  end
end

if @data
  if @data['config']['recent']
    json.recent_url resource + '?recent=true'
  end

  json.config @data['config']  
end