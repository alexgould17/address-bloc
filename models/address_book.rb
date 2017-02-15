require_relative 'entry'
require "csv"

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

  def import_from_csv(fname)
    csv_text = File.read(fname)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end
end
