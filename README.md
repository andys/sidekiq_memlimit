## Sidekiq memory limit

This ruby gem gracefully kills Sidekiq worker processes (with USR1 signal)
when the RSS memory exceeds the limit set in the SIDEKIQ_MAX_MB environment
variable.

The memory limit is checked once per 5 seconds in a background thread and
this is only run when inside a Sidekiq worker.

