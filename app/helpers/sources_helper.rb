module SourcesHelper

  def source_tag(source)
    return nil if source.nil?
    source.cached ? source.cached : (source.new_record? ? nil : 'ERROR - Source cache not set, please notify admin.')
  end

  def sources_search_form
    render('/sources/quick_search_form')
  end

  def source_link(source)
    return nil if source.nil?
    link_to(source_tag(source).html_safe, source.metamorphosize )
  end

  def source_attributes_for(source)
    w = content_tag(:em, 'ERROR, unkown class of Source, contact developers', class: :warning)  
    content_for :attributes do
      case source.class.name 
      when 'Source::Bibtex' 
        render '/sources/bibtex/attributes'
      when 'Source::Verbatim'
        render '/sources/verbatim/attributes'
      when 'Source::Source'
        w 
      else
        w
      end
    end
  end

  def source_related_attributes(source)
    content_for :related_attributes do
       if source.class.name == 'Source::Bibtex'
          content_tag(:h3, 'Authors') do
            content_tag(:ul) do
              source.authors.collect{|a| content_tag(:li, a.last_name)} 
            end
          end
       else

       end
    end
  end

  def add_source_to_project_form(source)
    if !source_in_project?(source)
      form_for(ProjectSource.new(source_id: source.to_param, project_id: sessions_current_project_id) , remote: true) do |f|
        f.hidden_field(:source_id) +
          f.hidden_field(:project_id) +
          f.submit('Add to project') 
      end
    else
      button_to('Remove from project', project_source_path(project_source_for_source(source)), method: :delete, remote: true) 
    end
  end

  def project_source_for_source(source)
    ProjectSource.find_by(source_id: source.to_param, project_id: sessions_current_project_id)
  end

  def source_in_project?(source)
    ProjectSource.exists?(project_id: sessions_current_project_id, source_id: source.to_param)
  end

  def source_in_other_project?(source)
    source.project_sources.where.not(project_id: sessions_current_project_id).references(:projects_sources).any?
  end


  # TODO: write helper methods
  # context 'source format variations' do
  #   # a valid source ibtex should support the following output formats
  #   skip 'authority string - <author family name> year'
  #   skip 'short string - <author short name (as little of the author names needed to differentiate from other authors within current project)> <editor indicator> <year> <any containing reference - e.g. In Book> <Short publication name> <Series> <Volume> <Issue> <Pages>'
  #   skip 'long string - <full author names> <editor indicator> <year> <title> <containing reference> <Full publication name> <Series> <Volume> <Issue> <Pages>'
  #   skip 'no publication long string -<full author names> <editor indicator> <year> <title> <containing reference> <Series> <Volume> <Issue> <Pages>'
  # end

end
