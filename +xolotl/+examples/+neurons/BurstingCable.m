function x = BurstingCable(varargin)


% options and defaults
options.N = 10;
options.n_channels = 7;
options.uniform_nav = false;
options.start_axon = 7;

% geometry is a cylinder
options.r_neurite = .01; % default value
options.L_neurite = .35*5; % mm, from Otopalik et al
options.r_soma = .025;
options.L_soma = .05; % mm, Jason's guesstimates
options.phi = 1;
options.shell_thickness = .01; % 10 micrometres


% textbook value
options.axial_resitivity = 1e-3; % MOhm mm; 


% validate and accept options
options = corelib.parseNameValueArguments(options, varargin{:});



x = xolotl;


x.add('compartment','CellBody','radius',options.r_soma,'len',options.L_soma,'Ca_out',3000,'tree_idx',0,'shell_thickness',options.shell_thickness);
if options.N > 1
	x.add('compartment','Neurite','radius',options.r_neurite,'len',options.L_neurite,'Ca_out',3000,'shell_thickness',options.shell_thickness);
end
prefix = 'prinz/';
channels = {'ACurrent','CaS',  'CaT','HCurrent','KCa','Kd','NaV'};

g =           [104;     11.76;  4.7 ;   .1;      390;  250;  2e3];
E =           [-80;      30;   30;      -20;     -80;   -80;  50 ];

compartments = x.find('compartment');
for j = 1:length(compartments)

	% add a calcium mechanism
	x.(compartments{j}).add('buchholtz/CalciumMech','phi',options.phi);

	for i = 1:options.n_channels
	
		x.(compartments{j}).add([prefix channels{i}],'gbar',g(i),'E',E(i));

	end
end




if options.N > 1
	x.slice('Neurite',options.N);

	comp_names = x.find('compartment');
	if ~options.uniform_nav
		for i = 1:options.start_axon
			try
				x.(comp_names{i}).NaV.gbar = 0;
			catch
			end
		end
	end

	x.connect(x.Children{2},'CellBody');
end

