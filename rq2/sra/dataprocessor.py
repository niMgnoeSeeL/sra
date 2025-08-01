import time
from typing import List

import os
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib import pyplot as plt

from sra import estimator, estimator_cum, mestimator


def get_statistics(num_arr: np.ndarray):
    mean_val = np.mean(num_arr)
    std_val = np.std(num_arr)
    min_val = np.min(num_arr)
    max_val = np.max(num_arr)
    quantiles = pd.DataFrame(num_arr).quantile(
        [0.01] + [1 / 20 * i for i in range(1, 20)] + [0.99]
    )
    print(f"mean: {mean_val}, std: {std_val}, min: {min_val}, max: {max_val}")
    print(f"quantiles:\n{quantiles}")


def calc_log_error(esti, GT):
    return np.abs(np.log10(esti) - np.log10(GT))


################################################################################
#                            total frac strategy
################################################################################


def gen_total_frac_trial(
    cov_data, target_idx, entry_idx: int = None
) -> np.ndarray:
    sum_data = np.sum(cov_data, axis=0)
    if not entry_idx:
        total_obs = np.max(sum_data)
    else:
        total_obs = sum_data[entry_idx]
    frac_cov = sum_data / total_obs
    target_prob = frac_cov[target_idx]
    print(f"GT={target_prob}")
    trial_length = np.ceil(1 / target_prob) - 1
    frac_cov_T = frac_cov.reshape(-1, 1)
    one_row_memory = frac_cov_T.size * frac_cov_T.itemsize
    row_for_1gb = np.ceil(1024 * 1024 * 1024 / one_row_memory)
    num_split = np.floor(trial_length / row_for_1gb)
    if num_split > 0:
        # create generator
        total_range = np.array(range(1, int(trial_length) + 1))
        split_range = np.array_split(total_range, num_split)
        first_mat = np.floor(
            np.matmul(frac_cov_T, split_range[0].reshape(1, -1))
        ).T
        for split_idx in range(len(split_range)):
            yield (
                np.floor(
                    np.matmul(frac_cov_T, split_range[split_idx].reshape(1, -1))
                ).T,
                target_prob,
                num_split,
            )
    else:
        yield (
            np.floor(
                np.matmul(
                    frac_cov_T,
                    np.array(range(1, int(trial_length) + 1)).reshape(1, -1),
                )
            ).T,
            target_prob,
            num_split,
        )


def laplace_estimation_for_total_frac(cum_covs):
    return (cum_covs + 2) / np.max(cum_covs + 4, axis=1)[:, None]


def goodturing_estimation_for_total_frac(
    cum_covs, know_unobserved: bool = False
):
    maxs = np.max(cum_covs, axis=1)
    unobserved = []
    singleton = []
    for seq in cum_covs:
        cnt_dict = dict(zip(*np.unique(seq, return_counts=True)))
        singleton.append(cnt_dict.get(1, 0))
        unobserved.append(cnt_dict.get(0, 0))
    singleton = np.array(singleton)
    unobserved = np.array(unobserved)
    if know_unobserved:
        return singleton / maxs / unobserved
    else:
        return singleton / maxs


