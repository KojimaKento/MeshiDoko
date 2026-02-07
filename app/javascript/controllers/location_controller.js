// app/javascript/controllers/location_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prefecture", "city", "cityContainer"]

  // 都道府県と市区町村のマッピング（全都道府県対応）
  cityData = {
    "北海道": ["札幌市", "函館市", "旭川市", "釧路市", "帯広市", "小樽市"],
    "青森県": ["青森市", "弘前市", "八戸市"],
    "岩手県": ["盛岡市", "一関市", "奥州市"],
    "宮城県": ["仙台市", "石巻市", "大崎市"],
    "秋田県": ["秋田市", "横手市", "大館市"],
    "山形県": ["山形市", "鶴岡市", "酒田市"],
    "福島県": ["福島市", "郡山市", "いわき市"],
    "茨城県": ["水戸市", "つくば市", "日立市"],
    "栃木県": ["宇都宮市", "小山市", "栃木市"],
    "群馬県": ["前橋市", "高崎市", "太田市"],
    "埼玉県": ["さいたま市", "川口市", "川越市", "所沢市", "越谷市"],
    "千葉県": ["千葉市", "船橋市", "松戸市", "市川市", "柏市"],
    "東京都": [
      "千代田区", "中央区", "港区", "新宿区", "文京区", "台東区",
      "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区",
      "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区",
      "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区",
      "八王子市", "立川市", "武蔵野市", "三鷹市", "町田市", "府中市"
    ],
    "神奈川県": ["横浜市", "川崎市", "相模原市", "藤沢市", "横須賀市"],
    "新潟県": ["新潟市", "長岡市", "上越市"],
    "富山県": ["富山市", "高岡市"],
    "石川県": ["金沢市", "小松市"],
    "福井県": ["福井市", "敦賀市"],
    "山梨県": ["甲府市", "富士吉田市"],
    "長野県": ["長野市", "松本市", "上田市"],
    "岐阜県": ["岐阜市", "大垣市", "高山市"],
    "静岡県": ["静岡市", "浜松市", "沼津市", "富士市"],
    "愛知県": ["名古屋市", "豊田市", "岡崎市", "一宮市", "豊橋市"],
    "三重県": ["津市", "四日市市", "鈴鹿市"],
    "滋賀県": ["大津市", "草津市", "彦根市"],
    "京都府": ["京都市", "宇治市", "舞鶴市"],
    "大阪府": ["大阪市", "堺市", "東大阪市", "豊中市", "吹田市", "高槻市", "枚方市"],
    "兵庫県": ["神戸市", "姫路市", "西宮市", "尼崎市", "明石市"],
    "奈良県": ["奈良市", "橿原市", "生駒市"],
    "和歌山県": ["和歌山市", "田辺市"],
    "鳥取県": ["鳥取市", "米子市"],
    "島根県": ["松江市", "出雲市"],
    "岡山県": ["岡山市", "倉敷市"],
    "広島県": ["広島市", "福山市", "呉市"],
    "山口県": ["山口市", "下関市", "宇部市"],
    "徳島県": ["徳島市", "阿南市"],
    "香川県": ["高松市", "丸亀市"],
    "愛媛県": ["松山市", "今治市"],
    "高知県": ["高知市", "南国市"],
    "福岡県": ["福岡市", "北九州市", "久留米市", "飯塚市", "大牟田市"],
    "佐賀県": ["佐賀市", "唐津市"],
    "長崎県": ["長崎市", "佐世保市"],
    "熊本県": ["熊本市", "八代市"],
    "大分県": ["大分市", "別府市"],
    "宮崎県": ["宮崎市", "都城市"],
    "鹿児島県": ["鹿児島市", "霧島市"],
    "沖縄県": ["那覇市", "沖縄市", "浦添市", "宜野湾市"]
  }

  connect() {
    console.log("Location controller connected")
  }

  updateCities(event) {
    const prefecture = event.target.value

    if (prefecture === "") {
      // 都道府県が未選択の場合、市区町村を非表示
      this.cityContainerTarget.style.display = "none"
      return
    }

    // 選択された都道府県の市区町村を取得
    const cities = this.cityData[prefecture] || []

    if (cities.length > 0) {
      // 市区町村のプルダウンを更新
      this.updateCitySelect(cities)

      // 市区町村フィールドを表示
      this.cityContainerTarget.style.display = "block"
    } else {
      // 市区町村データがない場合は非表示
      this.cityContainerTarget.style.display = "none"
    }
  }

  updateCitySelect(cities) {
    // 既存のoptionをクリア
    this.cityTarget.innerHTML = ""

    // 「選択してください」オプションを追加
    const defaultOption = document.createElement("option")
    defaultOption.value = ""
    defaultOption.textContent = "選択してください"
    this.cityTarget.appendChild(defaultOption)

    // 市区町村のoptionを追加
    cities.forEach(city => {
      const option = document.createElement("option")
      option.value = city
      option.textContent = city
      this.cityTarget.appendChild(option)
    })
  }
}
