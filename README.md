# ReCap / 対話型振り返りシステム

![サイトのOGP画像](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/f7cc3e51-6797-703b-3150-e488300922fc.png)

## サービス概要

「**ReCap**」は、**教員と学生のための振り返り学習プラットフォーム**です。
**教育現場での利用**を想定しており、教員が作成したプロンプトに基づき、学生はチャット形式で対話を通じて振り返りを行います。**対話型の振り返り**は、学生が自分の考えを**自由に表現しやすい**という特徴があります。振り返りの内容がすべて提出された後には、**個別のフィードバック**を受け取ることができます。これにより、**学びを深め、新たな気づきを得るサポート**をしています。

### サービスURL

https://www.recaplearning.com/

### 紹介記事

[【未経験・独学】教員と学生のための振り返り学習プラットフォームを開発しました【Nuxt / Rails / Tailwind CSS / Firebase Authentication / GitHub Actions】](https://qiita.com/kaseispace/items/e0c6c39baaebfbfc5de8)

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

## 使用技術

| カテゴリ | 技術 | 
| --- | --- |
| フロントエンド | Vue 3.5.11 / Nuxt 3.13.2 / TypeScript 5.6.2 | 
| バックエンド | Ruby 3.3.4 / Ruby on Rails 7.1.3（APIモード） |
| データベース | PostgreSQL 16 |
| 認証 | Firebase Authentication |
| 環境構築 | Docker |
| CI/CD | Github Actions |
| インフラ | Vercel / Render |
| UIライブラリ | Tailwind CSS |
| 外部API | 学校コード検索 API / OpenAI API |
| その他 | VueUse / Nuxt Icon / Nuxt Image / vue-chartjs / <br>Nuxt ESLint / Vitest / Nuxt Test Utils / Rubocop / RSpec |

## 技術選定の理由
### フロントエンド
フロントエンドには Vue.js と Nuxt3 を採用しました。React / Next.js も検討しましたが、初学者として継続的に学習・開発を進めるためには、学習コストが低く、直感的に理解しやすい技術が適切だと判断しました。

Vue.js は JavaScript に近い記法で記述でき、コンポーネントベースの設計も自然に習得できました。さらに Nuxt3 を組み合わせることで、ルーティングやディレクトリ構成が自動化されており、設計の指針が明確なため、迷いなく機能追加や画面設計に集中できると考えました。

特に Nuxt3 の以下の機能は、開発体験を大きく向上させました

- **自動ルーティング（pages ディレクトリ）**：直感的にページ構成を管理でき、ナビゲーションも柔軟に実装可能

- **Auto Import 機能**：useFetch や useState などを import なしで利用でき、コードの可読性と生産性が向上

- **TypeScript との親和性**：型安全にデータ受け渡しや状態管理を行え、バグの予防にもつながる


### バックエンド
バックエンドには Ruby on Rails を採用しました。プログラミングを始めた当初、私は「Railsチュートリアル」を活用して学習を進めました。初心者向けに体系的な構成がされており、Webアプリ開発の流れを挫折せずに理解できたことから、最初に習得したフレームワークが Rails でした。

ポートフォリオ開発においても、すでに習熟していた技術を活用することで、学習コストを抑えながら設計・実装に集中できると判断しました。

### UI
UI には Tailwind CSS を採用しました。最大の理由は、クラス名の命名に悩む必要がないことです。従来の CSS 設計では、構造や意味を考慮した命名が求められ、開発の負担になっていました。Tailwind CSS ではユーティリティクラスを直接記述できるため、命名の手間を省きながら、UI をスピーディに構築できると考えました。

また、ユーティリティクラスだけでなく、`hover:` などの疑似クラスバリアントを容易に適用できる点や、ブレイクポイントを指定するだけでレスポンシブデザインを実現できる点も、開発効率を高める上で大きなメリットでした。

### インフラ
ポートフォリオのインフラ構成には、フロントエンドに Vercel、バックエンドに Render を採用しました。

Vercel は特別な設定をせずにゼロコンフィグで GitHub リポジトリと連携でき、リポジトリを選んでボタンを押すだけでデプロイ環境が整い、以降は push するだけで自動的に更新が反映される点が魅力でした。

また、GitHub Actions を組み合わせて Vitest や ESLint によるテスト・静的解析をデプロイ前に自動実行することで、開発効率と品質管理を両立させています。

バックエンドには、Rails チュートリアルで利用経験のある Render を選択し、慣れた環境でスムーズに API と PostgreSQL データベースの運用構成を整えることができました。

## 画面遷移図

[Figma](https://www.figma.com/design/KDvVsfNRQkM56ZxVIV5VEr/ReCap-Design?node-id=189-2679&t=2H5lpZcVIpUr7ieO-1)

![画面遷移図.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/3c5b235e-f80f-41c2-9f0d-4664efc73b59.png)

## ER図
![ER図](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/79290dda-a513-2b33-5694-1b5e00b33120.png)

## インフラ構成図
![インフラ構成図](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/9a0aa7c3-ee96-8b68-9236-974bcf222673.png)

## こだわった実装
こだわった実装は以下になります。

- **みんなの振り返り機能**
- **振り返り登録機能**
- **レスポンシブ対応**

### みんなの振り返り機能
「みんなの振り返り一覧」画面では、学生の振り返り内容を**付箋風のカード**として表示しています。 このUIは、教室で学生がそれぞれの意見を付箋に書いて、模造紙や黒板、ホワイトボードなどに貼り付けて共有するという**教育現場の情景を再現することを意図したもの**です。

カードの背景色や角度をランダムに変えることで、**視覚的な多様性と楽しさ**を演出し、一覧画面にありがちな無機質さを避け、**温かみのある空間をつくることを目指しました**。 学生がクラスメートの振り返りを“眺めて回る”ような体験を促すことで、**他者の視点に触れ、自分の学びを深めるきっかけ**になるよう設計しています。

![みんなの振り返り画像](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/636cebf7-5527-dff8-6982-cff5b8a72fa3.png)

#### 技術的な課題
Tailwind CSS は、ビルド時に未使用のクラスを自動的に削除（パージ）する仕様があります。 そのため、**動的に組み立てたクラス名**は、静的解析では使用されていないと判断され、ビルド後に削除されてしまいます。 この結果、**背景色が正しく適用されない**という問題が発生しました。

#### 解決アプローチ
tailwind.config.tsにsafelistを設定することで、**使用する可能性のある色クラスを事前にすべて列挙して保持**しています。
今回は、**17色 × 4パターン**の組み合わせで、**計68種類のクラス**をsafelistに登録しました。
これにより、ランダムにクラスを指定しても、ビルド時に削除されることなく、**安定して背景色が適用される**ようになっています。

#### Tailwind CSS の safelist 設定
背景色のバリエーション（色 × 濃度）を関数でまとめて管理し、safelistに展開しています。このように関数化することで、**色の追加や削除が柔軟に行えるようになり、保守性が高まります**。
```tailwind.config.ts
function generateSafelist(color: string) {
  return [
    `bg-${color}-100`, `bg-${color}-200`, `bg-${color}-600/70`, `bg-${color}-100/70`
  ]
}

module.exports = {
  safelist: [
    ...generateSafelist('red'),
    ...generateSafelist('orange'),
    ...generateSafelist('amber'),
    ...generateSafelist('yellow'),
    ...generateSafelist('lime'),
    ...generateSafelist('green'),
    ...generateSafelist('emerald'),
    ...generateSafelist('teal'),
    ...generateSafelist('cyan'),
    ...generateSafelist('sky'),
    ...generateSafelist('blue'),
    ...generateSafelist('indigo'),
    ...generateSafelist('violet'),
    ...generateSafelist('purple'),
    ...generateSafelist('fuchsia'),
    ...generateSafelist('pink'),
    ...generateSafelist('rose')
  ]
}
```

#### ランダム生成のロジック
カード本体（付箋）とテープ部分の背景色をランダムに生成するためのComposableです。
17色 × 2通りの濃度の組み合わせからランダムに選び、Tailwind CSS のクラス文字列を生成します。
ロジックを**コンポーネントから切り出すことで、責務を分離**し、再利用やテストも容易にしました。

```useGenerateRandomColor.ts
export const useGenerateRandomColor = () => {
  const cardBgColor = ref('')
  const sealBgColor = ref('')
  const rotationAngle = ref('')
  const colorPalette = [
    'red',
    'orange',
    'amber',
    'yellow',
    'lime',
    'green',
    'emerald',
    'teal',
    'cyan',
    'sky',
    'blue',
    'indigo',
    'violet',
    'purple',
    'fuchsia',
    'pink',
    'rose'
  ]
  const colorSaturationLevels = [
    { cardSaturation: 100, sealSaturation: 600 },
    { cardSaturation: 200, sealSaturation: 100 }
  ]
  const rotationAngles = [
    '-rotate-[3deg]', '-rotate-[5deg]', '-rotate-[7deg]', '-rotate-[10deg]',
    'rotate-[3deg]', 'rotate-[5deg]', 'rotate-[7deg]', 'rotate-[10deg]'
  ]

  const createRandomColor = () => {
    const selectedColor = colorPalette[Math.floor(Math.random() * colorPalette.length)]
    const selectedSaturation = colorSaturationLevels[Math.floor(Math.random() * colorSaturationLevels.length)]
    rotationAngle.value = rotationAngles[Math.floor(Math.random() * rotationAngles.length)]

    cardBgColor.value = `bg-${selectedColor}-${selectedSaturation.cardSaturation}`
    sealBgColor.value = `bg-${selectedColor}-${selectedSaturation.sealSaturation}/70`
  }

  return { cardBgColor, sealBgColor, rotationAngle, createRandomColor }
}
```

#### PostItコンポーネントでのランダムクラスの適用
マウント時にランダム生成を呼び、得られたクラス文字列をそのまま `:class` へバインドしています。

```PostIt.vue
<script setup lang="ts">
const { cardBgColor, sealBgColor, createRandomColor } = useGenerateRandomColor()

onMounted(() => {
  createRandomColor()
})
</script>

<template>
  <div>
    <div
      class="cursor-pointer duration-300 ease-in-out hover:scale-110"
    >
      <div
        class="relative flex h-60 min-w-60 max-w-96 items-center justify-center text-gray-800"
        :class="cardBgColor"
      >
        <div class="mx-6 my-12 line-clamp-[8] w-full">
          <slot />
        </div>

        <div class="absolute bottom-[-5px] right-[7px] -z-10 h-1/2 w-[70%] rotate-[5deg] bg-[#d0d0d0] blur-sm" />
        <div
          class="absolute -top-3 left-1/2 h-8 w-20 -translate-x-1/2 rotate-3"
          :class="sealBgColor"
        />
      </div>
    </div>
  </div>
</template>
```

### 振り返り登録機能
授業の振り返りを、ユーザーとシステム（bot）の会話形式で記録できる仕組みを実装しました。複数のメッセージを1つの振り返りとして登録できるようにすることで、学習の流れや思考の過程を自然に残せることを目的としました。

フロントエンドからは以下のような形式でデータが送信されます。
```sample_reflections.ts
reflections: [
  { message_type: "bot", message: "こんにちは！" },
  { message_type: "bot", message: "振り返りを始めましょう！" },
  { message_type: "bot", message: "今日の授業で新しく学んだことや印象に残った内容は何ですか？" },
  { message_type: "user", message: "JavaScriptの条件分岐について学びました。if文の使い方が少しずつ分かってきました。" },
  { message_type: "bot", message: "実際にコードを書いてみて、うまく動いた場面はありましたか？" },
  { message_type: "user", message: "「もし〇〇なら〜」という処理を作って、ボタンを押すとメッセージが変わるようにできました。" }
  { message_type: "bot", message: "次に挑戦してみたいことはありますか？" },
  { message_type: "user", message: "次は複数の条件を組み合わせて、もっと複雑な分岐を作ってみたいです。" },
  { message_type: "bot", message: "お疲れ様でした！" },
]
```

#### 技術的な課題
複数メッセージを1つの振り返りとして保存する必要がありましたが、1件でも保存に失敗すると会話の一部だけが欠けてしまい、学習履歴の整合性を欠く可能性がありました。

#### 解決アプローチ
Railsのトランザクションを用いて、すべての登録が成功した場合のみコミットされるように設計しました。失敗時にはロールバックしてエラーメッセージを返すことで、データの一貫性を担保しました。

```reflections_controller.rb
def create
  user_course = UserCourse.joins(:course)
                .find_by(user_id: @user.id, 'courses.uuid' => params[:uuid])
  return render json: { error: { messages: ['あなたの所属情報が見つかりませんでした。'] } },
                status: :not_found unless user_course

  begin
    Reflection.transaction do
      new_reflections = reflection_params[:reflections].map do |reflection|
        Reflection.create!(
          reflection.merge(
            user_id: @user.id,
            course_id: user_course.course_id,
            course_date_id: reflection_params[:course_date_id]
          )
        )
      end

      reflections_with_course_dates = new_reflections.group_by(&:course_date).map do |course_date, reflections|
        course_date.as_json(only: %i[course_id course_number course_date])
                   .merge(reflections:)
      end

      render json: reflections_with_course_dates
    end
  rescue ActiveRecord::RecordInvalid
    render json: { error: { messages: ['振り返りを登録できませんでした。'] } },
           status: :unprocessable_entity
  end
end
```

### レスポンシブ対応
「ReCap」では、どのデバイスでも快適に操作できるよう、**各画面のUIを細部まで丁寧に作り込みました**。 

画面サイズや操作環境に応じて、**カードの配置・余白・コンポーネントの並び方などを一つひとつ調整し、妥協なく仕上げています**。

その一例として、授業一覧画面では、Tailwind CSS の `grid` レイアウトをベースに、`grid-cols-1`〜`grid-cols-4` をブレイクポイント（`xs`, `md`, `lg`）ごとに指定し、**スマートフォンでは1列、PCでは最大4列**で表示されるよう設計しました。また、`gap-x` と `gap-y` を使い、**カード間の余白も画面幅に応じて最適化**しています。

さらに、**ナビゲーションの構成にも工夫を加え**、PCでは常時表示されるサイドバーを、スマートフォンではハンバーガーメニューに切り替えることで、**限られた画面スペースを有効に使いながら、操作性を損なわない設計**を実現しました。

この構成により、**狭い画面では縦スクロールで見やすく、広い画面では一覧性を高める**ことができました。

| スマートフォン | PC |
| :---: | :---: |
| ![スマホ版レイアウト.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/6abd8347-d481-4734-b2ad-c09d2a46c1b7.png) | ![PC版レイアウト.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/3954066/f2556194-9fcc-438f-aa92-01b4c9e3f16f.png) | 


他の画面でも、ボタン配置・フォントサイズ・余白・コンポーネントの並び方などを細かく調整し、ユーザーがどの環境でも違和感なく使えるUIを目指して設計しています。
