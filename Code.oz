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
      MoveForward
      TurnDir
      TurnLeft
      TurnRight
      EffectsAt
      FollowDirOf
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
      fun {Next Spaceship Instruction}
         case Instruction of forward then
            {TurnDir Spaceship forward}
         [] turn(Dir) then
            {TurnDir Spaceship Dir}
         end
      end

      fun {FollowDirOf P}
         % Returns the next position in P's direction
         % Args : P ::= pos(x:X y:Y to:north|east|south|west)
         % Returns : Q ::= pos(x:X +- 1 y:Y +-1 to:P.to)
         % OK
         local CurrDir NextX NextY in
            CurrDir = P.to
            case CurrDir of east then
               NextX = P.x + 1
               NextY = P.y
            [] west then
               NextX = P.x - 1
               NextY = P.y
            [] south then
               NextX = P.x
               NextY = P.y + 1
            [] north then
               NextX = P.x
               NextY = P.y - 1
            end
            %% TODO
            %% Check if new position is viable (i.e. out of bonds)
            {AdjoinAt {AdjoinAt P x NextX} y NextY}
         end
      end

      fun {RotatePos P Dir}
         % Rotates P in the given direction Dir
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

      fun {TurnDir Spaceship Dir}
         % Moves Spaceship according to the direction Dir ::= forward|turn(left)|turn(right)
         local NewHead Front in 
            NewHead = {FollowDirOf {RotatePos Spaceship.positions.1 Dir}}
            Front = {List.take Spaceship.positions {Length Spaceship.positions}-1}
            {AdjoinAt Spaceship positions NewHead|Front}
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
      fun {DecodeStrategy Strategy}
         [
            fun{$ Spaceship}
               Spaceship
            end
         ]
      end

      % Options
      Options = options(
		   % Fichier contenant le scénario (depuis Dossier)
		   % Path of the scenario (relative to Dossier)
		   scenario:'scenario/scenario_crazy.oz'
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
