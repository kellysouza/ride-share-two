
module RideShare

  class Driver
    attr_reader :id, :name, :vin

    def initialize(id, name, vin)
      @id = id
      @name = name
      @vin = vin
    end


    def self.all
      drivers_array = []
      CSV.read("support/drivers.csv").each do |driver|
        drivers_array << (Driver.new(driver[0], driver[1], driver[2]))
      end
      drivers_array
    end


  end
end