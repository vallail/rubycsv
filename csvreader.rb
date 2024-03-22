require 'csv'

class CSVFileReader
  @headers = []
  @data = []

  def self.inherited(subclass)
    file_name = subclass.name.downcase + 's.csv' # Converts the class name to the corresponding file name
    csv_data = CSV.read(file_name, headers: true)
    @headers = csv_data.headers
    define_accessor_methods(subclass, @headers)
  end

  def self.define_accessor_methods(klass, headers)
    headers.each do |header|
      klass.instance_eval do
        attr_accessor header.to_sym
      end
    end
  end

  def self.read_csv
    file_name = name.downcase + 's.csv'
    @data = CSV.read(file_name, headers: true, header_converters: :symbol).map(&:to_hash)
  end

  def self.find_by(attribute, value)
    read_csv if @data.nil? || @data.empty?
    @data.map { |row| new(row) }.find { |record| record.send(attribute).to_s == value.to_s }
  end

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end

# # Usage example for Student
# class Student < CSVFileReader
# end

# s = Student.new
# s.student_id = 10
# s.student_name = "Amit"
# s.teacher_name = "Shilesh"
# s.subject = "Physics"

# s1 = Student.find_by(:student_id, "3")
# puts s1.student_name  # Output should be "kiran"
# puts s1.teacher_name  # Output should be "manoj"

# # Usage example for State
# class State < CSVFileReader
# end

# st = State.new
# st.name = "Bihar"
# st.capital = "Patna"
# st.population = "22Crore"

# st1 = State.find_by(:name, "Karnataka")
# puts st1.capital     # Output should be "bangalore"
# puts st1.population  # Output should be "6crore"
