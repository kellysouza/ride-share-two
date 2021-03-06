module RideShare

  class Trip
    attr_reader :trip_id, :driver_id, :rider_id, :date, :rating

    def initialize(args)
      @trip_id = args[:trip_id]
      @driver_id = args[:driver_id]
      @rider_id = args[:rider_id]
      @date = args[:date]
      @rating = error_checked_rating(args[:rating])

    end

    def self.all
      trips_array = []
      CSV.read("support/trips.csv", {:headers => true}).each do |trip|
        begin
          args = {
            :trip_id => trip[0],
            :driver_id => trip[1],
            :rider_id => trip[2],
            :date => trip[3],
            :rating => trip[4]
          }
          trips_array << Trip.new(args)
        rescue InvalidRatingError
          #this will only apply if csv has errors
          puts "#Trip # #{trip[0]} has an invalid rating"
          args = {
            :trip_id => trip[0],
            :driver_id => trip[1],
            :rider_id => trip[2],
            :date => trip[3],
            :rating => nil
          }
          trips_array << Trip.new(args)
        end
      end
      trips_array
    end

    def self.find(id)
      trip_array = self.all
      trip_array.find { |trip| id == trip.trip_id }
    end

    def self.find_by_rider(rider_id)
      trip_array = self.all
      trip_array.find_all { |trip| rider_id == trip.rider_id }
    end

    def self.find_by_driver(driver_id)
      trip_array = self.all
      trip_array.find_all { |trip| driver_id == trip.driver_id }
    end

    #instance method retrieve the associated driver instance through the driver ID
    def find_driver
      id = driver_id.to_s
        RideShare::Driver.find(id)
    end

    def find_rider
      id = rider_id.to_s
        RideShare::Rider.find(id)
      #instance method retrieve the associated rider instance through the rider ID
    end

    private
    
    def error_checked_rating(rating)
      if rating == nil || (1..5).include?(rating.to_i)
        return rating
      else
        raise InvalidRatingError.new("Rating must be 1-5")
      end
    end
  end
end
