require_relative "csvreader"

class Student < CSVFileReader
end

class State < CSVFileReader
end


st = State.new
st.name = "Bihar"
st.capital = "Patna"
st.population = "22Crore"

s = Student.new
s.student_id = 10
s.student_name = "Amit"
s.teacher_name = "Shilesh"
s.subject = "Physics"

s1 = Student.find_by("student_id", 3)
puts s1.student_name # this should print kiran
puts s1.teacher_name # this should print manoj

st1 = State.find_by("name", "Karnataka")
puts st1.capital # this should print bangalore
puts st1.population # this should print 6crore







































































































