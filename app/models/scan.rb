class Scan < ApplicationRecord
	has_many :issues, dependent: :destroy # Will delete with scan deleted.
	has_many :sitemaps, dependent: :destroy # Same as upper .
	serialize :issue_digests,					Array
	serialize :statistics,						Hash
	serialize :scope_exclude_path_patterns,		Array
	serialize :scope_exclude_content_patterns,	Array
	serialize :scope_extend_paths,				Array

end
