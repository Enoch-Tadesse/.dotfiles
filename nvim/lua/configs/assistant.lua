return {

    mappings = {},
    commands = {
        python = {
            extension = "py",
            template = nil,
            compile = nil,
            execute = {
                main = "python3",
                args = { "$FILENAME_WITH_EXTENSION" },
            },
        },
        cpp = {
            extension = "cpp",
            template = nil,
            compile = {
                main = "g++",
                args = { "$FILENAME_WITH_EXTENSION", "-o", "$FILENAME_WITHOUT_EXTENSION" },
            },
            execute = {
                main = "./$FILENAME_WITHOUT_EXTENSION",
                args = nil,
            },
        },

        kotlin = {
            extension = "kt",
            template = nil,
            compile = {
                main = "sh",
                args = {
                    "-c",
                    "kotlinc $FILENAME_WITH_EXTENSION -include-runtime -d $FILENAME_WITHOUT_EXTENSION.jar",
                },
            },
            execute = {
                main = "java",
                args = {
                    "-jar",
                    "$FILENAME_WITHOUT_EXTENSION.jar",
                },
            },
        },

        rust = {
            extension = "rs",
            template = nil,
            compile = {
                main = "sh",
                args = {
                    "-c",
                    "rustc $FILENAME_WITH_EXTENSION -o $FILENAME_WITHOUT_EXTENSION ",
                },
            },
            execute = {
                main = "./$FILENAME_WITHOUT_EXTENSION",
                args = nil,
            },
        },
    },
    ui = {
        border = "single",
        diff_mode = false,
        title_components_separator = "",
    },
    core = {
        process_budget = 5000,
        port = 10043,
        filename_generator = nil,
    },
}
