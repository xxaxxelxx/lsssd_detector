# Input the stream,
# from an Icecast server or any other source

url = argv(1)
db_host = argv(2)
db_port = argv(3)
db_pass = argv(4)
alive_interval = float_of_string(argv(5))

id = "#{url}"
id = string.replace(pattern='\/', fun(_) -> "_" , id)
id = string.replace(pattern='\:', fun(_) -> "_" , id)
id = string.replace(pattern='\.', fun(_) -> "_" , id)

%include "config.sys"

strg_sql_parallel_process="echo \"select status from status where mntpnt = '#{url}' and ((UNIX_TIMESTAMP() - #{alive_interval}) < alive);\" | mysql -u detector -p#{db_pass} -D silenceDB -h #{db_host} -P #{db_port} --connect-timeout=#{db_timeout} | grep -e 0 -e 1 > /dev/null"
strg_sql_valid_mntpnt="echo \"select status from status where mntpnt = '#{url}';\" | mysql -u detector -p#{db_pass} -D silenceDB -h #{db_host} -P #{db_port} --connect-timeout=#{db_timeout} | grep -e 0 -e 1 -e 2 > /dev/null"
strg_sql_set_silent="echo \"update status set since = UNIX_TIMESTAMP(), status = 1 where mntpnt = '#{url}';\" | mysql -u detector -p#{db_pass} -D silenceDB -h #{db_host} -P #{db_port} --connect-timeout=#{db_timeout}"
strg_sql_set_sound="echo \"update status set since = UNIX_TIMESTAMP(), status = 0 where mntpnt = '#{url}';\" | mysql -u detector -p#{db_pass} -D silenceDB -h #{db_host} -P #{db_port} --connect-timeout=#{db_timeout}"
strg_sql_set_alive="echo \"update status set alive = UNIX_TIMESTAMP() where mntpnt = '#{url}';\" | mysql -u detector -p#{db_pass} -D silenceDB -h #{db_host} -P #{db_port} --connect-timeout=#{db_timeout}"

##################################################################################################################################
input = mksafe(input.http(url))

%include "functions.sys"

system(strg_sql_set_alive)

add_timeout(fast=false,alive_interval,test_validmntpnt)
add_timeout(fast=false,alive_interval,test_parallelprocess)

if max_runtime > 0.0 then
    add_timeout(fast=false,max_runtime,do_shutdown)
end

stream = fallback(track_sensitive=false, transitions=[ to_signal, to_silence ], [ strip_blank(max_blank=max_silence,input), input ])

%include "output_dummy"

# END
#####
