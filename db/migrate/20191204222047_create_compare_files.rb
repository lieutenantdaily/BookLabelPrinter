class CreateCompareFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :compare_files do |t|

      t.timestamps
    end
  end
end
