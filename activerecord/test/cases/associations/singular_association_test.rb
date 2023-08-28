require "cases/helper"
require "models/author"
require "models/book"

class SingularAssociationTest < ActiveRecord::TestCase
  fixtures :authors, :books

  class AuthorWithOneBook < ActiveRecord::Base
    self.table_name = "authors"

    has_one :book, class_name: "BookWithValidation", foreign_key: :author_id, inverse_of: :author
  end

  class BookWithValidation < ActiveRecord::Base
    self.table_name = "books"
    belongs_to :author, class_name: "AuthorWithOneBook", foreign_key: :author_id, inverse_of: :book
    before_create :validate_name

    def validate_name
      if author.book.name == author.name
        errors.add(:author, "Please don't name your book after yourself")
      end
    end
  end



  def test_can_validate_new_record_association
    author = AuthorWithOneBook.create(name: "Jane Austen")
    book = author.create_book!

    assert book.valid?
  end
end
