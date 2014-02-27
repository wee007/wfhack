module StyleguideHelper
  @@named_examples = {}
  @@script = ''

  def styleguide_block(section, &block)
    raise ArgumentError, "Missing code example" unless block_given?

    @section = styleguide.section(section)

    if !@section.raw
      raise "KSS styleguide section is nil, is section '#{section}' defined in your css?"
    end

    @content = capture(&block).strip

    render 'styleguide/styleguide_block',
      section: @section,
      example_html: @content,
      named_examples: @@named_examples,
      script: @@script
  end

  def styleguide_block_static(title, description = nil, &block)
    raise ArgumentError, "Missing code example" unless block_given?
    content = capture(&block).strip

    render 'styleguide/styleguide_block_static',
      title: title,
      description: description,
      example_html: content
  end

  def styleguide_intro(title = nil, description = nil)

    if params[:id]
      styleguide = Styleguide::TREE.find do |styleguide|
        ActiveSupport::Inflector.parameterize(styleguide['title']) == params[:id]
      end
      title ||= styleguide['title']
      description ||= styleguide['description']
    end

    render 'styleguide/styleguide_intro',
      title: title,
      description: description if title && description

  end

  def example(name, &block)
    @@named_examples[name] = capture(&block).strip
  end

  def script(&block)
    script = capture(&block).strip

    @@script = script
    content_for :custom_javascript do
      content_tag :script do
        script.html_safe
      end
    end
  end
end
