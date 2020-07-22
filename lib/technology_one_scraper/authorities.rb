# frozen_string_literal: true

module TechnologyOneScraper
  AUTHORITIES = {
    parkes: {
      url: "https://my.parkes.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28",
      webguest: "PSC.P1.WEBGUEST"
    },
    wangaratta: {
      url: "https://eservices.wangaratta.vic.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28"
    },
    southern_downs: {
      url: "https://onlineservices.sdrc.qld.gov.au/eProperty",
      period: "L28"
    },
    campaspe: {
      url: "https://campaspe-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "SOC.WEBGUEST"
    },
    eurobodalla: {
      url: "https://eservices.esc.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28"
    },
    lockyer_valley: {
      url: "https://lvrc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "LV.WEBGUEST"
    },
    corangamite: {
      url: "https://eservices.corangamite.vic.gov.au/T1PRprod/WebApps/eProperty",
      period: "L28",
      webguest: "CSC.WEBGUEST"
    },
    stirling: {
      url: "https://onlineservices.stirling.wa.gov.au/eProperty",
      period: "L28"
    },
    qprc: {
      url: "https://services.qprc.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28",
      # Site has an incomplete certificate chain. See https://www.ssllabs.com/ssltest/analyze.html?d=services.qprc.nsw.gov.au&latest
      disable_ssl_certificate_check: true
    },
    mid_western: {
      url: "https://eservices.midwestern.nsw.gov.au/epropertyprod",
      period: "L28"
    },
    hume: {
      url: "https://ehume.hume.vic.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28",
      webguest: "P1.HCC.WEBGUEST",
      # Site has an incomplete certificate chain. See https://www.ssllabs.com/ssltest/analyze.html?d=ehume.hume.vic.gov.au&latest
      disable_ssl_certificate_check: true
    },
    blacktown: {
      url: "https://eservices.blacktown.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28",
      webguest: "BCC.P1.WEBGUEST"
    },
    cockburn: {
      url: "https://ecouncil.cockburn.wa.gov.au/eProperty",
      period: "TM"
    },
    fremantle: {
      url: "https://eservices.fremantle.wa.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28"
    },
    kuringgai: {
      url: "https://eservices.kmc.nsw.gov.au/T1ePropertyProd",
      period: "TM",
      webguest: "KC_WEBGUEST"
    },
    lithgow: {
      url: "https://eservices.lithgow.nsw.gov.au/ePropertyProd",
      period: "L14"
    },
    manningham: {
      url: "https://eproclaim.manningham.vic.gov.au/eProperty",
      period: "L28"
    },
    noosa: {
      url: "https://noo-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "TM"
    },
    port_adelaide: {
      url: "https://ecouncil.portenf.sa.gov.au/T1PRWebPROD/eProperty",
      period: "L7",
      webguest: "PAE.P1.WEBGUEST"
    },
    ryde: {
      url: "https://eservices.ryde.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "TM",
      webguest: "COR.P1.WEBGUEST"
    },
    sutherland: {
      url: "https://propertydevelopment.ssc.nsw.gov.au/T1PRPROD/WebApps/eproperty",
      period: "TM",
      webguest: "SSC.P1.WEBGUEST",
      # ssslabs shows an incomplete certificate. Ugh.
      disable_ssl_certificate_check: true
    },
    tamworth: {
      url: "https://eproperty.tamworth.nsw.gov.au/ePropertyProd",
      period: "L28",
      # Tamworth is blocking requests from outside Australia. You can verify this
      # yourself by scraping via a VPN and switch between different countries.
      # morph.io is hosted in the US. So, to get around this we send our
      # traffic to an australian proxy
      australian_proxy: true
    },
    wagga: {
      url: "https://eservices.wagga.nsw.gov.au/T1PRWeb/eProperty",
      period: "L14",
      webguest: "WW.P1.WEBGUEST"
    },
    wyndham: {
      url: "https://eproperty.wyndham.vic.gov.au/ePropertyPROD",
      period: "L28"
    },
    charles_sturt: {
      url: "https://eproperty.charlessturt.sa.gov.au/eProperty",
      period: "L28"
    },
    holdfast_bay: {
      url: "https://chb-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    mitcham: {
      url: "https://eproperty.mitchamcouncil.sa.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28"
    },
    goulburn: {
      url: "https://eservices.goulburn.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "TW",
      disable_ssl_certificate_check: true,
      # Goulburn is blocking requests from outside Australia. You can verify this
      # yourself by scraping via a VPN and switch between different countries.
      # morph.io is hosted in the US. So, to get around this we send our
      # traffic to an australian proxy
      australian_proxy: true
    },
    shellharbour: {
      url: "https://shbr-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "SCC.WEBGUEST"
    },
    mornington_peninsula: {
      url: "https://epeninsula.mornpen.vic.gov.au/P1PRPROD",
      period: "L28",
      # It looks like part of their certificate has expired (but I can't check
      # using ssllabs because they're blocking US traffic. Sigh.)
      disable_ssl_certificate_check: true,
      # Mornington peninsula is blocking requests from outside Australia
      australian_proxy: true
    }
  }.freeze
end
