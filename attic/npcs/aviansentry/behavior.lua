function init()
  self.sensors = sensors.create()

  self.state = stateMachine.create({
    "moveState",
    "cleanState",
    "attackState"
  })
  self.state.leavingState = function(stateName)
    entity.setAnimationState("movement", "idle")
  end

  entity.setAggressive(false)
  entity.setDeathParticleBurst("deathPoof")
  entity.setAnimationState("movement", "idle")
end

function update(dt)
  self.state.update(dt)
  self.sensors.clear()
end

function damage(args)
  self.state.pickState(args.sourceId)
end

function move(direction)
  entity.setAnimationState("movement", "move")

  mcontroller.controlMove(direction, true)
end

--------------------------------------------------------------------------------
moveState = {}

function moveState.enter()
  local direction
  if math.random(100) > 50 then
    direction = 1
  else
    direction = -1
  end

  return {
    timer = entity.randomizeParameterRange("moveTimeRange"),
    direction = direction
  }
end

function moveState.update(dt, stateData)
  if self.sensors.collisionSensors.collision.any(true) then
    stateData.direction = -stateData.direction
  end

  move(stateData.direction)

  stateData.timer = stateData.timer - dt
  if stateData.timer <= 0 then
    return true, 1.0
  end

  return false
end

--------------------------------------------------------------------------------
cleanState = {}

function cleanState.enter()
  return { timer = entity.randomizeParameterRange("cleanTimeRange") }
end

function cleanState.update(dt, stateData)
  stateData.timer = stateData.timer - dt
  return stateData.timer <= 0
end

--------------------------------------------------------------------------------
attackState = {}

function attackState.enterWith(targetId)
  if targetId == 0 then return nil end

  attackState.setAggressive(targetId)

  return { timer = entity.configParameter("attackTargetHoldTime") }
end

function attackState.update(dt, stateData)
  util.trackExistingTarget()

  if self.targetPosition ~= nil then
    local toTarget = world.distance(self.targetPosition, mcontroller.position())

    if world.magnitude(toTarget) < entity.configParameter("attackDistance") then
      attackState.setAttackEnabled(true)
    else
      attackState.setAttackEnabled(false)
      move(util.toDirection(toTarget[1]))
    end
  end

  if self.targetId == nil then
    stateData.timer = stateData.timer - dt
  else
    stateData.timer = entity.configParameter("attackTargetHoldTime")
  end

  if stateData.timer <= 0 then
    attackState.setAttackEnabled(false)
    attackState.setAggressive(nil)
    return true
  else
    return false
  end
end

function attackState.setAttackEnabled(enabled)
  if enabled then
    entity.setAnimationState("movement", "attack")
  else
    entity.setAnimationState("movement")
  end

  entity.setDamageOnTouch(enabled)
end

function attackState.setAggressive(targetId)
  self.targetId = targetId

  if targetId ~= nil then
    entity.setAnimationState("movement")
    entity.setAggressive(true)
  else
    entity.setAnimationState("movement", "idle")
    entity.setAggressive(false)
  end
end
