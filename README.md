# PromptManager

ChatGPTで使用するプロンプトを効率的に管理するためのmacOSアプリケーションです。

## プロジェクト概要

PromptManagerは、テキストプロンプトの保存、整理、検索、クリップボードへの高速コピーを可能にするmacOSアプリケーションです。グローバルキーボードショートカット（Ctrl+D）、ステータスバーメニュー、専用アプリケーションウィンドウの複数のエントリーポイントを通じてユーザーがシステムと対話できます。

対象ユーザーは、繰り返し使用するテキストコンテンツを頻繁に扱う専門職の方々です：
- コードスニペットを管理する開発者
- 応答テンプレートを使用するカスタマーサービス担当者
- 再利用可能なテキストブロックを整理するコンテンツクリエイター

## 実装機能一覧

### 🚀 コア機能
- **プロンプトの作成・編集・削除**: 名前、タグ、コンテンツを含むプロンプトの完全なCRUD操作
- **タグベースフィルタリング**: タグによるプロンプトの分類と絞り込み表示
- **全文検索**: 名前、タグ、コンテンツ全体での大文字小文字を区別しない検索
- **ワンクリックコピー**: プロンプトをクリックするだけでクリップボードに即座にコピー
- **視覚的フィードバック**: コピー操作時の「Copied!」表示によるユーザーフィードバック

### ⌨️ システム統合
- **グローバルキーボードショートカット**: Ctrl+Dでアプリを瞬時に起動
- **ステータスバー統合**: メニューバーからの常時アクセス
- **マルチモニター対応**: カーソル位置のスクリーンを検出して適切にウィンドウを配置
- **ウィンドウ管理**: 画面右端への自動配置とオーバーレイ表示

### 💾 データ管理
- **JSON永続化**: Application Supportディレクトリへの自動データ保存
- **リアルタイム同期**: 変更の即座な保存と反映
- **データ整合性**: エラーハンドリングによる安全なファイル操作

## ディレクトリ構成

```
PromptManager/
├── PromptManager/                    # メインアプリケーションソース
│   ├── Models/                      # データ構造定義
│   │   └── PromptItem.swift         # プロンプトデータモデル
│   ├── ViewModels/                  # ビジネスロジック層
│   │   └── PromptListViewModel.swift # メイン状態管理・ビジネスロジック
│   ├── Views/                       # SwiftUI UIコンポーネント
│   │   ├── Sidebar/                 # メインプロンプト管理インターフェース
│   │   │   ├── PromptListView.swift # プロンプト一覧表示・検索UI
│   │   │   └── PromptRegisterView.swift # プロンプト作成・編集フォーム
│   │   └── DefaultUI/               # メニューバー・補助インターフェース
│   │       └── MenuBarExtraView.swift # ステータスバードロップダウン用コンパクトUI
│   ├── Services/                    # データ永続化層
│   │   └── PromptStorageService.swift # JSON永続化サービス
│   ├── Managers/                    # システム統合サービス
│   │   └── ShortcutManager.swift    # グローバルキーボードショートカット管理
│   ├── PromptManagerApp.swift       # SwiftUIアプリケーションエントリーポイント
│   ├── AppDelegate.swift            # アプリケーションライフサイクル・ステータスバー・ウィンドウ管理
│   ├── CustomWindow.swift           # キーウィンドウ動作用カスタムNSWindowサブクラス
│   ├── ContentView.swift            # 基本ビューコンポーネント
│   ├── Constants.swift              # アプリケーション定数
│   ├── Info.plist                   # アプリケーション設定
│   └── PromptManager.entitlements   # macOSアプリケーション権限設定
├── PromptManager.xcodeproj/          # Xcodeプロジェクトファイル
├── PromptManagerTests/               # 単体テスト
└── PromptManagerUITests/             # UIテスト
```

## ファイル詳細

### 🏗️ アプリケーション基盤

#### `PromptManagerApp.swift`
- SwiftUIアプリケーションのメインエントリーポイント
- `@NSApplicationDelegateAdaptor`でAppDelegateと統合
- 設定画面の定義（現在は空のビュー）

#### `AppDelegate.swift`
- アプリケーションライフサイクル管理
- ステータスバーアイテムの設定と管理
- グローバルショートカットの登録
- メインウィンドウの作成・配置・表示制御
- マルチモニター環境でのウィンドウ位置調整

#### `CustomWindow.swift`
- `NSWindow`のカスタムサブクラス
- `canBecomeKey`プロパティをオーバーライドしてキーウィンドウとして機能

