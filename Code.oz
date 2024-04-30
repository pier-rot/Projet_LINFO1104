local 
   % Vous pouvez remplacer ce chemin par celui du dossier qui contient LethOzLib.ozf
   % Please replace this path with your own working directory that contains LethOzLib.ozf

   % Dossier = {Property.condGet cwdir '/home/max/FSAB1402/Projet-2017'} % Unix example
   Dossier = {Property.condGet cwdir '/home/pierre/dev/oz/Projet_LINFO1104'}
   % Dossier = {Property.condGet cwdir 'C:\\Users\Thomas\Documents\UCL\Oz\Projet'} % Windows example.
   LethOzLib

   % Les deux fonctions que vous devez implémenter
   % The two function you have to implement
   Next
   DecodeStrategy
   
   % Hauteur et largeur de la grille
   % Width and height of the grid
   % (1 <= x <= W=24, 1 <= y <= H=24)
   W = 24
   H = 24

   Options
in
   % Merci de conserver cette ligne telle qu'elle.
   % Please do NOT change this line.
   [LethOzLib] = {Link [Dossier#'/'#'LethOzLib.ozf']}
   {Browse LethOzLib.play}

%%%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here  %
% Votre code vient ici %
%%%%%%%%%%%%%%%%%%%%%%%%

   local
      % Déclarez vos functions ici
      % Declare your functions here
      FollowDirOf
      RotatePos
      TurnDir
      Step
      Times
      UpdateShip
      ApplyEffect
      ApplyRevert
      ApplyScrap
      ApplyWormhole
      ApplySeismicCharge
      RemoveAllFrom
   in
      % La fonction qui renvoit les nouveaux attributs du serpent après prise
      % en compte des effets qui l'affectent et de son instruction
      % The function that computes the next attributes of the spaceship given the effects
      % affecting him as well as the instruction
      % 
      % instruction ::= forward | turn(left) | turn(right)
      % P ::= <integer x such that 1 <= x <= 24>
      % direction ::= north | south | west | east
      % spaceship ::=  spaceship(
      %               positions: [
      %                  pos(x:<P> y:<P> to:<direction>) % Head
      %                  ...
      %                  pos(x:<P> y:<P> to:<direction>) % Tail
      %               ]
      %               effects: [scrap|revert|wormhole(x:<P> y:<P>)|... ...]
      %            )
      fun {Next Spaceship Instruction} % Returns the updated Spaceship according to the given Instruction as well as its current effects.
         NewSpaceship = {UpdateShip Spaceship} 
      in 
         case Instruction of forward then
               {TurnDir NewSpaceship forward}
            [] turn(Dir) then
               {TurnDir NewSpaceship Dir}
            [] stop then
               Spaceship
            end
            
      end

      fun {FollowDirOf P} % Returns a new pos(x:<P> y:<P> to:east|south|west|north) with a x or y incremented/decremented by 1 depending on it's to feature.
         % Returns the next position in P's direction
         % Args : P ::= pos(x:X y:Y to:north|east|south|west)
         % Returns : Q ::= pos(x:X +- 1 y:Y +-1 to:P.to)
         % OK
         {Step P 1}
      end

      fun {Step P S} % Returns a new pos(x:<P> y:<P> to:east|south|west|north) with a x or y incremented/decremented by S depending on it's to feature.
         local CurrDir NextX NextY in
            CurrDir = P.to
            case CurrDir of east then
               NextX = P.x + S
               NextY = P.y
            [] west then
               NextX = P.x - S
               NextY = P.y
            [] south then
               NextX = P.x
               NextY = P.y + S
            [] north then
               NextX = P.x
               NextY = P.y - S
            end
            {AdjoinAt {AdjoinAt P x NextX} y NextY}
         end
      end

      fun {RotatePos P Dir} % Returns P rotated in the Dir direction.
         case Dir of right then
            case P.to of east then
               {AdjoinAt P to south}
            [] south then
               {AdjoinAt P to west}
            [] west then
               {AdjoinAt P to north}
            [] north then
               {AdjoinAt P to east}
            end
         [] left then
            case P.to of east then
               {AdjoinAt P to north}
            [] south then
               {AdjoinAt P to east}
            [] west then
               {AdjoinAt P to south}
            [] north then
               {AdjoinAt P to west}
            end
         [] forward then
            P
         end
      end

      fun {TurnDir Spaceship Dir} % Moves Spaceship according to the direction Dir ::= forward|turn(left)|turn(right).
         local NewHead Front in 
            NewHead = {FollowDirOf {RotatePos Spaceship.positions.1 Dir}}
            Front = {List.take Spaceship.positions {Length Spaceship.positions}-1}
            {AdjoinAt Spaceship positions NewHead|Front}
         end
      end
  
      fun {UpdateShip Spaceship} % Updates Spaceship with all the effects in Spaceship.effects, removing duplicate effects.
         case Spaceship.effects
         of nil then Spaceship
         [] Effect|Rest then
            {UpdateShip{AdjoinAt {ApplyEffect Effect Spaceship} effects {RemoveAllFrom Rest Effect}}}
         end
      end

      fun {ApplyEffect Effect Spaceship} % Applies Effect to Spaceship and returns the new Spaceship.
         case Effect
         of scrap then
            {ApplyScrap Spaceship}
         [] revert then
            {ApplyRevert Spaceship}
         [] wormhole(x:X y:Y) then
            {ApplyWormhole X Y Spaceship}
         [] dropSeismicCharge(L) then
            {ApplySeismicCharge L Spaceship}
         [] nil then
            Spaceship
         end
      end

      fun {ApplyScrap Spaceship} % Returns Spaceship with an additional block at the end.
         {AdjoinAt Spaceship positions {Append Spaceship.positions [{Step {List.last Spaceship.positions} ~1}]}}
      end

      fun {ApplyRevert Spaceship} % Returns Spaceship reverted.
         fun {OppositeDir P}
            case P.to
            of east then
               {AdjoinAt P to west}
            [] south then
               {AdjoinAt P to north}
            [] west then
               {AdjoinAt P to east}
            [] north then
               {AdjoinAt P to south}
            end
         end
      in
         {AdjoinAt Spaceship positions {Map {Reverse Spaceship.positions} OppositeDir}}
      end

      fun {ApplyWormhole X Y Spaceship} % Transports the Spaceship through wormhole at (X,Y).
            {AdjoinAt Spaceship positions pos(x:X y:Y to:Spaceship.positions.1.to)|Spaceship.positions.2}
      end

      fun {ApplySeismicCharge L Spaceship} % Gives seismic charges L to Spaceship.
         local ReturnBomb NoBomb in
            NoBomb = false|NoBomb
            fun {ReturnBomb L}
               case L of H|T then
                  H|{ReturnBomb T}
               [] nil then
                  NoBomb
               end
            end
            {AdjoinAt Spaceship seismicCharge {ReturnBomb L}}
         end
      end

      fun {RemoveAllFrom L X} % Remove all elements I of L such that I==X.
         if {Member X L} then
            {RemoveAllFrom {List.subtract L X} X}
         else
            L 
        end
      end

      
      % La fonction qui décode la stratégie d'un serpent en une liste de fonctions. Chacune correspond
      % à un instant du jeu et applique l'instruction devant être exécutée à cet instant au spaceship
      % passé en argument
      % The function that decodes the strategy of a spaceship into a list of functions. Each corresponds
      % to an instant in the game and should apply the instruction of that instant to the spaceship
      % passed as argument
      %
      % strategy ::= <instruction> '|' <strategy>
      %            | repeat(<strategy> times:<integer>) '|' <strategy>
      %            | nil
      fun {Times Rec I Val}
         if I == 0 then Rec
         else
            {Times {AdjoinAt Rec I Val} I-1 Val}
         end
      end

      fun {DecodeStrategy Strategy}
         local DecodeStrategyAux in 
            fun {DecodeStrategyAux Strategy}
               case Strategy of repeat(I times:T)|S then
                  {Record.toList {Times '|'() T {DecodeStrategyAux I}}}|{DecodeStrategyAux S}
               [] nil then nil
               [] I|S then
                  fun {$ Spaceship} {Next Spaceship I} end|{DecodeStrategyAux S}
               [] I then
                  fun {$ Spaceship} {Next Spaceship I} end
               end
            end
            {List.flatten {DecodeStrategyAux Strategy}}
         end
      end



      % Extensions

      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'scenario/scenario_test_moves.oz'
		   % Utilisez cette touche pour quitter la fenêtre
		   % Use this key to leave the graphical mode
		   closeKey:'Escape'
		   % Visualisation de la partie
		   % Graphical mode
		   debug: true
		   % Instants par seconde, 0 spécifie une exécution pas à pas. (appuyer sur 'Espace' fait avancer le jeu d'un pas)
		   % Steps per second, 0 for step by step. (press 'Space' to go one step further)
		   frameRate: 5
		)
   end

%%%%%%%%%%%
% The end %
%%%%%%%%%%%
   
   local 
      R = {LethOzLib.play Dossier#'/'#Options.scenario Next DecodeStrategy Options}
   in
      {Browse R}
   end
end
