class 'ActiveRecord::Adapters::Sqlite' extends 'ActiveRecord::Adapters::Abstract'

ActiveRecord.Adapters.Sqlite.types = {
  primary_key = 'INTEGER PRIMARY KEY NOT NULL',
  string = 'varchar',
  text = 'text',
  integer = 'integer',
  float = 'float',
  decimal = 'decimal',
  datetime = 'datetime',
  timestamp = 'datetime',
  time = 'time',
  date = 'date',
  binary = 'blob',
  boolean = 'boolean',
  json = 'json'
}

function ActiveRecord.Adapters.Sqlite:connect()
  self:on_connected()
end

function ActiveRecord.Adapters.Sqlite:escape(str)
  return sql.SQLStr(string.gsub(str, '"', '\''):gsub('\'', '\'\''), true)
end

function ActiveRecord.Adapters.Sqlite:unescape(str)
  return text:gsub('\'\'', '\'')
end

function ActiveRecord.Adapters.Sqlite:raw_query(query, callback, flags, ...)
  local query_start = os.clock()
  local result = sql.Query(query)

  if (result == false) then
    ErrorNoHalt('ActiveRecord - SQLite Query Error!\n')
    ErrorNoHalt('Query: '..query..'\n')
    ErrorNoHalt(sql.LastError()..'\n')
  else
    if (callback) then
      local status, value = pcall(callback, result, query, math.Round(os.clock() - query_start, 2))

      if (!status) then
        ErrorNoHalt(string.format('ActiveRecord - SQL callback Error!\n%s\n', value))
      end
    end
  end
end
