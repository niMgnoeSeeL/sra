import json
import os
from typing import List, Tuple
import numpy as np
import pandas as pd


def get_trial_paths(run_path: str) -> List[str]:
    return sorted(
        [
            os.path.join(run_path, d)
            for d in os.listdir(run_path)
            if "aflpp" in d
        ],
        key=lambda x: int(x.split("_")[-1]),
    )


def get_cov_cum(coverage_file: str) -> List[int]:
    return json.loads(open(coverage_file, "r").read())["block_coverage"]


def get_covs_cum_trial(trial_path: str) -> np.ndarray:
    covs_path = os.path.join(trial_path, "coverage")
    cov_files = sorted(
        os.listdir(covs_path),
        key=lambda fname: float(fname.split("_")[-1][:-5]),
    )
    covs_cum = [
        get_cov_cum(os.path.join(covs_path, cov_file)) for cov_file in cov_files
    ]
    return np.array(covs_cum)


def get_covs_trial(
    trial_path: str, expected_time_interval: Tuple[int] = (0, 2)
) -> np.ndarray:
    covs_path = os.path.join(trial_path, "coverage")
    cov_files = sorted(
        os.listdir(covs_path),
        key=lambda fname: float(fname.split("_")[-1][:-5]),
    )
    covs = []
    skipped = 0
    for i in range(1, len(cov_files)):
        prev = cov_files[i - 1]
        curr = cov_files[i]
        prev_time = float(prev.split("_")[-1][:-5])
        curr_time = float(curr.split("_")[-1][:-5])
        if not (
            curr_time > prev_time
            and expected_time_interval[0]
            < curr_time - prev_time
            <= expected_time_interval[1]
        ):
            print("DEBUG: Time interval", curr_time - prev_time)
            print(
                f"{prev=} and {curr=} are not in expected time interval. Skipping."
            )
            skipped += 1
            continue
        prev_cov_cum = get_cov_cum(os.path.join(covs_path, prev))
        curr_cov_cum = get_cov_cum(os.path.join(covs_path, curr))
        covs.append(np.array(curr_cov_cum) - np.array(prev_cov_cum))
    if skipped > 0:
        print(f"Skipped {skipped}/{len(cov_files) - 1} data points.")
    return np.array(covs)


def get_covss_cum(run_path) -> List[np.ndarray]:
    trial_paths = get_trial_paths(run_path)
    return [get_covs_cum_trial(trial_path) for trial_path in trial_paths]


def get_run_paths(runs_path: str, projname: str) -> List[str]:
    return [
        os.path.join(runs_path, d)
        for d in os.listdir(runs_path)
        if d.startswith(f"{projname}_") and not d.endswith(".csv")
    ]


def get_num_obs_df(
    projname: str, runs_path: str, expected_time_interval: Tuple[int] = (0, 2)
) -> pd.DataFrame:
    # sourcery skip: for-append-to-extend, inline-variable
    run_paths = get_run_paths(runs_path, projname)
    num_obs_data = []
    for run_path in run_paths:
        run_id = int(os.path.basename(run_path).split("_")[-1])
        for trial_path in get_trial_paths(run_path):
            trial_id = int(os.path.basename(trial_path).split("_")[-1])
            covs = get_covs_trial(trial_path, expected_time_interval)
            for datapoint_id, cov in enumerate(covs, 1):
                num_obs = max(cov)
                num_obs_data.append((run_id, trial_id, datapoint_id, num_obs))
    return pd.DataFrame(
        num_obs_data, columns=["run_id", "trial_id", "datapoint_id", "num_obs"]
    )


def get_num_obs_statistics(num_obs_df: pd.DataFrame):
    mean = num_obs_df["num_obs"].mean()
    std = num_obs_df["num_obs"].std()
    quantiles = num_obs_df["num_obs"].quantile(
        [1 / 20 * i for i in range(1, 20)]
    )
    print(f"mean: {mean}, std: {std}")
    print(f"quantiles:\n{quantiles}")


def get_covs_runs(
    projname: str,
    runs_path: str,
    threshold: int,
    expected_time_interval: Tuple[int] = (0, 2),
    seed: int = 0,
) -> np.ndarray:
    # sourcery skip: for-append-to-extend, inline-variable
    run_paths = get_run_paths(runs_path, projname)
    covs = []
    for run_path in run_paths:
        for trial_path in get_trial_paths(run_path):
            covs_trial = get_covs_trial(trial_path, expected_time_interval)
            for cov in covs_trial:
                if max(cov) > threshold:
                    covs.append(cov)
    covs = np.array(covs)
    np.random.seed(seed)
    np.random.shuffle(covs)
    return covs


if __name__ == "__main__":
    print("Data loading for a single run.")
    run_path = "converter/tcas_short_runs/tcas_01"
    covss_cum = get_covss_cum(run_path)
    print(f"{len(covss_cum)=}")
    for covs_cum in covss_cum:
        print(f"{covs_cum.shape=}")
    print()

    print("Data loading for all runs, and redistribute the data.")
    projname = "tcas"
    runs_path = "converter/tcas_short_runs"
    num_obs_df = get_num_obs_df(projname, runs_path)
    print("num obs per datapoint:")
    print(num_obs_df)
    get_num_obs_statistics(num_obs_df)
    threshold = 65
    print(f"threshold: {threshold}")
    covs = get_covs_runs(projname, runs_path, threshold)
    print(f"datapoints with num obs > {threshold}: {len(covs)}")
