class User < ApplicationRecord
  validates :username ,presence: true, length: { maximum: 64}, uniqueness: true

  # password was passed as md5. The length maybe less than 32.  so maximum set 64.
  validates :password, presence:true, length:{minimum: 6, maximum: 64}

#  validates :email , length:{minimum: 7, maximum: 64}
#  validates :phone_no, length: {minimum: 7, maximum: 13}
#  validates :description, length: {maximum: 256}

  validates :role_id,  presence:true #, format: {with: }
end
