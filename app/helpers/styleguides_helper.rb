module StyleguidesHelper
  @@named_examples = {}
  @@script = ''

  def styleguide_block(section, &block)
    raise ArgumentError, "Missing block" unless block_given?

    @section = styleguide.section(section)

    if !@section.raw
      raise "KSS styleguide section is nil, is section '#{section}' defined in your css?"
    end

    @content = capture(&block).strip

    render 'styleguides/styleguide_block', section: @section, example_html: @content, named_examples: @@named_examples, script: @@script
  end

  def example(name, &block)
    @@named_examples[name] = capture(&block).strip
  end

  def script(&block)
    script = capture(&block).strip

    @@script = script
    content_for :javascript do
      content_tag :script do
        script.html_safe
      end
    end
  end
end
