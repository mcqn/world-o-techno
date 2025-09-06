# Code to watch the log output from a Meshtastic node and extract GPS info

require 'serialport'

class MeshtasticGPS
    attr_accessor :latitude, :longitude, :speed, :pdop, :satellites

    def MeshtasticGPS.create(port)
        MeshtasticGPS.new(port)
    end

    def initialize(port)
        @serial_port = port
        @serial_connection = nil
        @latitude = nil
        @longitude = nil
        @speed = nil
        @pdop = nil
        @satellites = nil
    end

    def start()
        @serial_connection = SerialPort.open(@serial_port, 115200)
        if @serial_connection
            puts "Connected"
            @serial_connection.read_timeout = 2
        else
            puts "ERROR: Failed to connect to GPS unit"
        end
    end

    def run()
        # Process any log lines to see if there's a connection
        loop do
            resp = @serial_connection.gets
            break if resp.nil?
            # otherwise we got a log line, see if we're interested in it
            gps_info = resp.match(/GPS.*lat=(-?\d+\.\d+).*lon=(-?\d+\.\d+).*pdop=(\d+\.\d+).*speed=(\d+\.\d+).*sats=(\d+)/)
            unless gps_info.nil?
                # We've found a fix
                @latitude = gps_info[1].to_f
                @longitude = gps_info[2].to_f
                @pdop = gps_info[3].to_f
                @speed = gps_info[4].to_f
                @satellites = Array.new(gps_info[5].to_i)
            end
        end
    end
end

