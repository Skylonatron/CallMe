class Lead < ApplicationRecord
  require 'csv'
  validates :first_name, presence: true


  belongs_to :user

  enum called: { uncalled: 0, called: 1 }

  def full_name
    full_name = "#{first_name}"

    full_name += " #{last_name}" if last_name

    full_name
  end

  def full_address
    fa = ""

    fa += "#{address}, " if address
    fa += "#{city}, " if city
    fa += "#{state}" if state
    fa += " #{zip_code}"

    fa

  end

  def formatted_phone_number
    number = phone_number || phone_number_2

    if number&.length == 10
      "#{number[0..2]} #{number[3..5]} #{number[6..9]}"
    elsif number&.length == 11
      "#{number[0]} #{number[1..3]} #{number[4..6]} #{number[7..10]}"
    else
      number
    end

  end

  def self.import(csv)
    count = 0

    begin 
      CSV.foreach(csv.path, headers: false) do |row|

        lead = self.new
        lead.first_name = row[0]
        lead.last_name = row[1]
        lead.address = row[2]
        lead.city = row[4]
        lead.state = row[5]
        lead.zip_code = row[6]
        lead.phone_number = row[7]
        lead.phone_number_2 = row[8]
        lead.email = row[9]

        lead.save!
        count += 1

      end

    rescue => ex
      return { fail: "There was a problem reading the CSV, Error: #{ex}" }
    end

    return { success: "Sucessfully imported #{count} leads" }

  end




end
