local sclang = require'scnvim.sclang'
local stdout

sclang.on_start = function()
  stdout = {''}
end

sclang.on_read = function(line)
  table.insert(stdout, line)
end

sclang.on_exit = function(code, signal)
  stdout = nil
end

describe('sclang', function()
  it('can start client', function()
    sclang.start()
    local result = false
    vim.wait(5000, function()
      if type(stdout) == 'table' then
        for _, line in ipairs(stdout) do
          if line:match('^*** Welcome to SuperCollider') then
            result = true
            return result
          end
        end
      end
    end)
    assert.is_true(result)
  end)

  it('can stop client', function()
    vim.wait(5000, function()
      sclang.stop()
      return stdout == nil
    end)
    assert.is_nil(stdout)
  end)
end)