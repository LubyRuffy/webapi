class Diskcheck < ApplicationRecord
  validates :db_limit,      presence: true ,numericality:{only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5  }
  validates :report_limit,  presence: true ,numericality:{only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10  }
end
