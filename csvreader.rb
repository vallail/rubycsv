require 'csv'

class CSVFileReader
  def self.inherited(subclass)
    subclass.instance_eval do
      @data = nil
      @headers = nil

      def read_csv
        file_name = "#{self.name.downcase}s.csv"
        @data ||= CSV.read(file_name, headers: true, header_converters: :symbol).map(&:to_hash)
        @headers ||= @data.first.keys
        define_accessor_methods(@headers)
      end

      def define_accessor_methods(headers)
        headers.each do |header|
          attr_accessor header
        end
      end

      def find_by(attribute, value)
        read_csv if @data.nil? || @data.empty?
        record = @data.find { |row| row[attribute.to_sym].to_s == value.to_s }
        record ? new(record) : nil
      end

      read_csv
    end
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
