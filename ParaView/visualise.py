#!/usr/bin/env pvbatch
from __future__ import annotations

import argparse
import json
import logging
from pathlib import Path
from sys import version_info
from typing import Callable

import paraview.simple as pv

LOGGING_FORMAT = "[foamio:%(levelname)s] (called at %(asctime)s) %(message)s"


def _load(args: argparse.Namespace) -> pv.ViewLayout:
    """https://www.paraview.org/paraview-docs/latest/python/paraview.simple.html#paraview.simple.LoadState"""

    logging.info(f"loading {args.state=} at {args.case=}")
    pv.LoadState(
        str(args.state),
        data_directory=str(args.case) if not args.case is None else None,
    )
    return pv.GetLayout()


def add_args(parser: argparse.ArgumentParser, pv_func: Callable) -> None:
    parser.add_argument(
        "out",
        metavar="OUT",
        help=f"output file for {pv_func.__name__}",
        type=Path,
    )
    parser.add_argument(
        "--layout",
        action="store_true",
        help="save all views",
    )
    parser.add_argument(
        "--dict",
        type=Path,
        metavar="JSON",
        help=f"dictionary file with any `{pv_func.__name__}` keyword arguments",
    )


def timesteps(args: argparse.Namespace) -> list:
    _load(args)
    return pv.GetTimeKeeper().TimestepValues


def visualise(args: argparse.Namespace, pv_func: Callable) -> None:
    def get_kwargs(layout: pv.ViewLayout) -> dict:
        kwargs = {"viewOrLayout": layout} if args.layout else {}
        if not args.dict is None:
            with open(args.dict) as f:
                kwargs |= json.load(f)
                logging.info(f"{kwargs=}")
        return kwargs

    # Ensure that write directory exists
    args.out.parent.mkdir(parents=True, exist_ok=True)

    layout = _load(args)
    pv_func(str(args.out), **get_kwargs(layout))


def main() -> argparse.Namespace:
    parent_parser = argparse.ArgumentParser(
        description="CLI for ParaView states",
        epilog=f"froth pvbatch"
        f" [Python {version_info.major}.{version_info.minor}.{version_info.micro}]"
        "\nCopyright (c) 2023-2025 Stanislau Stasheuski",
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )

    parent_parser.add_argument(
        "-v",
        "--verbose",
        help="output information",
        action="store_const",
        dest="loglevel",
        const=logging.INFO,
    )

    parent_parser.add_argument(
        "-c",
        "--case",
        "--dir",
        type=Path,
        help="directory from where to load files"
        " https://www.paraview.org/paraview-docs/latest/python/paraview.simple.html#paraview.simple.LoadState",
    )

    parent_parser.add_argument(
        "state",
        type=Path,
        metavar="PVSM",
        help="path to ParaView state",
    )

    subparsers = parent_parser.add_subparsers(
        title="subcommands",
        dest="command",
        required=True,
    )

    #: TimestepValues {{{
    parser = subparsers.add_parser(
        "timesteps",
        help="output time-steps"
        "https://www.paraview.org/paraview-docs/latest/python/paraview.simple.html#paraview.simple.GetTimeKeeper",
    )
    parser.add_argument(
        "--list",
        action="store_true",
        help="suppress indices",
    )
    parser.set_defaults(
        func=lambda args: print(
            timesteps(args)
            if args.list
            else {i: time for i, time in enumerate(timesteps(args))}
        )
    )
    #: }}}

    #: SaveScreenshot {{{
    parser = subparsers.add_parser(
        "screenshot",
        aliases=["s"],
        help="https://www.paraview.org/paraview-docs/latest/python/paraview.simple.html#paraview.simple.SaveScreenshot",
    )
    add_args(parser, pv.SaveScreenshot)
    parser.set_defaults(func=lambda args: visualise(args, pv.SaveScreenshot))
    #: }}}

    #: SaveAnimation {{{
    parser = subparsers.add_parser(
        "animate",
        aliases=["a"],
        help="https://www.paraview.org/paraview-docs/latest/python/paraview.simple.html#paraview.simple.SaveAnimation",
    )
    add_args(parser, pv.SaveAnimation)
    parser.set_defaults(func=lambda args: visualise(args, pv.SaveAnimation))
    #: }}}

    args = parent_parser.parse_args()
    logging.basicConfig(level=args.loglevel, format=LOGGING_FORMAT)

    args.func(args)


if __name__ == "__main__":
    main()
