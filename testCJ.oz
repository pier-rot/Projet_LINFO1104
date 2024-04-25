fun {DecodeStrategy Strategy}
    case Strategy of H|T then 
        if H == forward  then {Next Spaceship forward}|{DecodeStrategy T}
        elseif H == turn(left) then {Next Spaceship turn(left)}|{DecodeStrategy T}
        elseif H == turn(right) then {Next Spaceship turn(right)}|{DecodeStrategy T}
        elseif case H of repeat(Strategy times:X) then 
            {Repeat 1 H.times strategy_spaceship {DecodeStrategy Strategy}}
    [] nil then nil 

end



declare 
fun {Repeat Start End Init Fun}
    Res = {Fun Init Start}
 in
    if Start == End then
       Res
    else
       {Repeat Start+1 End Res Fun}
    end
 end


{Browse {Repeat 1 4 Init Fun}}



declare
Oui=[repeat([turn(right)] times:2) forward]
{Browse Oui.1.1}

{Browse {IsRecord repeat([turn(right)] times:2)}}


declare 
fun {Test Strat}
    case Strat of repeat(Inst times:X) then Strat.times else merde end 
end

{Browse {Test repeat([turn(right)] times:2)}}