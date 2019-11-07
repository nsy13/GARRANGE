# GArrange

複数人でのスケジューリングを支援するカレンダーアプリケーションです。  
https://garrange.herokuapp.com/

## 使用した技術

- デプロイ
    - heroku
- テスト
    - RSpec
- カレンダー
    - fullcalendar-rails
- 検索
    - ransack
- 通知機能
- ユーザー認証
    - Devise
    - Googleログイン
    - Facebookログイン
- DB
    - PostgreSQL
- ページネーション
    - kaminari
- デザイン
    - bootstrap
    - font-awesome-rails
- 非同期通信

## 概要

スケジュール管理のためのアプリケーションは数多くありますが、  
会議等を設定する際には、数人のスケジュールの空きを一人ずつ確認する必要がありました。  
GArrangeはそんな無駄な時間を削減したいという思いから生まれた、  
複数人のスケジューリングを支援するサービスです。

## 機能

- カレンダーの作成
- イベントの作成と参加者の招待
- 空き時間の検索
- カレンダーの共有
- ユーザー検索
- 招待通知機能

## Requirement

ruby 2.5.6  
rails 5.2.3