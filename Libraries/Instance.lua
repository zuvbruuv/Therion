-- // Services
local TweenService = game:GetService('TweenService')

-- // Creator Class
local Creator = {}
Creator.__index = Creator
do
    function Creator.new()
        local self = setmetatable({}, Creator)
        return self
    end

    function Creator:ApplyTween(Instance, TweenInfoData, Goals)
        local TweenInfoObj = TweenInfo.new(
            TweenInfoData.Time or 1,
            TweenInfoData.EasingStyle or Enum.EasingStyle.Linear,
            TweenInfoData.EasingDirection or Enum.EasingDirection.Out,
            TweenInfoData.RepeatCount or 0,
            TweenInfoData.Reverses or false,
            TweenInfoData.DelayTime or 0
        )

        local Tween = TweenService:Create(Instance, TweenInfoObj, Goals)
        Tween:Play()
        return Tween
    end

    function Creator.CreateInstance(self, ClassName, Props)
        local Instance = Instance.new(ClassName)

        for Property, Value in pairs(Props) do
            if Property ~= 'Parent' and Property ~= 'Children' and Property ~= 'Tween' then
                Instance[Property] = Value
            end
        end

        if Props.Tween then
            self:ApplyTween(Instance, Props.Tween, Props.Tween.Goals or {})
        end

        if Props.Children then
            for _, ChildData in pairs(Props.Children) do
                local ChildClassName = ChildData[1]
                local ChildProps = ChildData[2]

                local ChildInstance = Creator.CreateInstance(Creator, ChildClassName, ChildProps)
                ChildInstance.Parent = Instance
            end
        end

        if Props.Parent then
            Instance.Parent = Props.Parent
        end

        return Instance
    end
end

-- // Return
return Creator
