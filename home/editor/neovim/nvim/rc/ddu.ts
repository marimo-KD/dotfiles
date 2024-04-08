import {
  ActionArguments,
  ActionFlags,
  BaseConfig,
  Ddu,
} from "https://deno.land/x/ddu_vim@v3.10.2/types.ts";
import { Denops, fn } from "https://deno.land/x/ddu_vim@v3.10.2/deps.ts";
import * as opt from "https://deno.land/x/denops_std@v6.0.1/option/mod.ts";
import { ConfigArguments } from "https://deno.land/x/ddu_vim@v3.10.2/base/config.ts";
import { ActionData } from "https://deno.land/x/ddu_kind_file@v0.7.1/file.ts";
import { Params as FfParams } from "https://deno.land/x/ddu_ui_ff@v1.1.0/ff.ts";
import { Params as FilerParams } from "https://deno.land/x/ddu_ui_filer@v1.1.0/filer.ts";

type Params = Record<string, unknown>;

async function uiSize(denops: Denops): Promise<Partial<FfParams | FilerParams>> {
  const winCol = await opt.columns.get(denops);
  const winRow = await opt.lines.get(denops);
  const winWidth = Math.floor(winCol * 0.95);
  const winHeight = Math.floor(winRow * 0.8);

  const mayVsplit = winCol >= 50;

  return {
    previewSplit: mayVsplit ? "vertical" : "horizontal",
    filterUpdateTime: 0,
    winHeight: winHeight,
    winWidth: winWidth,
    winRow: 3,
    winCol: 5,
    previewWidth: mayVsplit ? Math.floor(winWidth / 2) : winWidth,
    previewHeight: mayVsplit ? winHeight : Math.floor(winHeight / 1.5),
  } as Partial<FfParams | FilerParams>;
}


export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    args.setAlias("column", "icon_filename_ff", "icon_filename")
    args.setAlias("source", "file_ff", "file")

    args.contextBuilder.patchGlobal({
      ui: "ff",
      profile: false,
      uiOptions: {
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: { 
          ...{
            autoAction: {
              name: "preview",
            },
            startAutoAction: true,
            displaySourceName: "long",
            filterFloatingPosition: "top",
            filterSplitDirection: "floating",
            floatingBorder: "rounded",
            floatingTitlePos: "center",
            maxHighlightItems: 50,
            onPreview: async (args: {
              denops: Denops;
              previewWinId: number;
            }) => {
              await fn.win_execute(args.denops, args.previewWinId, "normal! zz");
            },
            previewFloating: true,
            previewFloatingBorder: "rounded",
            previewFloatingTitlePos: "center",
            prompt: ">",
            split: "floating",
          },
          ...await uiSize(args.denops)
        } as Partial<FfParams>,
        filer: {
          ...{
            floatingBorder: "rounded",
            previewFloating: true,
            previewFloatingBorder: "rounded",
            sort: "filename",
            sortTreesFirst: true,
            split: "floating",
            toggle: true,
          },
          ...await uiSize(args.denops)
        } as Partial<FilerParams>,
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_fzf"],
          sorters: ["sorter_fzf"],
          smartCase: true,
        },
        file_old: {
          matchers: [
            "matcher_zf",
            "matcher_kensaku",
          ],
          converters: ["converter_hl_dir"],
          columns: ["icon_filename_ff"],
        },
        file_rec: {
          matchers: [
            "matcher_zf",
            "matcher_kensaku",
          ],
          converters: ["converter_hl_dir"],
          columns: ["icon_filename_ff"],
        },
        file: {
          matchers: [
            "matcher_hidden",
          ],
          converters: ["converter_hl_dir"],
          columns: ["icon_filename"],
        },
        line: {
          matchers: ["matcher_substring", "matcher_kensaku"],
        },
        dein: {
          defaultAction: "cd",
        },
      },
      sourceParams: {
        rg: {
          args: [
            "--ignore-case",
            "--column",
            "--no-heading",
            "--color",
            "never",
          ],
        },
      },
      filterParams: {
        converter_hl_dir: {
          hlGroup: ["Directory", "Keyword"],
        },
        matcher_kensaku: {
          highlightMatched: 'Search',
        }
      },
      kindOptions: {
        action: {
          defaultAction: "do",
        },
        deol: {
          defaultAction: "switch",
        },
        file: {
          defaultAction: "open",
          actions: {
            grep: async (args: ActionArguments<Params>) => {
              const action = args.items[0]?.action as ActionData;

              await args.denops.call("ddu#start", {
                name: args.options.name,
                push: true,
                sources: [
                  {
                    name: "rg",
                    params: {
                      path: action.path,
                      input: await fn.input(args.denops, "Pattern: "),
                    },
                  },
                ],
              });

              return Promise.resolve(ActionFlags.None);
            },
          },
        },
        help: {
          defaultAction: "vsplit",
        },
        lsp: {
          defaultAction: "open",
        },
        lsp_codeAction: {
          defaultAction: "apply",
        },
        source: {
          defaultAction: "execute",
        },
        url: {
          defaultAction: "browse",
        },
        word: {
          defaultAction: "append",
        },
      },
      kindParams: {},
      columnParams: {
        icon_filename_ff: {
          pathDisplayOption: "relative",
          padding: 0,
        }
      },
      actionOptions: {
        narrow: {
          quit: false,
        },
        tabopen: {
          quit: false,
        },
      },
    });

    return Promise.resolve();
  }
}
