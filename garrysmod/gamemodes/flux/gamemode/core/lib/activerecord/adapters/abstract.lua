ActiveRecord.Adapters = ActiveRecord.Adapters or {}

class 'ActiveRecord::Adapters::Abstract'

function ActiveRecord.Adapters.Abstract:init()
  self._connected = false
  self._queue = {}
end

function ActiveRecord.Adapters.Abstract:connect(config)
  self._connected = true
end

function ActiveRecord.Adapters.Abstract:disconnect(config)
  self._connected = false
end

function ActiveRecord.Adapters.Abstract:escape(str)
  return str
end

function ActiveRecord.Adapters.Abstract:unescape(str)
  return str
end

function ActiveRecord.Adapters.Abstract:raw_query(query, callback)
end

function ActiveRecord.Adapters.Abstract:queue(query, callback)
  if (isstring(query)) then
    table.insert(self._queue, { query, callback })
  end
end

function ActiveRecord.Adapters.Abstract:append_query(query, query_type, queue)
end

function ActiveRecord.Adapters.Abstract:append_query_string(query, query_string)
end

function ActiveRecord.Adapters.Abstract:create_column(query, column, args, obj, type, def)
end

function ActiveRecord.Adapters.Abstract:think()
  if (#self._queue > 0) then
    if (istable(self._queue[1])) then
      local queue_obj = self._queue[1]
      local query_string = queue_obj[1]

      if (isstring(query_string)) then
        self:raw_query(query_string, queue_obj[2])
      end

      table.remove(self._queue, 1)
    end
  end
end

function ActiveRecord.Adapters.Abstract:is_result(result)
  return istable(result) and #result > 0
end

-- Called when the Database connects sucessfully.
function ActiveRecord.Adapters.Abstract:on_connected()
  self._connected = true
  MsgC(Color(25, 235, 25), 'ActiveRecord - Connected to the database using '..ActiveRecord.adapter_name..'!\n')
  ActiveRecord.on_connected()
  hook.Run('database_connected')
end

-- Called when the Database connection fails.
function ActiveRecord.Adapters.Abstract:on_connection_failed(error_text)
  ErrorNoHalt('ActiveRecord - Unable to connect to the database!\n'..error_text..'\n')
  hook.Run('database_connection_failed', error_text)
end

-- A function to check whether or not the module is connected to a Database.
function ActiveRecord.Adapters.Abstract:connected()
  return self._connected
end
