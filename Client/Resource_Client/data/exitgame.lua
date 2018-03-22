local ExitGame = function()
  LegendAnimation:releaseAnimationFileInfo()
  LoadResources:releaseMemory()
end
ListenEvent("ExitGame", ExitGame)
