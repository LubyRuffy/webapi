class CreateIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :issues do |t|
      t.string :name
      t.string :url
      t.string :vector_name
      t.float :cvssv2
      t.integer :cwe
      t.string :cwe_url
      t.text :description
      t.string :vector_type
      t.string :http_method
      t.text :tags
      t.string :signature
      t.string :seed
      t.string :proof
      t.text :response_body
      t.boolean :requires_verification
      t.text :references
      t.text :remedy_code
      t.text :remedy_guidance
      t.text :remarks
      t.string :severity
      t.string :digest
      t.boolean :false_positive
      t.boolean :verified
      t.text :verification_steps
      t.text :remediation_steps
      t.boolean :fixed
      t.integer :scan_id
      t.text :vector_inputs
      t.text :vector_html
      t.text :dom_transitions
      t.text :dom_body
      t.text :response
      t.text :request

      t.timestamps
    end
  end
end
