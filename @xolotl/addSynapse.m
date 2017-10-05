function addSynapse(self,syn_id,comp1,comp2,gbar)

	% fail early 
	assert(any(strcmp(comp1,self.compartment_names)),'Unknown compartment')
	assert(any(strcmp(comp2,self.compartment_names)),'Unknown compartment')
	assert(length(gbar) == 1,'gbar has the wrong size')
	assert(~isnan(gbar),'gbar cannot be NaN')

	% search for syn_id
	syn_file = [];
	for i = 1:length(self.available_synapses)
		if any(strfind(self.available_synapses{i},syn_id))
			syn_file = i;
			break;
		end
	end
	assert(~isempty(syn_file),'Which synapse do you mean?')

	syn_name = pathEnd(self.available_synapses{syn_file});

	S.type = syn_name;
	S.pre = comp1;
	S.post  = comp2;
	S.gbar = gbar;

	self.synapses  = [self.synapses; S];

	% add this to synapse_headers, if it's not already there
	self.synapse_headers = [self.synapse_headers; self.available_synapses{syn_file}];
end