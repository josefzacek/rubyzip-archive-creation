require 'zip'

class Person < ActiveRecord::Base
  def self.download_zip(people)
    compressed_file = Zip::OutputStream.write_buffer(::StringIO.new('')) do |zos|
      people.each do |person|
        zos.put_next_entry "#{person.name}-#{person.id}.csv"
        zos.print "#{person.name}, #{person.age}, #{person.occupation}"
      end
    end
    compressed_file.rewind
    compressed_file
  end
end
