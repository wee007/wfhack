class NullCentre < NullObject
  CENTRE_NAMES = {
    broadmarsh: "Broadmarsh", castlecourt: "CastleCourt", merryhill: "Merry Hill",
    metreon: "Metreon", millgate: "Mill Gate Shopping Centre", royalvictoriaplace: "Royal Victoria Place",
    brunelcentre: "The Brunel ", thefriary: "The Friary", thevillagelondon: "The Village London",
    louisjoliet: "Westfield  Louis Joliet", parkway: "Westfield  Parkway", solano: "Westfield  Solano",
    newmarket: "Westfield 277 Newmarket", airportwest: "Westfield Airport West", albany: "Westfield Albany",
    annapolis: "Westfield Annapolis", arndale: "Westfield Arndale", belconnen: "Westfield Belconnen",
    beldenvillage: "Westfield Belden Village", bondijunction: "Westfield Bondi Junction", brandon: "Westfield Brandon",
    broward: "Westfield Broward", burwood: "Westfield Burwood", capital: "Westfield Capital",
    carindale: "Westfield Carindale", carousel: "Westfield Carousel", centrepoint: "Westfield Centrepoint",
    centurycity: "Westfield Century City", chartwell: "Westfield Chartwell", chatswood: "Westfield Chatswood",
    chermside: "Westfield Chermside", chesterfield: "Westfield Chesterfield", chicagoridge: "Westfield Chicago Ridge",
    citruspark: "Westfield Citrus Park", connecticutpost: "Westfield Connecticut Post", countryside: "Westfield Countryside",
    crestwood: "Westfield Crestwood", culvercity: "Westfield Culver City", derby: "Westfield Derby",
    doncaster: "Westfield Doncaster", downtown: "Westfield Downtown", downtownplaza: "Westfield Downtown Plaza",
    eaglecentre: "Westfield Eagle Centre", eaglerock: "Westfield Eagle Rock", eastgardens: "Westfield Eastgardens",
    eastridge: "Westfield Eastridge", enfield: "Westfield Enfield", fashionsquare: "Westfield Fashion Square",
    figtree: "Westfield Figtree", fountaingate: "Westfield Fountain Gate", foxhills: "Westfield Fox Hills",
    foxvalley: "Westfield Fox Valley", franklinpark: "Westfield Franklin Park", galleria: "Westfield Galleria",
    galleriaatroseville: "Westfield Galleria at Roseville", gardencity: "Westfield Garden City", gardenstateplaza: "Westfield Garden State Plaza",
    gateway: "Westfield Gateway", geelong: "Westfield Geelong", glenfield: "Westfield Glenfield",
    greatnorthern: "Westfield Great Northern", hawthorn: "Westfield Hawthorn", helensvale: "Westfield Helensvale",
    hornsby: "Westfield Hornsby", hortonplaza: "Westfield Horton Plaza", hurstville: "Westfield Hurstville",
    independence: "Westfield Independence", innaloo: "Westfield Innaloo", kotara: "Westfield Kotara",
    liverpool: "Westfield Liverpool", london: "Westfield London", mainplace: "Westfield MainPlace",
    manukau: "Westfield Manukau City", marion: "Westfield Marion", meriden: "Westfield Meriden",
    midrivers: "Westfield Mid Rivers", midway: "Westfield Midway", miranda: "Westfield Miranda",
    missionvalley: "Westfield Mission Valley", missionvalleywest: "Westfield Mission Valley West", montgomery: "Westfield Montgomery",
    mtdruitt: "Westfield Mt Druitt", northbridge: "Westfield North Bridge", northcounty: "Westfield North County",
    northlakes: "Westfield North Lakes", northrocks: "Westfield North Rocks", northwest: "Westfield Northwest",
    oakridge: "Westfield Oakridge", oldorchard: "Westfield Old Orchard", pakuranga: "Westfield Pakuranga",
    palmdesert: "Westfield Palm Desert", parramatta: "Westfield Parramatta", penrith: "Westfield Penrith",
    plazabonita: "Westfield Plaza Bonita", plazacaminoreal: "Westfield Plaza Camino Real", plentyvalley: "Westfield Plenty Valley",
    promenade: "Westfield Promenade", queensgate: "Westfield Queensgate", riccarton: "Westfield Riccarton",
    richland: "Westfield Richland", sanfrancisco: "Westfield San Francisco Centre", santaanita: "Westfield Santa Anita",
    sarasota: "Westfield Sarasota Square", shorecity: "Westfield Shore City", southcounty: "Westfield South County",
    southshore: "Westfield South Shore", southpark: "Westfield SouthPark", southcenter: "Westfield Southcenter",
    southgate: "Westfield Southgate", southlake: "Westfield Southlake", southland: "Westfield Southland",
    stlukes: "Westfield St Lukes", strathpine: "Westfield Strathpine", sunrise: "Westfield Sunrise",
    sydney: "Westfield Sydney", teatreeplaza: "Westfield Tea Tree Plaza", toombul: "Westfield Toombul",
    topanga: "Westfield Topanga", trumbull: "Westfield Trumbull", tuggerah: "Westfield Tuggerah",
    utc: "Westfield UTC", valencia: "Westfield Valencia Town Center", valleyfair: "Westfield Valley Fair",
    vancouver: "Westfield Vancouver", warrawong: "Westfield Warrawong", westcounty: "Westfield West County",
    westcovina: "Westfield West Covina", westlakes: "Westfield West Lakes", westpark: "Westfield West Park",
    westcity: "Westfield WestCity", westland: "Westfield Westland", wheaton: "Westfield Wheaton",
    whitfordcity: "Westfield Whitford City", woden: "Westfield Woden", foo: 'FOO'
  }

  def name
    centre_id.nil? ? "Centre" : (CENTRE_NAMES[centre_id.to_sym] || "")
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
    name.sub(/Westfield /, '')
  end
end
