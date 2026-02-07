// app/javascript/controllers/location_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["prefecture", "city", "cityContainer"]

  // 都道府県と市区町村のマッピング
  cityData = {
    "東京都": [
      "渋谷区",
      "新宿区",
      "港区",
      "目黒区",
      "世田谷区",
      "品川区",
      "中央区"
    ]
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
