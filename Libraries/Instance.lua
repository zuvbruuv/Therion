local TweenService = game:GetService("TweenService")

local Creator = {}
do
    function Creator:Tween(object, tweenData, goals)
        local TweenInfo = TweenInfo.new(
            tweenData.Time or 1,
            tweenData.EasingStyle or Enum.EasingStyle.Linear,
            tweenData.EasingDirection or Enum.EasingDirection.Out,
            tweenData.RepeatCount or 0,
            tweenData.Reverses or false,
            tweenData.DelayTime or 0
        )

        local Tween = TweenService:Create(object, TweenInfo, goals)
        Tween:Play()
        return Tween
    end

    function Creator:Create(class, properties)
        local Instance = Instance.new(class)

        for property, value in properties do
            if property ~= "Parent" and property ~= "Children" and property ~= "Tween" then
                Instance[property] = value
            end
        end

        if properties.Tween then
            self:Tween(Instance, properties.Tween, properties.Tween.Goals or {})
        end

        if properties.Children then
            for _, childData in properties.Children do
                local ChildClass = childData[1]
                local ChildProperties = childData[2]

                local ChildObject = self:Create(ChildClass, ChildProperties)
                ChildObject.Parent = Instance
            end
        end

        if properties.Parent then
            Instance.Parent = properties.Parent
        end

        return Instance
    end
end

return Creator
