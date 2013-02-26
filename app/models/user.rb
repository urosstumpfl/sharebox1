class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me

  validates :email, :presence => true, :uniqueness => true

  has_many :assets



  attr_accessible :user_id, :uploaded_file


  belongs_to :user

#set up "uploaded_file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file

  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  validates_attachment_presence :uploaded_file

  has_many :folders
end