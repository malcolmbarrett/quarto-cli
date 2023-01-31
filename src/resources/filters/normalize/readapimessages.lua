-- readapimessages.lua
-- Copyright (C) 2020-2023 Posit Software, PBC

local _api_messages

function read_api_messages()
  return {
    Meta = function(meta)
      local f = io.open(pandoc.utils.stringify(meta._quarto_api_messages), "r")
      if f == nil then
        print("Internal error: Couldn't open API messages file")
        crash_with_stack_trace()
      end
      _api_messages = pandoc.List(quarto.json.decode(f:read()))
      f:close()
    end
  }
end

function get_api_messages()
  return _api_messages
end

function get_messages_for_table(id)
  return _api_messages:filter(function(msg)
    return msg.payload ~= nil and msg.payload.table_id == id
  end)
end
