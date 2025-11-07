#!/usr/bin/env python3
"""
Flow Monitor Service - CLI Interface

Monitor fuzzing executions for dataflow coverage and taint flow completion.
"""

import sys
from pathlib import Path

# Add monitor directory to path
sys.path.insert(0, str(Path(__file__).parent))

import click
from config import MonitorConfig
from flow_db import FlowDatabase
from monitor import FlowMonitor, setup_logging


@click.command()
@click.option(
    '--flowdb', 
    required=True,
    type=click.Path(exists=True, path_type=Path),
    help='Path to .flowdb file with flow definitions'
)
@click.option(
    '--config', '-c',
    type=click.Path(exists=True, path_type=Path),
    help='Path to YAML configuration file'
)
@click.option(
    '--output', '-o',
    type=click.Path(path_type=Path),
    help='Output file path (default: stdout)'
)
@click.option(
    '--output-format',
    type=click.Choice(['json', 'jsonl'], case_sensitive=False),
    help='Output format (default: jsonl)'
)
@click.option(
    '--log-level',
    type=click.Choice(['DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL'], case_sensitive=False),
    help='Logging level (default: INFO)'
)
@click.option(
    '--log-file',
    type=click.Path(path_type=Path),
    help='Log file path (default: stderr)'
)
@click.option(
    '--max-executions',
    type=int,
    help='Maximum executions to process before exiting'
)
@click.option(
    '--poll-interval',
    type=float,
    help='Polling interval in seconds (default: 0.1)'
)
@click.option(
    '--no-cleanup',
    is_flag=True,
    help='Disable automatic cleanup of processed shared memory'
)
@click.option(
    '--cleanup-on-exit',
    is_flag=True,
    help='Cleanup all regions on exit'
)
@click.option(
    '--stats-interval',
    type=int,
    help='Print statistics every N seconds (0 to disable)'
)
@click.option(
    '--no-stats',
    is_flag=True,
    help='Disable statistics summary on exit'
)
def main(flowdb, config, output, output_format, log_level, log_file,
         max_executions, poll_interval, no_cleanup,
         cleanup_on_exit, stats_interval, no_stats):
    """
    Flow Monitor Service - Monitor fuzzing executions for taint flow completion.
    
    Examples:
    
      \b
      # Basic usage
      flow-monitor --flowdb flows.flowdb
      
      \b
      # Use custom configuration
      flow-monitor --config configs/production.yaml --flowdb flows.flowdb
      
      \b
      # Output to file
      flow-monitor --flowdb flows.flowdb --output results.jsonl
      
      \b
      # Development mode
      flow-monitor --flowdb flows.flowdb --log-level DEBUG --no-cleanup
      
      \b
      # Process only 100 executions
      flow-monitor --flowdb flows.flowdb --max-executions 100
    """
    
    try:
        # Load configuration
        monitor_config = load_config(
            config_path=config,
            flowdb_path=flowdb,
            output=output,
            output_format=output_format,
            log_level=log_level,
            log_file=log_file,
            max_executions=max_executions,
            poll_interval=poll_interval,
            no_cleanup=no_cleanup,
            cleanup_on_exit=cleanup_on_exit,
            stats_interval=stats_interval,
            no_stats=no_stats
        )
        
        # Validate configuration
        monitor_config.validate()
        
        # Setup logging
        setup_logging(monitor_config)
        
        # Load flow database
        flow_db = FlowDatabase.from_file(flowdb)
        
        # Create and start monitor
        monitor = FlowMonitor(monitor_config, flow_db)
        monitor.start()
        
    except KeyboardInterrupt:
        click.echo("\nInterrupted by user", err=True)
        sys.exit(130)
    
    except (FileNotFoundError, ValueError) as e:
        click.echo(f"Error: {e}", err=True)
        sys.exit(1)
    
    except Exception as e:
        click.echo(f"Unexpected error: {e}", err=True)
        import traceback
        traceback.print_exc()
        sys.exit(1)


def load_config(config_path, flowdb_path, output, output_format, log_level,
                log_file, max_executions, poll_interval, no_cleanup,
                cleanup_on_exit, stats_interval, no_stats) -> MonitorConfig:
    """
    Load and merge configuration from file and command-line arguments.
    
    Returns:
        MonitorConfig instance
    """
    # Load base configuration
    if config_path:
        cfg = MonitorConfig.from_yaml(str(config_path))
    else:
        # Use default configuration
        default_config = Path(__file__).parent / 'configs' / 'default.yaml'
        if default_config.exists():
            cfg = MonitorConfig.from_yaml(str(default_config))
        else:
            # Fall back to built-in defaults
            cfg = MonitorConfig()
    
    # Override with command-line arguments (only if provided)
    if flowdb_path:
        cfg.flow_database.database_path = str(flowdb_path)
    
    if output:
        cfg.output.destination = str(output)
    
    if output_format:
        cfg.output.format = output_format
    
    if log_level:
        cfg.logging.level = log_level.upper()
    
    if log_file:
        cfg.logging.destination = str(log_file)
    
    if max_executions is not None:
        cfg.processing.max_executions = max_executions
    
    if poll_interval is not None:
        cfg.shared_memory.poll_interval = poll_interval
    
    if no_cleanup:
        cfg.cleanup.auto_cleanup = False
    
    if cleanup_on_exit:
        cfg.cleanup.cleanup_on_exit = True
    
    if stats_interval is not None:
        cfg.statistics.print_interval = stats_interval
    
    if no_stats:
        cfg.statistics.print_summary = False
    
    # Override from environment variables
    cfg.override_from_env()
    
    return cfg


if __name__ == '__main__':
    main()
