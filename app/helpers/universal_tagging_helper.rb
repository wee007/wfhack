module UniversalTaggingHelper

  def universal_tagging
    <<-EOF
      <script type="text/javascript">
      var utag_data = westfield.meta;
      (function(a,b,c,d)
      { a='//tags.tiqcdn.com/utag/westfield/#{universal_tagging_profile}/#{universal_tagging_env}/utag.js'; b=document;c='script';d=b.createElement(c);d.src=a;d.type='text/java'+c;d.async=true; a=b.getElementsByTagName(c)[0];a.parentNode.insertBefore(d,a); }
      )();
      </script>
    EOF
  end

  def universal_tagging_env
    if Rails.env.production?
      'prod'
    elsif Rails.env.development?
      'dev'
    else
      'qa'
    end
  end

  def universal_tagging_profile
    'wfieldau'
  end

end