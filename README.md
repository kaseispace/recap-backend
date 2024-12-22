# ReCap / 対話型振り返りシステム

![サイトのOGP画像](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/f7cc3e51-6797-703b-3150-e488300922fc.png)

## サービス概要

「**ReCap**」は、**教員と学生のための振り返り学習プラットフォーム**です。
**教育現場での利用**を想定しており、教員が作成したプロンプトに基づき、学生はチャット形式で対話を通じて振り返りを行います。**対話型の振り返り**は、学生が自分の考えを**自由に表現しやすい**という特徴があります。振り返りの内容がすべて提出された後には、**個別のフィードバック**を受け取ることができます。これにより、**学びを深め、新たな気づきを得るサポート**をしています。

### サービスURL

https://www.recaplearning.com/

### 紹介記事

https://qiita.com/kaseispace/items/e0c6c39baaebfbfc5de8

## 機能紹介 - 教員ページ

<table>
  <thead>
    <tr>
      <th>担当授業登録機能</th>
      <th>振り返りプロンプト作成機能</th>
    </tr>
  </thead>
  <tr>
    <td>
      <a href="https://gyazo.com/80f2525f4fe27ef8d31f9ff628aba7f5">
        <img
          src="https://i.gyazo.com/80f2525f4fe27ef8d31f9ff628aba7f5.gif"
          alt="担当授業登録"
          >
      </a>
    </td>
    <td>
      <a href="https://i.gyazo.com/9dec2b62bf8726765dce9c1e0f91f5c9">
        <img
          src="https://i.gyazo.com/9dec2b62bf8726765dce9c1e0f91f5c9.gif"
          alt="振り返りプロンプト作成"
          >
      </a>
    </td>
  </tr>
  <tr>
    <td>
      担当授業の登録を行ってください。<br>
      登録後、授業ページにてクラスコードが発行されます。
      このクラスコードを学生に共有してください。
    </td>
    <td>
      学生に振り返らせたいプロンプトの登録をしてください。<br>
      プロンプトは複数登録可能です。<br>
    </td>
  </tr>
</table>

<table>
  <thead>
    <tr>
      <th>振り返りプロンプト公開機能</th>
      <th>振り返りプレビュー機能</th>
    </tr>
  </thead>
  <tr>
    <td>
      <a href="https://i.gyazo.com/89ce35dda119affa9f47f1166d45ee57">
        <img
          src="https://i.gyazo.com/89ce35dda119affa9f47f1166d45ee57.gif"
          alt="振り返りプロンプト公開"
          >
      </a>
    </td>
    <td>
      <a href="https://i.gyazo.com/4fc5ab745b23155d5a8f06c2ae126d0e">
        <img
          src="https://i.gyazo.com/4fc5ab745b23155d5a8f06c2ae126d0e.gif"
          alt="振り返りプレビュー"
          >
      </a>
    </td>
  </tr>
  <tr>
    <td>
      作成したプロンプトを有効化すると、学生に公開されます。<br>
      有効化後、チャットアイコンが表示されます。
    </td>
    <td>
      チャットアイコンをクリックすると、プレビューを確認できます。
    </td>
  </tr>
</table>

<table>
  <thead>
    <tr>
      <th>授業日登録機能</th>
      <th>振り返り履歴閲覧機能</th>
    </tr>
  </thead>
  <tr>
    <td>
      <a href="https://i.gyazo.com/90cd859f1729b76d68fda30a8c2dba97">
        <img
          src="https://i.gyazo.com/90cd859f1729b76d68fda30a8c2dba97.gif"
          alt="授業日登録"
          >
      </a>
    </td>
    <td>
      <a href="https://i.gyazo.com/4f86fb249112f366f68fb4e30ede5139">
        <img
          src="https://i.gyazo.com/4f86fb249112f366f68fb4e30ede5139.gif"
          alt="振り返り履歴閲覧"
          >
      </a>
    </td>
  </tr>
  <tr>
    <td>
      授業日の登録を行ってください。<br>
      現在の授業日が終了するまで、次の授業日の登録はできません。<br>
      編集・削除は可能です。
    </td>
    <td>
      学生が各授業回で行った振り返り内容を閲覧できます。
    </td>
  </tr>
</table>

## 機能紹介 - 学生ページ

