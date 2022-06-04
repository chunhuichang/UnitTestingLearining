# Unit Test Guideline

### 測試對象

- ViewModel與UseCase一定要做測試
	- ViewModel inject MockUseCase
	- UseCase inject MockRepository
---
### Quick spec

- Quick spec階層
	- describe 
		- 每一個測試類別只能有一個
	- context
		- 每一份spec的case ，因此會有多個context
	- it
		- 測項，類似`成功載入`、`網路失敗`
		- 一個case中的正向或負向測試案例
		- 每個測試案例要包含3A，分別是 `Arrange Assertion Action`

詳細用法可以參考:https://github.com/Quick/Quick

---
### Nimble Assert

- Nimble assert
	- `expect(實際值).to(預期值)`

詳細用法可以參考:https://github.com/Quick/Nimble

---
### 寫法與規則
- import module使用 `import Project`，而不是用 `@testable import Project`
	- 為了以後抽package
	- 不建議使用 internal Access Control
		- 請使用`public` or `private`
### 測試範圍
- 測試所有的public方法
- `正向`比對傳入內容
- `負向`比對錯誤型別
- UseCase
	- 測試API成功與失敗
- ViewModel
	- 測試API呼叫次數
	- 使用binding測試所有Output


