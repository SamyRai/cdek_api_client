# CDEK API Клиенты

[![Gem Version](https://badge.fury.io/rb/cdek_api_client.svg)](https://badge.fury.io/rb/cdek_api_client)

CDEK API белән эшләү өчен Ruby клиенты, заказлар булдыру, күзәтү, тарифлар исәпләү, урнашкан җир турында мәгълүмат алу һәм вебхуки белән идарә итү функцияләрен тәкъдим итә. Бу гем чиста, ышанычлы һәм сакланучы код белән тәэмин итә, дөрес валидация белән.

Бу README шулай ук [инглиз телендә](README.md) һәм [рус телендә](README_RUS.md) дә бар.

## Эчтәлек

- [Урнаштыру](#урнаштыру)
- [Куллану](#куллану)
  - [Инициализация](#инициализация)
  - [Заказ булдыру](#заказ-булдыру)
  - [Заказны күзәтү](#заказны-күзәтү)
  - [Тариф исәпләү](#тариф-исәпләү)
  - [Урнашкан җир турында мәгълүмат алу](#урнашкан-җир-турында-мәгълүмат-алу)
  - [Вебхуки көйләү](#вебхуки-көйләү)
- [Субъектлар](#субъектлар)
  - [OrderData](#orderdata)
  - [Recipient](#recipient)
  - [Sender](#sender)
  - [Package](#package)
  - [Item](#item)
- [Катнашу](#катнашу)
- [Лицензия](#лицензия)

## Урнаштыру

Бу юлны сезнең Gemfile-га өстәгез:

```ruby
gem 'cdek_api_client'
```

````

Аннары үтәгез:

```sh
bundle install
```

Яки үзегез урнаштырыгыз:

```sh
gem install cdek_api_client
```

## Куллану

### Инициализация

CDEK API Клиенты куллану өчен, сезнең CDEK API учет язмалары (client ID һәм client secret) белән инициализацияләргә кирәк:

```ruby
require 'cdek_api_client'

client_id = 'your_client_id'
client_secret = 'your_client_secret'

client = CDEKApiClient::Client.new(client_id, client_secret)
```

### Заказ булдыру

Заказ булдыру өчен, кирәкле субъектларны (`OrderData`, `Recipient`, `Sender`, `Package` һәм `Item`) булдырып, аларны `Client` классының `create_order` методына тапшырырга кирәк:

```ruby
recipient = CDEKApiClient::Entities::Recipient.new(
  name: 'Иван Иванов',
  phones: [{ number: '+79000000000' }],
  email: 'ivanov@example.com'
)

sender = CDEKApiClient::Entities::Sender.new(
  name: 'Отправитель',
  phones: [{ number: '+79000000001' }],
  email: 'sender@example.com'
)

item = CDEKApiClient::Entities::Item.new(
  name: 'Товар 1',
  ware_key: '00055',
  payment: 1000,
  cost: 1000,
  weight: 500,
  amount: 1
)

package = CDEKApiClient::Entities::Package.new(
  number: '1',
  weight: 500,
  length: 10,
  width: 10,
  height: 10,
  comment: 'Упаковка 1',
  items: [item]
)

order_data = CDEKApiClient::Entities::OrderData.new(
  type: 1,
  number: 'TEST123',
  tariff_code: 1,
  comment: 'Тестовый заказ',
  recipient: recipient,
  sender: sender,
  services: [{ code: 'DELIV_WEEKEND' }, { code: 'INSURANCE', parameter: 10000 }],
  packages: [package]
)

begin
  order_response = client.create_order(order_data)
  puts "Заказ успешно создан: #{order_response}"
rescue => e
  puts "Ошибка при создании заказа: #{e.message}"
end
```

### Заказны күзәтү

Заказны күзәтү өчен, заказның UUID белән `track_order` методын кулланыгыз:

```ruby
order_uuid = 'uuid_заказа_из_ответа_на_создание_заказа'

begin
  tracking_info = client.track_order(order_uuid)
  puts "Информация об отслеживании: #{tracking_info}"
rescue => e
  puts "Ошибка при отслеживании заказа: #{e.message}"
end
```

### Тариф исәпләү

Тарифны исәпләү өчен, тариф мәгълүматлары белән `calculate_tariff` методын кулланыгыз:

```ruby
tariff_data = {
  type: 1,
  currency: 'RUB',
  from_location: { code: 44 },
  to_location: { code: 137 },
  packages: [{ weight: 500, length: 10, width: 10, height: 10 }]
}

begin
  tariff_response = client.calculate_tariff(tariff_data)
  puts "Тариф рассчитан: #{tariff_response}"
rescue => e
  puts "Ошибка при расчете тарифа: #{e.message}"
end
```

### Урнашкан җир турында мәгълүмат алу

CDEK тарафыннан якланган шәһәрләр һәм төбәкләр кебек урнашкан җир турында мәгълүмат алу өчен, `cities` һәм `regions` методларын кулланыгыз:

```ruby
# Шәһәрләр исемлеген алу
begin
  cities = client.cities
  puts "Города: #{cities}"
rescue => e
  puts "Ошибка при получении списка городов: #{e.message}"
end

# Төбәкләр исемлеген алу
begin
  regions = client.regions
  puts "Регионы: #{regions}"
rescue => e
  puts "Ошибка при получении списка регионов: #{e.message}"
end
```

### Вебхуки көйләү

Вебхуки сезнең кушымтага җибәрүләр белән бәйле төрле вакыйгалар турында реаль вакытта хәбәр итәргә мөмкинлек бирә. Вебхук көйләү өчен, CDEK вакыйгалар турында HTTP POST запросларын җибәрәчәк URL-ны теркәгез:

```ruby
webhook_url = 'https://yourapp.com/webhooks/cdek'
begin
  response = client.register_webhook(webhook_url, event_types: ['ORDER_STATUS', 'DELIVERY_STATUS'])
  puts "Вебхук зарегистрирован: #{response}"
rescue => e
  puts "Ошибка при регистрации вебхука: #{e.message}"
end
```

Теркәлгән вебхукларны алу һәм бетерү өчен:

```ruby
# Вебхукларны алу
begin
  webhooks = client.get_webhooks
  puts "Вебхуки: #{webhooks}"
rescue => e
  puts "Ошибка при получении вебхуков: #{e.message}"
end

# Вебхукны бетерү
webhook_id = 'id_вебхука_для_удаления'
begin
  response = client.delete_webhook(webhook_id)
  puts "Вебхук удален: #{response}"
rescue => e
  puts "Ошибка при удалении вебхука: #{e.message}"
end
```

## Субъектлар

### Sender

Җибәрүченең мәгълүматларын тәкъдим итә.

Атрибутлар:

- `name` (String, мәҗбүри): Җибәрүченең исеме.
- `phones` (Array, мәҗбүри): Телефон номерлары исемлеге.
- `email` (String, мәҗбүри): Җибәрүченең электрон почта адресы.

### Package

Упаковка мәгълүматларын тәкъдим итә.

Атрибутлар:

- `number` (String, мәҗбүри): Упаковка номеры.
- `weight` (Integer, мәҗбүри): Упаковка авырлыгы.
- `length` (Integer, мәҗбүри): Упаковка озынлыгы.
- `width` (Integer, мәҗбүри): Упаковка киңлеге.
- `height` (Integer, мәҗбүри): Упаковка биеклеге.
- `comment` (String): Упаковкага комментарий.
- `items` (Array, мәҗбүри): Упаковкадагы товарлар исемлеге.

### Item

Товар мәгълүматларын тәкъдим итә.

Атрибутлар:

- `name` (String, мәҗбүри): Товар исеме.
- `ware_key` (String, мәҗбүри): Товар ачкычы.
- `payment` (Integer, мәҗбүри): Товар өчен түләү бәясе.
- `cost` (Integer, мәҗбүри): Товар бәясе.
- `weight` (Integer, мәҗбүри): Товар авырлыгы.
- `amount` (Integer, мәҗбүри): Товар саны.

## TODO List

- [ ] Код базасын яхшырак оештыру өчен реструктуризацияләү.
- [ ] CDEK эчке кодлары өчен маппинг өстәү.
- [ ] Күбрәк API эндпоинтлары һәм мәгълүмат субъектлары өстәү.
- [ ] Барлык атрибутларны мәҗбүри һәм мәҗбүри булмаган кырлар өчен тикшерү.
- [ ] Барлык класслар һәм методлар өчен документация өстәү.

## Contributing

Хата хисаплары һәм үзгәртүләр кертү сораулары GitHub-та [https://github.com/your-username/cdek_api_client](https://github.com/your-username/cdek_api_client) адресы буенча кабул ителә.

## License

Бу китапханә [MIT License](https://opensource.org/licenses/MIT) шартларында ачык чыганак буларак бар.

````
