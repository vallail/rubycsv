require 'csv'

class CSVFileReader
  class << self
    attr_accessor :data, :headers

    def inherited(subclass)
      file_name = "#{subclass.name.downcase}s.csv"
      csv_data = CSV.read(file_name, headers: true)
      subclass.headers = csv_data.headers
      define_accessor_methods(subclass, subclass.headers)
    end

    def define_accessor_methods(klass, headers)
      headers.each do |header|
        klass.class_eval do
          attr_accessor header.to_sym
        end
      end
    end
    def read_csv
      #@data is storing only the headers data or the first row of data to avoid 
      file_name = "#{name.downcase}s.csv"
      @data ||= CSV.read(file_name, headers: true, header_converters: :symbol).map(&:to_hash)
      # puts "Headers: #{@headers}"  # headers inspect
      # puts "First row of data: #{@data}"  #Data inspect
    end
    def find_by(attribute, value)
      read_csv if data.nil? || data.empty?
      data.map { |row| new(row) }.find { |record| record.send(attribute).to_s == value.to_s }
    end
  end
    def initialize(attributes = {})
    attributes.each do |name, value|
      # p name
      # p value
      send("#{name}=", value)
    end
  end
end