def total_frac_strategy(
    target_node: str,
    non_minus_cov_data_o: np.ndarray,
    observable_nodes: List[str],
    graph: estimator.Graph,
    save_dirpath: str,
    mlv: bool = False,
    entry_node: str = None,
    prefix: str = "",
    debug: bool = False,
):
    """
    [Input]
    non_minus_cov_data_o: observable node hit count data that is converted from the fuzzing hit count data.
    target_node: node of interest

    [Output]
    Ground truth probability,
    A single trial hit count data,
    Laplace smoothing estimation data,
    Structure-aware estimiation data
    """
    target_idx = observable_nodes.index(target_node)
    entry_idx = observable_nodes.index(entry_node) if entry_node else None

    (
        lap_esti_df_list,
        gt_esti_df_list,
        gt_unob_esti_df_list,
        struct_esti_df_list,
    ) = ([], [], [], [])
    struct_times = []
    for partial_idx, (total_frac_trial_partial, GT, num_split) in enumerate(
        gen_total_frac_trial(
            non_minus_cov_data_o, target_idx, entry_idx=entry_idx
        )
    ):
        if num_split >= 60 and partial_idx > num_split // 10:
            print(f"{partial_idx=}. Stop here.")
            break
        print(f"{partial_idx=}, {total_frac_trial_partial.shape=}")
        os.makedirs(save_dirpath, exist_ok=True)
        np.save(
            os.path.join(
                save_dirpath,
                prefix + "_" + f"total_frac_trial_{partial_idx}.npy",
            ),
            total_frac_trial_partial,
        )

        lap_esti = laplace_estimation_for_total_frac(total_frac_trial_partial)
        lap_esti_data = [
            (
                idx + 1,
                lap_esti[idx, target_idx],
                calc_log_error(lap_esti[idx, target_idx], GT),
            )
            for idx in range(len(lap_esti))
        ]
        lap_esti_df = pd.DataFrame(
            lap_esti_data, columns=["unit", "esti", "re"]
        )
        lap_esti_df_list.append(lap_esti_df)

        gt_esti = goodturing_estimation_for_total_frac(total_frac_trial_partial)
        gt_esti_data = [
            (idx + 1, gt_esti[idx], calc_log_error(gt_esti[idx], GT))
            for idx in range(len(gt_esti))
        ]
        gt_esti_df = pd.DataFrame(gt_esti_data, columns=["unit", "esti", "re"])
        gt_esti_df_list.append(gt_esti_df)

        gt_unob_esti = goodturing_estimation_for_total_frac(
            total_frac_trial_partial, know_unobserved=True
        )
        gt_unob_esti_data = [
            (idx + 1, gt_unob_esti[idx], calc_log_error(gt_unob_esti[idx], GT))
            for idx in range(len(gt_unob_esti))
        ]
        gt_unob_esti_df = pd.DataFrame(
            gt_unob_esti_data, columns=["unit", "esti", "re"]
        )
        gt_unob_esti_df_list.append(gt_unob_esti_df)

        struct_esti_data = []
        for idx in range(len(total_frac_trial_partial)):
            if debug:
                print(f"{idx=}")
            start_time = time.time()
            if not mlv:
                esti, dist, maxcov = estimator_cum.structure_estimation(
                    total_frac_trial_partial[idx],
                    graph,
                    target_node,
                    observable_nodes,
                    2,
                )
            else:
                esti, dist, maxcov = mestimator.structure_estimation(
                    total_frac_trial_partial[idx],
                    graph,
                    target_node,
                    observable_nodes,
                    2,
                    option="cum",
                )
            struct_times.append(time.time() - start_time)
            struct_esti_data.append(
                (idx + 1, esti, dist, maxcov, calc_log_error(esti, GT))
            )
        struct_esti_df = pd.DataFrame(
            struct_esti_data, columns=["unit", "esti", "dist", "maxcov", "re"]
        )
        struct_esti_df_list.append(struct_esti_df)

    lap_esti_df = pd.concat(lap_esti_df_list, ignore_index=True)
    lap_esti_df["unit"] = lap_esti_df.index + 1
    gt_esti_df = pd.concat(gt_esti_df_list, ignore_index=True)
    gt_esti_df["unit"] = gt_esti_df.index + 1
    gt_unob_esti_df = pd.concat(gt_unob_esti_df_list, ignore_index=True)
    gt_unob_esti_df["unit"] = gt_unob_esti_df.index + 1
    struct_esti_df = pd.concat(struct_esti_df_list, ignore_index=True)
    struct_esti_df["unit"] = struct_esti_df.index + 1

    print(f"{np.mean(struct_times)=}")

    return GT, lap_esti_df, gt_esti_df, gt_unob_esti_df, struct_esti_df


