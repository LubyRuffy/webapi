
[1mFrom:[0m /home/venus/rails/webapi/app/controllers/licenses_controller.rb @ line 125 LicensesController#parse_license:

    [1;34m104[0m: [32mdef[0m [1;34mparse_license[0m(license)
    [1;34m105[0m:   valid_time = license[[1;34m0[0m, [1;34m6[0m]
    [1;34m106[0m:   license_time = license[[1;34m24[0m,[1;34m3[0m]
    [1;34m107[0m: 
    [1;34m108[0m:   year = [31m[1;31m'[0m[31m20[1;31m'[0m[31m[0m + valid_time[[1;34m0[0m,[1;34m2[0m]
    [1;34m109[0m:   month = valid_time[[1;34m2[0m,[1;34m2[0m]
    [1;34m110[0m:   day = valid_time[[1;34m4[0m,[1;34m2[0m]
    [1;34m111[0m:   @valid_time = [1;34;4mTime[0m.mktime(year, month, day, [1;34m0[0m, [1;34m0[0m, [1;34m0[0m)
    [1;34m112[0m: 
    [1;34m113[0m:   [32mif[0m @valid_time < [1;34;4mTime[0m.now
    [1;34m114[0m:     @valid_time = [1;36mnil[0m
    [1;34m115[0m:     [32mreturn[0m [1;36mfalse[0m 
    [1;34m116[0m:   [32mend[0m
    [1;34m117[0m: 
    [1;34m118[0m:   t = [1;34;4mTime[0m.now
    [1;34m119[0m:   months = t.month + license_time.to_i
    [1;34m120[0m: 
    [1;34m121[0m:   year = months.to_i/[1;34m12[0m + t.year 
    [1;34m122[0m:   month = months.to_i%[1;34m12[0m
    [1;34m123[0m: 
    [1;34m124[0m:   binding.pry
 => [1;34m125[0m:   @expired_time = [1;34;4mTime[0m.mktime(year, month, t.day, t.hour, t.min, t.sec)
    [1;34m126[0m: 
    [1;34m127[0m: 
    [1;34m128[0m:   [32mif[0m @expired_time < t 
    [1;34m129[0m:     @expired_time = [1;36mnil[0m
    [1;34m130[0m:     [32mreturn[0m [1;36mfalse[0m 
    [1;34m131[0m:   [32mend[0m
    [1;34m132[0m: [32mend[0m

