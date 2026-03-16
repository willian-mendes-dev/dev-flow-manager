class User < ApplicationRecord
  has_secure_password

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :password,
            length: { minimum: 8 },
            format: {
              with: /\A(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).+\z/,
              message: "deve ter no mínimo 8 caracteres, com 1 letra maiúscula, 1 número e 1 caractere especial"
            },
            allow_nil: true

  private

  def normalize_name
    self.name = name.to_s.strip
  end
end