### 📊 データ層

#### `Models/PromptItem.swift`
- プロンプトの基本データ構造
- `Identifiable`と`Codable`プロトコルに準拠
- プロパティ: `id`（UUID）、`name`、`tag`、`content`

#### `Services/PromptStorageService.swift`
- シングルトンパターンによるデータ永続化サービス
- Application SupportディレクトリへのJSON形式での保存
- プロンプトの読み込み・保存・削除機能
- エラーハンドリングとディレクトリ自動作成

### 🧠 ビジネスロジック層

#### `ViewModels/PromptListViewModel.swift`
- `ObservableObject`プロトコルに準拠したメイン状態管理クラス
- プロンプトコレクションの管理（CRUD操作）
- 検索テキストとタグによるフィルタリング機能
- クリップボード操作の実装
- ドラッグ&ドロップによるプロンプト並び替え

### 🎨 UI層

#### `Views/Sidebar/PromptListView.swift`
- メインプロンプト管理インターフェース
- 検索可能なプロンプト一覧表示
- タグフィルタリングボタン
- 新規プロンプト作成ボタン
- 個別プロンプトカード（`PromptCardView`）
- 展開/折りたたみ機能付きコンテンツ表示

#### `Views/Sidebar/PromptRegisterView.swift`
- プロンプト作成・編集用モーダルフォーム
- 名前、タグ、コンテンツの入力フィールド
- 作成/更新/削除操作
- バリデーション機能

#### `Views/DefaultUI/MenuBarExtraView.swift`
- ステータスバードロップダウン用のコンパクトインターフェース
- `PromptListView`をラップして表示

### ⚙️ システム統合

#### `Managers/ShortcutManager.swift`
- グローバルキーボードショートカット（Ctrl+D）の管理
- Core Graphicsイベントタップを使用したシステムレベルキー監視
- C関数ポインタ制約に対応したstatic関数実装
- ショートカットの登録・無効化機能

## アーキテクチャ

### 🏛️ 設計パターン
- **MVVM（Model-View-ViewModel）**: 明確な責任分離による保守性の向上
- **シングルトンパターン**: ストレージサービスとショートカットマネージャーで使用
- **オブザーバーパターン**: SwiftUIの`@Published`と`@ObservedObject`による状態管理

### 🔧 技術スタック
- **SwiftUI**: モダンなUI構築フレームワーク
- **AppKit**: macOSシステム統合（ステータスバー、ウィンドウ管理、グローバルショートカット）
- **Core Graphics**: 低レベルキーボードイベント処理
- **Foundation**: JSON永続化とファイル管理

### 📊 データフロー
1. **初期化**: `PromptManagerApp`が`AppDelegate`を作成し、ステータスバーとショートカットを設定
2. **ユーザー操作**: グローバルショートカットまたはステータスバーメニューが`togglePromptWindow()`をトリガー
3. **UI描画**: `PromptListView`が`PromptListViewModel.filteredPrompts`からプロンプトを表示
4. **データ操作**: ユーザーアクションがViewModelを通じて`PromptStorageService`に流れて永続化
5. **システム統合**: クリップボード操作とウィンドウ配置が各マネージャーで処理

## データ永続化

### 📁 保存場所
```
~/Library/Application Support/PromptManager/prompts.json
```

### 📋 データ形式
```json
[
  {
    "id": "UUID文字列",
    "name": "プロンプト名",
    "tag": "タグ名",
    "content": "プロンプトの内容"
  }
]
```

## 使用方法

### 🚀 起動方法
1. **グローバルショートカット**: `Ctrl + D`
2. **ステータスバー**: メニューバーのアイコンをクリック

### ✏️ プロンプト管理
1. **新規作成**: 「＋ 新規プロンプトを追加」をクリック
2. **編集**: プロンプトカードの「編集」ボタンをクリック
3. **削除**: 編集画面でゴミ箱アイコンをクリック
4. **コピー**: プロンプトカードをクリックして即座にクリップボードにコピー

### 🔍 検索・フィルタリング
1. **タグフィルター**: 上部のタグボタンをクリックして絞り込み
2. **テキスト検索**: 検索フィールドに文字を入力して全文検索
3. **全表示**: 「すべて」ボタンでフィルターをクリア

## 開発環境

- **言語**: Swift 5.x
- **フレームワーク**: SwiftUI + AppKit
- **対象OS**: macOS 11.0+
- **開発環境**: Xcode 13.0+

## ライセンス

このプロジェクトのライセンス情報については、プロジェクト所有者にお問い合わせください。
