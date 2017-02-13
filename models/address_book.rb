require_relative 'entry'

class AddressBook
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_entry(name, phone_number, email)
    index = 0
    entries.each do |entry|
      break if name < entry.name
      index += 1
    end
    entries.insert(index, Entry.new(name, phone_number, email))
  end

  def remove_entry(name, phone_number, email)
    index = -1
    entries.length.times do |i|
      if name == entries[i].name && phone_number == entries[i].phone_number && email == entries[i].email
        index = i
        break
      end
    end
    entries.delete_at(index) if index != -1
  end
end
