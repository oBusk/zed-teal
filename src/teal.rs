use zed_extension_api::{self as zed, LanguageServerId, Result};

const SERVER_BINARY: &str = "teal-language-server";

struct TealExtension;

impl zed::Extension for TealExtension {
    fn new() -> Self {
        TealExtension
    }

    /// Tells Zed which command to run for the language server.
    ///
    /// Zed handles `lsp.teal-language-server.binary` (`path`, `arguments`,
    /// `env`) and `initialization_options` itself: if `binary.path` is set,
    /// this isn't called at all. Otherwise we look up `teal-language-server` on
    /// the worktree's PATH (on Windows this also finds
    /// `teal-language-server.bat`, via PATHEXT).
    fn language_server_command(
        &mut self,
        _language_server_id: &LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let command = worktree.which(SERVER_BINARY).ok_or_else(|| {
            format!(
                "`{SERVER_BINARY}` not found on PATH. Install it \
                 (https://github.com/teal-language/teal-language-server#installation) \
                 or set `lsp.{SERVER_BINARY}.binary.path` in your Zed settings."
            )
        })?;

        Ok(zed::Command {
            command,
            args: Vec::new(),
            env: Vec::new(),
        })
    }
}

zed::register_extension!(TealExtension);
