class FixQaLocalForeignKey < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :qa_local_authority_entries, :local_authorities
     add_foreign_key :qa_local_authority_entries, :qa_local_authorities, column: :local_authority_id

  end
end
