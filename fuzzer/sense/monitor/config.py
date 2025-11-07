"""
Configuration management for the Flow Monitor Service.

Handles loading and merging configuration files with support for:
- YAML configuration files
- Configuration inheritance (_base key)
- Environment variable overrides
- Command-line argument overrides
"""

import os
import yaml
from pathlib import Path
from typing import Any, Dict, Optional
from dataclasses import dataclass, field


@dataclass
class SharedMemoryConfig:
    """Shared memory monitoring configuration."""
    shm_dir: str = "/dev/shm"
    flow_events_prefix: str = "flow_events_"
    coverage_prefix: str = "df_coverage_"
    poll_interval: float = 0.1


@dataclass
class FlowDatabaseConfig:
    """Flow database configuration."""
    database_path: Optional[str] = None


@dataclass
class OutputConfig:
    """Output configuration."""
    format: str = "jsonl"
    destination: str = "-"
    buffered: bool = True
    flush_each: bool = False


@dataclass
class ProcessingConfig:
    """Processing configuration."""
    max_executions: Optional[int] = None


@dataclass
class LoggingConfig:
    """Logging configuration."""
    level: str = "INFO"
    format: str = "[%(asctime)s] %(levelname)s: %(message)s"
    destination: Optional[str] = None


@dataclass
class StatisticsConfig:
    """Statistics tracking configuration."""
    print_interval: int = 10
    print_summary: bool = True


@dataclass
class CleanupConfig:
    """Cleanup configuration."""
    auto_cleanup: bool = True
    cleanup_on_startup: bool = True
    cleanup_on_exit: bool = False


@dataclass
class MonitorConfig:
    """Complete monitor configuration."""
    shared_memory: SharedMemoryConfig = field(default_factory=SharedMemoryConfig)
    flow_database: FlowDatabaseConfig = field(default_factory=FlowDatabaseConfig)
    output: OutputConfig = field(default_factory=OutputConfig)
    processing: ProcessingConfig = field(default_factory=ProcessingConfig)
    logging: LoggingConfig = field(default_factory=LoggingConfig)
    statistics: StatisticsConfig = field(default_factory=StatisticsConfig)
    cleanup: CleanupConfig = field(default_factory=CleanupConfig)

    @classmethod
    def from_yaml(cls, config_path: str) -> "MonitorConfig":
        """
        Load configuration from YAML file with inheritance support.
        
        Args:
            config_path: Path to YAML configuration file
            
        Returns:
            MonitorConfig instance
            
        Raises:
            FileNotFoundError: If config file not found
            ValueError: If config is invalid
        """
        config_file = Path(config_path)
        if not config_file.exists():
            raise FileNotFoundError(f"Configuration file not found: {config_path}")
        
        with open(config_file, 'r') as f:
            config_data = yaml.safe_load(f)
        
        # Handle inheritance
        if '_base' in config_data:
            base_name = config_data.pop('_base')
            base_path = config_file.parent / base_name
            
            if not base_path.exists():
                raise ValueError(f"Base configuration not found: {base_path}")
            
            # Load base config
            with open(base_path, 'r') as f:
                base_data = yaml.safe_load(f)
            
            # Merge configs (current overrides base)
            config_data = cls._merge_configs(base_data, config_data)
        
        return cls.from_dict(config_data)
    
    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "MonitorConfig":
        """Create configuration from dictionary."""
        return cls(
            shared_memory=SharedMemoryConfig(**data.get('shared_memory', {})),
            flow_database=FlowDatabaseConfig(**data.get('flow_database', {})),
            output=OutputConfig(**data.get('output', {})),
            processing=ProcessingConfig(
                max_executions=data.get('processing', {}).get('max_executions')
            ),
            logging=LoggingConfig(**data.get('logging', {})),
            statistics=StatisticsConfig(**data.get('statistics', {})),
            cleanup=CleanupConfig(**data.get('cleanup', {}))
        )
    
    @staticmethod
    def _merge_configs(base: Dict[str, Any], override: Dict[str, Any]) -> Dict[str, Any]:
        """
        Recursively merge two configuration dictionaries.
        
        Args:
            base: Base configuration
            override: Override configuration
            
        Returns:
            Merged configuration
        """
        result = base.copy()
        
        for key, value in override.items():
            if key in result and isinstance(result[key], dict) and isinstance(value, dict):
                result[key] = MonitorConfig._merge_configs(result[key], value)
            else:
                result[key] = value
        
        return result
    
    def override_from_env(self) -> None:
        """Override configuration from environment variables."""
        # Example: FLOW_MONITOR_POLL_INTERVAL=0.05
        prefix = "FLOW_MONITOR_"
        
        # Shared memory
        if poll := os.getenv(f"{prefix}POLL_INTERVAL"):
            self.shared_memory.poll_interval = float(poll)
        
        # Flow database
        if db_path := os.getenv(f"{prefix}DATABASE_PATH"):
            self.flow_database.database_path = db_path
        
        # Output
        if output_dest := os.getenv(f"{prefix}OUTPUT_DEST"):
            self.output.destination = output_dest
        
        if output_fmt := os.getenv(f"{prefix}OUTPUT_FORMAT"):
            self.output.format = output_fmt
        
        # Logging
        if log_level := os.getenv(f"{prefix}LOG_LEVEL"):
            self.logging.level = log_level.upper()
    
    def validate(self) -> None:
        """
        Validate configuration.
        
        Raises:
            ValueError: If configuration is invalid
        """
        # Validate flow database path is set
        if not self.flow_database.database_path:
            raise ValueError("flow_database.database_path must be set")
        
        # Validate shared memory directory exists
        if not Path(self.shared_memory.shm_dir).exists():
            raise ValueError(f"Shared memory directory not found: {self.shared_memory.shm_dir}")
        
        # Validate poll interval
        if self.shared_memory.poll_interval <= 0:
            raise ValueError("poll_interval must be positive")
        
        # Validate output format
        if self.output.format not in ["json", "jsonl"]:
            raise ValueError(f"Invalid output format: {self.output.format}")
        
        # Validate log level
        valid_levels = ["DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"]
        if self.logging.level.upper() not in valid_levels:
            raise ValueError(f"Invalid log level: {self.logging.level}")
