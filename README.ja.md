# dev-toolbox

[English](README.md) | 日本語

再利用可能な開発者向けツールを管理するための軽量リポジトリです。

このリポジトリは、`bin/` にフラットに置くのではなく、ツール単位で構成します。  
各ツールは必要に応じて、スクリプト、Dockerfile、ツール固有のメモを持てます。

## 目的

- 実用的なユーティリティツールを1箇所で管理する
- ファイル種別ではなくツール名で整理する
- 各ツールが必要なものだけを持つ

## ディレクトリ構成

```text
tools/
  codex-notify/
    README.md
    codex-notify
  name-audit/
    README.md
    name_audit
    Dockerfile
```

## 使い方

- `./tools/codex-notify/codex-notify "<payload>"`
- `./tools/name-audit/name_audit <candidate...>`

## ツール別ドキュメント

- `tools/codex-notify/README.md`
- `tools/name-audit/README.md`

## ルール

- `tools/` 配下は「1ツール1ディレクトリ」
- 実行エントリポイントはツールディレクトリでバージョン管理する
- コンテナ実行が必要なツールだけ `Dockerfile` を置く
