module Rubyipmi::Freeipmi

  class Lan

    attr_accessor :info
    attr_accessor :channel
    attr_accessor :config

    def initialize(opts)
      @config = Rubyipmi::Freeipmi::BmcConfig.new(opts)
      @info = {}
      if @options.has_key?("hostname")
        @channel = 2
      else
        @channel = 1
      end
    end

    # get the entire lan settings
    def info
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      else
        @info
      end
    end

    # is the ip source dhcp?
    def dhcp?
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      end
      @info["ip_address_source"].match(/dhcp/i) != nil
    end

    # is the ip source static
    def static?
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      end
      @info["ip_address_source"].match(/static/i) != nil
    end

    # get the ip of the bmc device
    def ip
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      end
      @info["ip_address"]
    end

    # get the mac of the bmc device
    def mac
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      end
      @info["mac_address"]
    end

    # get the netmask of the bmc device
    def netmask
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      end
      @info["subnet_mask"]
    end

    # get the gateway of the bmc device
    def gateway
      if @info.length < 1
        parse(@config.section("Lan_Conf"))
      end
      @info["default_gateway_ip_address"]
    end

    # get the tcp settings info
    def tcpinfo
      {:ip => ip, :netmask =>netmask, :gateway => gateway}
    end

    # set the tcp settings
    def tcpinfo=(args)
      ip      = args[:ip]
      netmask = args[:netmask]
      gateway = args[:gateway]

    end

  #  def snmp
  #
  #  end

  #  def vlanid
  #
  #  end

  #  def snmp=(community)
  #
  #  end

    def ip=(address)
      @config.setsection("Lan_Conf", "IP_Address", address)
    end

    def netmask=(netmask)
      @config.setsection("Lan_Conf", "Subnet_Mask", netmask)
    end

    def gateway=(address)
      @config.setsection("Lan_Conf", "Default_Gateway_IP_Address", address)
    end

  #  def vlanid=(vlan)
  #
  #  end

    def parse(landata)
      landata.lines.each do |line|
        # clean up the data from spaces
        next if line.match(/#+/)
        next if line.match(/Section/i)
        line.gsub!(/\t/, '')
        item = line.split(/\s+/)
        key = item.first.strip.downcase
        value = item.last.strip
        @info[key] = value

      end
      return @info
    end
  end
end