<table>
  <thead>
    <tr>
      <th>授業参加機能</th>
      <th>振り返り登録・閲覧機能</th>
    </tr>
  </thead>
  <tr>
    <td>
      <a href="https://i.gyazo.com/2fdb29891a62b79dcc1627a904e9639a">
        <img
          src="https://i.gyazo.com/2fdb29891a62b79dcc1627a904e9639a.gif"
          alt="授業参加"
          >
      </a>
    </td>
    <td>
      <a href="https://i.gyazo.com/d71c7269d5ba9dfced1ce16e1d553dcf">
        <img
          src="https://i.gyazo.com/d71c7269d5ba9dfced1ce16e1d553dcf.gif"
          alt="振り返り登録・閲覧"
          >
      </a>
    </td>
  </tr>
  <tr>
    <td>
      教員から共有されたクラスコードを入力してください。<br>
      クラスコードが一致すると、そのクラスへの参加が完了します。
    </td>
    <td>
      チャットアイコンをクリックします。<br>
      振り返りが開始され、指示に従って振り返りを行います。<br>
      全ての振り返りが終了後、振り返り履歴から登録内容を確認できます。また、振り返りに対してフィードバックが返されます。
    </td>
  </tr>
</table>

<table>
  <thead>
    <tr>
      <th>振り返り編集機能</th>
      <th>みんなの振り返り機能</th>
    </tr>
  </thead>
  <tr>
    <td>
      <a href="https://i.gyazo.com/a47f288c60a66c368c15f39bc8cc1ddd">
        <img
          src="https://i.gyazo.com/a47f288c60a66c368c15f39bc8cc1ddd.gif"
          alt="振り返り編集"
          >
      </a>
    </td>
    <td>
      <a href="https://i.gyazo.com/6019a5f19b0446d216c3a3fdb3518f86">
        <img
          src="https://i.gyazo.com/6019a5f19b0446d216c3a3fdb3518f86.gif"
          alt="みんなの振り返り"
          >
      </a>
    </td>
  </tr>
  <tr>
    <td>
      登録済みの振り返りをフィードバックや他の学生の振り返りを参考にして編集できます。
    </td>
    <td>
      他の学生の振り返りを閲覧できます。<br>
      振り返りは内容のみが表示されますが、カードをクリックすると質問を含めた全文や省略された部分が表示されます。
    </td>
  </tr>
</table>

## こだわりポイント

### 付箋風カードによる振り返り共有

学生が記入した振り返りの内容を付箋風のカードに表示することで、クラスメートの振り返りを簡単に閲覧できるようにしています。

このデザインには、教室で学生が各々の意見を付箋に書いて模造紙に貼り付け、共有するという情景をシステムに取り入れたいという思いを込めています。視覚的に振り返りを共有することで、他の学生の意見や考えを取り入れることができ、自分自身の学びを深める手助けとなります。

![みんなの振り返り画像](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/636cebf7-5527-dff8-6982-cff5b8a72fa3.png)

### 振り返りの記入状況の可視化

学生の振り返り状況を簡単に確認できるよう、記入済みの場合はチェックマーク、未記入の場合はバツ印や黄色の四角で表示しています。
これにより、グラフとアイコンを使って直感的に情報を把握できるようにしました。

![振り返りの可視化グラフ](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/161c6f51-fdc9-4bb3-270b-17ba8efe855e.png)

## 使用技術一覧

#### フロントエンド

- Vue 3.5.11
- Nuxt 3.13.2
- TypeScript 5.6.2
- コード解析/フォーマッター：Nuxt ESLint
- テストフレームワーク：Vitest / Nuxt Test Utils
- UIライブラリ：Tailwind CSS
- 主要パッケージ： VueUse / Nuxt Icon / Nuxt Image / vue-chartjs

#### バックエンド

- Ruby 3.3.4
- Ruby on Rails 7.1.3
- コード解析/フォーマッター：Rubocop
- テストフレームワーク：RSpec

#### インフラ

- Vercel (フロントエンド)
- Render (バックエンド)

#### CI/CD

- Github Actions

#### 環境構築

- Docker

#### 認証

- Firebase Authentication

#### API

- 学校コード検索 API
- OpenAI API

## 画面遷移図

[Figma](https://www.figma.com/design/KDvVsfNRQkM56ZxVIV5VEr/ReCap-Design?node-id=189-2679&t=2H5lpZcVIpUr7ieO-1)

## ER図
![ER図](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/79290dda-a513-2b33-5694-1b5e00b33120.png)

## インフラ構成図
![インフラ構成図](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/9a0aa7c3-ee96-8b68-9236-974bcf222673.png)