def total_frac_save_data(
    dirpath,
    GT,
    lap_esti_df,
    struct_esti_df,
):
    os.makedirs(dirpath, exist_ok=True)
    with open(os.path.join(dirpath, "GT.txt"), "w") as f:
        f.write(str(GT))
    lap_esti_df.to_csv(os.path.join(dirpath, "lap_esti_df.csv"), index=False)
    struct_esti_df.to_csv(
        os.path.join(dirpath, "struct_esti_df.csv"), index=False
    )


def total_frac_draw_graph(
    GT, lap_esti_df, gt_esti_df, gt_unob_esti_df, struct_esti_df
):
    # sourcery skip: extract-duplicate-method
    lap_esti_df["tool"] = "Lap"
    gt_esti_df["tool"] = "GT"
    gt_esti_df = gt_esti_df.loc[gt_esti_df["re"] != np.inf]
    gt_unob_esti_df["tool"] = "GT_unob"
    gt_unob_esti_df = gt_unob_esti_df.loc[gt_unob_esti_df["re"] != np.inf]
    struct_esti_df["tool"] = "Struct"
    esti_df = pd.concat(
        (
            lap_esti_df,
            gt_esti_df,
            gt_unob_esti_df,
            struct_esti_df[["unit", "esti", "re", "tool"]],
        )
    )
    fig, axes = plt.subplots(2, 2, figsize=(20, 10))
    sns.pointplot(
        data=esti_df, x="unit", y="re", hue="tool", ax=axes[0, 0], scale=0.5
    )
    axes[0, 0].set_title("Mean relative error (log)")
    axes[0, 0].set_xlabel("unit")
    axes[0, 0].set_ylabel("(log(esti) - log(GT)) / log(GT)")
    sns.pointplot(
        data=esti_df, x="unit", y="esti", hue="tool", ax=axes[1, 0], scale=0.5
    )
    axes[1, 0].axhline(GT, color="black", linestyle="--")
    axes[1, 0].set_title("Estimation")
    axes[1, 0].set_xlabel("unit")
    axes[1, 0].set_ylabel("esti")
    max_unit = esti_df["unit"].max()
    sub_esti_df = esti_df[esti_df["unit"] <= max_unit / 10]
    sns.pointplot(
        data=sub_esti_df, x="unit", y="re", hue="tool", ax=axes[0, 1], scale=0.5
    )
    axes[0, 1].set_title("Mean relative error (log)")
    axes[0, 1].set_xlabel("unit")
    axes[0, 1].set_ylabel("(log(esti) - log(GT)) / log(GT)")
    sns.pointplot(
        data=sub_esti_df,
        x="unit",
        y="esti",
        hue="tool",
        ax=axes[1, 1],
        scale=0.5,
    )
    axes[1, 1].axhline(GT, color="black", linestyle="--")
    axes[1, 1].set_title("Estimation")
    axes[1, 1].set_xlabel("unit")
    axes[1, 1].set_ylabel("esti")
    return fig, axes


def strat4_save_data(
    dirpath,
    GT_stat,
    lap_esti_df,
    gt_esti_df,
    gt_unob_esti_df,
    struct_esti_df,
    option,
):
    # sourcery skip: extract-method
    os.makedirs(dirpath, exist_ok=True)
    with open(os.path.join(dirpath, f"{option}_GT.txt"), "w") as f:
        f.write(f"total_obs: {GT_stat[0]}\n")
        f.write(f"target_obs: {GT_stat[1]}\n")
        f.write(f"GT: {GT_stat[2]}\n")
        f.write(f"total_remaining: {GT_stat[3]}\n")
        f.write(f"target_remaining: {GT_stat[4]}\n")
        f.write(f"prob remaining: {GT_stat[5]}\n")
    lap_esti_df.to_csv(
        os.path.join(dirpath, f"{option}_lap_esti_df.csv"), index=False
    )
    gt_esti_df.to_csv(
        os.path.join(dirpath, f"{option}_gt_esti_df.csv"), index=False
    )
    gt_unob_esti_df.to_csv(
        os.path.join(dirpath, f"{option}_gt_unob_esti_df.csv"), index=False
    )
    struct_esti_df.to_csv(
        os.path.join(dirpath, f"{option}_struct_esti_df.csv"), index=False
    )
