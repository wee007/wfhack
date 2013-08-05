class NullCentre < NullObject
  CENTRE_NAMES = {bondijunction: "Bondi Junction"}
  def name
    "Westfield #{short_name || ""}"
  end
  def centre_id
    # e.g."http://wwwau.systest.dbg.westfield.com/burwood/products?colour=Reds" should give 'burwood'
    code || url.to_s.match(/\/centres\/([a-z]+)/).captures.first rescue nil
  end
  def to_param
    centre_id
  end
  def id
    centre_id
  end
  def short_name
    centre_id.nil? ? "Centre" : CENTRE_NAMES[centre_id.to_sym]
  end
end
