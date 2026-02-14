# codex-notify

Send iMessage notifications from Codex CLI.

## Example

Sent text:

> › Hi there Codex! I’m ready to work.

iMessage result:

<img width="1170" height="767" alt="image" src="https://github.com/user-attachments/assets/8c638018-8665-40a6-8649-7886615115d1" />

## Purpose

Use this script as a Codex CLI `notify` hook so you can check progress and final replies on your iPhone without staying on your Mac.

## Requirements

- macOS with Messages configured for iMessage
- `osascript` (built in on macOS)
- Optional: `jq` (recommended for JSON payload parsing)

## Setup example

This is one simple example:

1. Clone this repository.
2. Set the iMessage destination:

```bash
export CODEX_NOTIFY_TO="your-phone-number-or-apple-id"
```

3. Add the script path to your Codex CLI config file (for example `~/.codex/config.toml`):

```toml
notify = ["<your-cloned-path>/tools/codex-notify/codex-notify"]
```

`<your-cloned-path>` is the absolute path where you cloned `dev-toolbox`.

You can use any other invocation style as long as Codex CLI can execute the script.

## Behavior

- Reads notify payload from the first argument
- If payload is JSON, it only sends for `type = "agent-turn-complete"`
- Message body includes the latest user question and Codex response (not summarized)
- If payload is not JSON (or `jq` is unavailable), it sends raw text
- If `CODEX_NOTIFY_TO` is not set, it exits without sending

## Manual test

```bash
SCRIPT_PATH="<your-cloned-path>/tools/codex-notify/codex-notify"
CODEX_NOTIFY_TO="your-phone-number-or-apple-id" \
"$SCRIPT_PATH" \
'{"type":"agent-turn-complete","input-messages":["ping"],"last-assistant-message":"done","cwd":"/tmp/dev-toolbox","turn-id":"1"}'
```

## Notes

- Messages are sent through the currently signed-in Messages account.
- Make sure the recipient is reachable via iMessage on your Mac.
