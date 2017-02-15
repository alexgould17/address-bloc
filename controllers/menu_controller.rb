require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.new
  end

  def main_menu
    puts "Main Menu - #{address_book.entries.count} entries"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - View Entry Number n"
    puts "6 - DELETE F***ING EVERYTHING"
    puts "7 - Exit"
    print "Enter your selection: "

    selection = gets.to_i
    case selection
      when 1
        system "clear"
        view_all_entries
        main_menu
      when 2
        system "clear"
        create_entry
        main_menu
      when 3
        system "clear"
        search_entries
        main_menu
      when 4
        system "clear"
        read_csv
        main_menu
      when 5
        system "clear"
        view_entry_n
        main_menu
      when 6
        system "clear"
        puts "Bomb... dropped!"
        address_book.entries.each { |e| delete_entry(e) }
        main_menu
      when 7
        puts "Good-bye!"
        exit(0)
      else
        system "clear"
        puts "Sorry, that is not a valid input"
        main_menu
    end
  end

  def view_all_entries
    address_book.entries.each do |entry|
      system "clear"
      puts entry.to_s
      entry_submenu(entry)
    end

    system "clear"
    puts "End of entries"
  end

  def create_entry
    system "clear"
    puts "New AddressBloc Entry"
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp

    address_book.add_entry(name, phone, email)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    print "Search by name: "
    name = gets.chomp
    match = address_book.binary_search(name)
    system "clear"
    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def read_csv
    print "Enter filename to import (include path & .csv): "
    fname = gets.chomp
    if fname.empty?
      system "clear"
      puts "No CSV file read."
      main_menu
    end
    begin
      entry_count = address_book.import_from_csv(fname).count
      system "clear"
      puts "#{entry_count} new entries added from #{fname}"
    rescue
      puts "#{fname} is not a valid CSV file. Please enter a valid filename"
      read_csv
    end
  end

  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted."
  end

  def edit_entry(entry)
    print "Updated name: "
    name = gets.chomp
    print "Updated phone #: "
    phone = gets.chomp
    print "Updated email: "
    email = gets.chomp
    entry.name = name unless name.empty?
    entry.phone_number = phone unless phone.empty?
    entry.email = email unless email.empty?
    system "clear"
    puts "Updated entry:\n" + entry.to_s
  end

  def view_entry_n
    print "Entry #: "
    entry = gets.to_i
    if entry < 1 || entry > address_book.entries.count
      system "clear"
      puts "That entry # is invalid!"
      view_entry_n
    end
    system "clear"
    puts "Entry ##{entry}: "
    puts address_book.entries[entry-1]
    puts "(Press any key to continue)"
    gets
    system "clear"
    main_menu
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection
      when "n"
      when "d"
        delete_entry(entry)
      when "e"
        edit_entry(entry)
        entry_submenu(entry)
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        entry_submenu(entry)
    end
  end

  def search_submenu(entry)
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"
    selection = gets.chomp
    case selection
      when "d"
        system "clear"
        delete_entry(entry)
        main_menu
      when "e"
        system "clear"
        edit_entry(entry)
        main_menu
      when "m"
        system "clear"
        main_menu
      else
        system "clear"
        puts "#{selection} is not a valid input"
        puts entry.to_s
        search_submenu(entry)
    end
  end
end
