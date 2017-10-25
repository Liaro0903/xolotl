all_tests = dir('test*.m');

for i = 1:length(all_tests)
	disp(['Running test: ' all_tests(i).name])
	try
		run(all_tests(i).name)
		close all
	catch
		disp('Test failed!')
	end
end