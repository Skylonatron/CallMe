class Lead < ApplicationRecord
  require 'csv'

  belongs_to :user
  
  enum called: { uncalled: 0, called: 1 }

  def self.import(csv)

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

    end

  end




end
