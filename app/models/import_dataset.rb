# A ImportDataset is uploaded file data to be imported into a project. This class shall not be instantiated, specific subclasses for each kind of dataset must be used instead.
#
# @!attribute source_file_name
#   @return [String]
#   the name of the file as uploaded by the user.
#
# @!attribute source_content_type
#   @return [String]
#    the content type (mime)
#
# @!attribute source_file_size
#   @return [Integer]
#     size of the document in K
#
# @!attribute source_updated_at
#   @return [Timestamp]
#     last time this document was updated
#
# @!attribute status
#   @return [String]
#    current import status (e.g. Pending, Completed, Closed)
#
# @!attribute description
#   @return [String]
#    user-supplied description of the dataset
#
# @!attribute metadata
#   @return [Hash]
#      data about the dataset. No particular structure is enforced, any subclass may store metadata (typically to aid the import process).
#
class ImportDataset < ApplicationRecord
  include Housekeeping
  include Shared::IsData

  attribute :status, :string, default: "Pending"

  has_many :dataset_records

  has_attached_file :source,
    filename_cleaner:  Utilities::CleanseFilename

  validates :type, presence: true
  validates :status, presence: true
  validates :description, uniqueness: { scope: :project }, presence: true

  validates_attachment :source, presence: true,
    content_type: { content_type: "text/plain" },
    size: { greater_than: 1.bytes }
end