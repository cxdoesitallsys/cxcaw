print("[MyScript] - Authentication successful!")
print("[MyScript] - Version: " .. PandaV4Lite.getVersion())
print("[MyScript] - Secure: " .. tostring(PandaV4Lite.isSecure()))

loadstring(game:HttpGet("https://raw.githubusercontent.com/cxdoesitallsys/cxcaw/refs/heads/main/cxcaw.lua"))()
