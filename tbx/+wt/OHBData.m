classdef OHBData
    %OHBDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Drag = nan
        DragStd = nan
        Side = nan
        SideStd = nan
        Lift = nan
        LiftStd = nan
        Roll = nan
        RollStd = nan
        Pitch = nan
        PitchStd = nan
        Yaw = nan
        YawStd = nan
        Velocity = nan
        DynamicPressure = nan
        AirTemp = nan
        Pressure = nan
        ModelAoA = nan
        ModelYaw = nan
        Datetime = nan
    end
    
    methods(Static)
        function obj = FromString(ohb_str)
            %OHBDATA Construct an instance of this class
            %   Detailed explanation goes here
            Values = split(strrep(ohb_str,"""",""),";");
            obj = OHBData();
            obj.Drag        = str2double(Values(2));
            obj.DragStd     = str2double(Values(3));
            obj.Side        = str2double(Values(4));
            obj.SideStd     = str2double(Values(5));
            obj.Lift        = str2double(Values(6));
            obj.LiftStd     = str2double(Values(7));
            obj.Roll        = str2double(Values(8));
            obj.RollStd     = str2double(Values(9));
            obj.Pitch       = str2double(Values(10));
            obj.PitchStd    = str2double(Values(11));
            obj.Yaw         = str2double(Values(12));
            obj.YawStd      = str2double(Values(13));
            obj.Velocity    = str2double(Values(14));
            obj.DynamicPressure = str2double(Values(15));
            obj.AirTemp     = str2double(Values(16));
            obj.Pressure    = str2double(Values(17));
            obj.ModelAoA  = str2double(Values(18));
            obj.ModelYaw  = str2double(Values(19));
            obj.Datetime = datetime(Values(20),'InputFormat','yyyy-MM-dd_HH:mm:ss');
        end
    end
    methods
        function out = ToStruct(obj)
            out = struct(obj);
        end
    end
end

