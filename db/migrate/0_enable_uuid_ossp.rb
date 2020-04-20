class EnableUuidOssp < ActiveRecord::Migration[6.0]
  def change
    enable_extension "plpgsql"
    enable_extension "uuid-ossp"
    enable_extension "pgcrypto"
    enable_extension "postgis"
    enable_extension "pg_trgm"
    enable_extension "postgis_topology"
  end
end