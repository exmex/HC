local smtp = require("socket.smtp")
require("gzio")
function sendmailwithattachment(filename, label)
  print(filename)
  print("smtp send mail begin!")
  from = "<legendBugReport@163.com>"
  to = "<legendBugReport@163.com>"
  rcpt = {
    "<legendBugReport@163.com>"
  }
  mesgt = {}
  if filename == nil then
    mesgt = {
      headers = {
        to,
        subject = "LegendGame-LuaCrashLog " .. label
      },
      body = "lua crashed,but no file name input!"
    }
  else
    testfileexisted = io.open(filename, "rb")
    if testfileexisted == nil then
      print("attachment not exist!")
    else
      print("attachment ok!")
    end
    mesgt = {
      headers = {
        to,
        ["content-type"] = "text/html",
        ["content-disposition"] = "attachment; filename=\"" .. filename .. "\"",
        ["content-description"] = "luaDumpLogFile",
        ["content-transfer-encoding"] = "BASE64",
        ["subject"] = "LegendGame-LuaCrashLog " .. label
      },
      body = ltn12.source.chain(ltn12.source.file(testfileexisted), ltn12.filter.chain(mimestuff.encode("base64"), mimestuff.wrap()))
    }
  end
  print("msg prepared!")
  r, e = smtp.send({
    server = "smtp.163.com",
    user = "legendBugReport@163.com",
    password = "legend|}{2014",
    from = from,
    rcpt = rcpt,
    source = smtp.message(mesgt)
  })
  print("msg sended!")
  if not r then
    print(e)
  else
    print("send ok!")
  end
end
function sendmailtext(mailbody, label)
  print(filename)
  print("smtp send mail begin!")
  from = "<legendBugReport@163.com>"
  to = "<legendBugReport@163.com>"
  rcpt = {
    "<legendBugReport@163.com>"
  }
  mesgt = {
    headers = {
      to,
      subject = "LegendGame-LuaCrashLog " .. label
    },
    body = mailbody .. label
  }
  print("msg prepared!")
  r, e = smtp.send({
    server = "smtp.163.com",
    user = "legendBugReport@163.com",
    password = "legend|}{2014",
    from = from,
    rcpt = rcpt,
    source = smtp.message(mesgt)
  })
  print("msg sended!")
  if not r then
    print(e)
  else
    print("send ok!")
  end
end
function ziplog(filename)
  local gzFile
  --print("gzipStart")
  gzFile = assert(gzio.open(filename .. ".zip", "w"))
  for line in io.lines(filename) do
    local ret = gzFile:write(line .. "\n")
  end
  --print("gzipEnd")
  gzFile:close()
end
function senddumpfile(logstr)
  folder = CCFileUtils:sharedFileUtils():getWritablePath()
  local dumpfile = string.format("%s/dump_%s.dump", folder, os.date("%Y-%m-%d-%H-%M-%S"))
  local data = io.open(dumpfile, "wb")
  if logstr == nil then
    data:write("this is test text content")
  else
    data:write(logstr)
  end
  data:close()
  ziplog(dumpfile)
  sendmailwithattachment(dumpfile .. ".zip", "cr ios " .. ed.getDeviceId() .. " " .. ed.getUserid() .. " " .. ed.player:getName() .. " " .. SeverConsts:getInstance():getBaseVersion())
  os.remove(dumpfile)
  os.remove(dumpfile .. ".zip")
end
