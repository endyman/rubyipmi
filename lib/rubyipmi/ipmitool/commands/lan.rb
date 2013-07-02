module Rubyipmi::Ipmitool

  class Lan < Rubyipmi::Ipmitool::BaseCommand

    attr_accessor :info
    attr_accessor :channel

    def initialize(opts = ObservableHash.new)
      super("ipmitool", opts)
      @info = {}
      if @options.has_key?("H")
        @channel = 2
      else
        @channel = 1
      end

    end

    def info
      if @info.length < 1
        parse(print)
      else
        @info
      end
    end

    def print
      @options["cmdargs"] = "lan print"
      value = runcmd
      @options.delete_notify("cmdargs")
      if value
        @result
      end
    end

  #  def snmp
  #    if @info.length < 1
  #      parse(print)
  #    end
  #    # Some systems do not report the snmp string
  #    @info["snmp community string"]
  #  end

    def ip
      if @info.length < 1
        parse(print)
      end
      @info["ip address"]
    end

    def mac
      if @info.length < 1
        parse(print)
      end
      @info["mac address"]
    end

    def netmask
      if @info.length < 1
        parse(print)
      end
      @info["subnet mask"]
    end

    def gateway
      if @info.length < 1
        parse(print)
      end
      @info["default gateway ip"]
    end

  #  def vlanid
  #    if @info.length < 1
  #      parse(print)
  #    end
  #    @info["802.1q vlan id"]
  #  end

  #  def snmp=(community)
  #    @options["cmdargs"] = "lan set #{channel} snmp #{community}"
  #    value = runcmd
  #    @options.delete_notify("cmdargs")
  #    return value
  #  end

    def enable

    end

    def disable

    end

    def tcpinfo
      {:ip => ip, :netmask =>netmask, :gateway => gateway}
    end

    def tcpinfo=(args)
      ip      = args[:ip]
      netmask = args[:netmask]
      gateway = args[:gateway]
    end

    def ip=(address)
      @options["cmdargs"] = "lan set #{channel} ipaddr #{address}"
      value = runcmd
      @options.delete_notify("cmdargs")
      return value
    end

    def netmask=(mask)
      @options["cmdargs"] = "lan set #{channel} netmask #{mask}"
      value = runcmd
      @options.delete_notify("cmdargs")
      return value
    end

    def gateway=(address)
      @options["cmdargs"] = "lan set #{channel} defgw #{address}"
      value = runcmd
      @options.delete_notify("cmdargs")
      return value
    end

    def dhcp?
      if @info.length < 1
        parse(print)
      end
      @info["ip address source"].match(/dhcp/i) != nil
    end

    def static?
      if @info.length < 1
        parse(print)
      end
      @info["ip address source"].match(/static/i) != nil
    end

  #  def vlanid=(vlan)
  #    @options["cmdargs"] = "lan set #{channel} vlan id #{vlan}"
  #    value = runcmd
  #    @options.delete_notify("cmdargs")
  #    return value
  #  end


    def parse(landata)
      multikey = ""
      multivalue = {}

      landata.lines.each do |line|
        # clean up the data from spaces
        item = line.split(':', 2)
        key = item.first.strip.downcase
        value = item.last.strip
        @info[key] = value

      end
      return @info
    end




  end
end

#Set in Progress         : Set Complete
#Auth Type Support       :
#Auth Type Enable        : Callback :
#                        : User     : NONE MD2 MD5 PASSWORD OEM
#                        : Operator : NONE MD2 MD5
#                        : Admin    : MD2 MD5
#                        : OEM      :
#IP Address Source       : DHCP Address
#IP Address              : 192.168.1.41
#Subnet Mask             : 255.255.255.0
#MAC Address             : 00:17:a4:49:ab:70
#BMC ARP Control         : ARP Responses Enabled, Gratuitous ARP Disabled
#Gratituous ARP Intrvl   : 0.0 seconds
#Default Gateway IP      : 192.168.1.1
#802.1q VLAN ID          : Disabled
#802.1q VLAN Priority    : 0
#Cipher Suite Priv Max   : Not Available