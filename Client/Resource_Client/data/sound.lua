local ed = ed
local audioParam = {
  effectVolume = 1,
  musicVolume = 1,
  effects = {},
  music = nil,
  musicOn = false,
  isMusicRepeat = true,
  preMusic = nil
}
ed.audioParam = audioParam
ed.soundSwitch = true
LegendSetSoundSwitch(ed.soundSwitch and 0 or 1)
local getSoundPath = function(file)
  if false then
    file = string.gsub(file, ".mp3", ".wav")
  elseif not string.match(file, "%.mp3$") then
    file = string.format("sound/%s_1.mp3", file)
  end
  return file
end
ed.getSoundPath = getSoundPath
local last_played_frame = {}
local function playSound(name)
  if not ed.soundSwitch then
    return
  end
  if not name then
    return
  end
  name = getSoundPath(name)
  if last_played_frame[name] ~= ed.scene.frames then
    SimpleAudioEngine:sharedEngine():playEffect(name)
    last_played_frame[name] = ed.scene.frames
  end
  SimpleAudioEngine:sharedEngine():setEffectsVolume(audioParam.effectVolume)
end
ed.playSound = playSound
local function playEffect(name, isRepeat)
  if not ed.soundSwitch then
    return
  end
  if not name then
    return
  end
  name = getSoundPath(name)
  if not name then
    return
  end
  local id = SimpleAudioEngine:sharedEngine():playEffect(name, isRepeat)
  SimpleAudioEngine:sharedEngine():setEffectsVolume(audioParam.effectVolume)
  return id
end
ed.playEffect = playEffect
local stopAllEffects = function()
  SimpleAudioEngine:sharedEngine():stopAllEffects()
end
ed.stopAllEffects = stopAllEffects
local stopEffect = function(id)
  if id then
    SimpleAudioEngine:sharedEngine():stopEffect(id)
    id = nil
  end
end
ed.stopEffect = stopEffect
local function playMusic(name, isRepeat)
  audioParam.preMusic = audioParam.music
  if not name then
    return
  end
  name = getSoundPath(name)
  if name == audioParam.music then
    return
  end
  ed.stopMusic()
  audioParam.music = name
  audioParam.musicOn = false
  if not ed.soundSwitch then
    return
  end
  if isRepeat == nil or isRepeat then
    SimpleAudioEngine:sharedEngine():playBackgroundMusic(name, true)
    audioParam.isMusicRepeat = true
  else
    SimpleAudioEngine:sharedEngine():playBackgroundMusic(name)
    audioParam.isMusicRepeat = true
  end
  audioParam.musicOn = true
  audioParam.music = name
  SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(audioParam.musicVolume)
end
ed.playMusic = playMusic
local function stopMusic()
  if SimpleAudioEngine:sharedEngine():isBackgroundMusicPlaying() then
    SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
    audioParam.music = nil
  end
end
ed.stopMusic = stopMusic
local function getSoundSwitch()
  return ed.soundSwitch
end
ed.getSoundSwitch = getSoundSwitch
local function turnSoundSwitch()
  ed.soundSwitch = not ed.soundSwitch
  ed.saveSoundSwitch()
  if ed.soundSwitch then
    if audioParam.music then
      if audioParam.musicOn then
        SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
      elseif audioParam.isMusicRepeat then
        SimpleAudioEngine:sharedEngine():playBackgroundMusic(audioParam.music, true)
      else
        SimpleAudioEngine:sharedEngine():playBackgroundMusic(audioParam.music)
      end
      audioParam.musicOn = true
    end
  elseif audioParam.music and audioParam.musicOn then
    SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
  end
  LegendSetSoundSwitch(ed.soundSwitch and 0 or 1)
end
ed.turnSoundSwitch = turnSoundSwitch
local function checkSoundSwitch()
  if audioParam.music and not ed.soundSwitch then
    SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
  end
end
ed.checkSoundSwitch = checkSoundSwitch
local function setMusicVolume(volume)
  audioParam.musicVolume = volume
  SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(audioParam.musicVolume)
end
ed.setMusicVolume = setMusicVolume
local function resetMusicVolume(volume)
  audioParam.musicVolume = 1
  SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(audioParam.musicVolume)
end
ed.resetMusicVolume = resetMusicVolume
