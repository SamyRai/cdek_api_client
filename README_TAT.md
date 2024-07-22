### CDEK API Клиенты

[![Gem Версия](https://badge.fury.io/rb/cdek_api_client.svg)](https://badge.fury.io/rb/cdek_api_client)

CDEK API белән эшләү өчен Ruby клиенты, заказлар ясау, күзәтү, тарифларны исәпләү, урыннар турында мәгълүмат алу һәм веб-хоклар белән идарә итү функцияләрен тәкъдим итә. Бу gem чиста, ышанычлы һәм сакланучы код белән тәэмин итә.

Бу Readme шулай ук бу телләрдә бар:

- [Русча](README_RUS.md)
- [Англича](README.md)

## Эчтәлек

- [Урнаштыру](#урнаштыру)
- [Куллану](#куллану)
  - [Инициализация](#инициализация)
  - [Заказ ясау](#заказ-ясау)
  - [Заказны күзәтү](#заказны-күзәтү)
  - [Тарифны исәпләү](#тарифны-исәпләү)
  - [Урын мәгълүматларын алу](#урын-мәгълүматларын-алу)
  - [Веб-хокларны көйләү](#веб-хокларны-көйләү)
- [Субъектлар](#субъектлар)
  - [OrderData](#orderdata)
  - [Recipient](#recipient)
  - [Sender](#sender)
  - [Package](#package)
  - [Item](#item)
- [TODO Лист](#todo-лист)
- [Үзгәрешләр](#үзгәрешләр)
- [Ярдәм итү](#ярдәм-итү)
- [Лицензия](#лицензия)

## Урнаштыру

Бу юлны Gemfile'га өстәрегез:

```ruby
gem 'cdek_api_client'
```

Аннары башкарырга:

```sh
bundle install
```

Яки gem'ны үзегез урнаштырыгыз:

```sh
gem install cdek_api_client
```

## Куллану

### Инициализация

CDEK API Клиенты белән эшләү өчен, аны сезнең CDEK API учет мәгълүматлары белән инициализацияләргә кирәк (client ID һәм client secret):

```ruby
require 'cdek_api_client'

client_id = 'your_client_id'
client_secret = 'your_client_secret'

client = CDEKApiClient::Client.new(client_id, client_secret)
```

### Заказ ясау

Заказ ясау өчен кирәкле субъектларны (`OrderData`, `Recipient`, `Sender`, `Package`, һәм `Item`) булдырырга һәм аларны `Order` классындагы `create_order` методы белән тапшырырга кирәк:

```ruby
recipient = CDEKApiClient::Entities::Recipient.new(
  name: 'John Doe',
  phones: [{ number: '+79000000000' }],
  email: 'johndoe@example.com'
)

sender = CDEKApiClient::Entities::Sender.new(
  name: 'Sender Name',
  phones: [{ number: '+79000000001' }],
  email: 'sender@example.com'
)

item = CDEKApiClient::Entities::Item.new(
  name: 'Item 1',
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
  comment: 'Package 1',
  items: [item]
)

order_data = CDEKApiClient::Entities::OrderData.new(
  type: 1,
  number: 'TEST123',
  tariff_code: 1,
  comment: 'Test order',
  recipient: recipient,
  sender: sender,
  from_location: { code: 44 },
  to_location: { code: 270 },
  packages: [package]
)

order_client = CDEKApiClient::Order.new(client)

begin
  order_response = order_client.create(order_data)
  puts "Order created successfully: #{order_response}"
rescue => e
  puts "Error creating order: #{e.message}"
end
```

### Заказны күзәтү

Заказны күзәтү өчен, `Order` классындагы `track` методын заказ UUID белән кулланыгыз:

```ruby
order_uuid = 'order_uuid_from_created_order_response'

begin
  tracking_info = order_client.track(order_uuid)
  puts "Tracking info: #{tracking_info}"
rescue => e
  puts "Error tracking order: #{e.message}"
end
```

### Тарифны исәпләү

Тарифны исәпләү өчен, кирәкле тариф мәгълүматлары белән `Tariff` классындагы `calculate` методын кулланыгыз:

```ruby
tariff_data = CDEKApiClient::Entities::TariffData.new(
  type: 1,
  currency: 'RUB',
  from_location: { code: 44 },
  to_location: { code: 137 },
  packages: [{ weight: 500, length: 10, width: 10, height: 10 }]
)

tariff_client = CDEKApiClient::Tariff.new(client)

begin
  tariff_response = tariff_client.calculate(tariff_data)
  puts "Tariff calculated: #{tariff_response}"
rescue => e
  puts "Error calculating tariff: #{e.message}"
end
```

### Урын мәгълүматларын алу

CDEK'ның ярдәм ителгән шәһәрләре һәм төбәкләре кебек урын мәгълүматларын алу өчен `Location` классындагы `cities` һәм `regions` методларын кулланыгыз:

```ruby
location_client = CDEKApiClient::Location.new(client)

# Шәһәрләрне алу
begin
  cities = location_client.cities
  puts "Cities: #{cities}"
rescue => e
  puts "Error fetching cities: #{e.message}"
end

# Төбәкләрне алу
begin
  regions = location_client.regions
  puts "Regions: #{regions}"
rescue => e
  puts "Error fetching regions: #{e.message}"
end
```

### Веб-хокларны көйләү

Веб-хоклар сезнең кушымтага реаль вакытта төрле вакыйгалар турында хәбәр итәргә мөмкинлек бирә. Веб-хокны көйләү өчен, CDEK HTTP POST сорауларын җибәрәчәк URL'ны теркәгез:

```ruby
webhook_client = CDEKApiClient::Webhook.new(client)

webhook_url = 'https://yourapp.com/webhooks/cdek'
begin
  response = webhook_client.register(webhook_url, event_types: ['ORDER_STATUS', 'DELIVERY_STATUS'])
  puts "Webhook registered: #{response}"
rescue => e
  puts "Error registering webhook: #{e.message}"
end
```

Теркәлгән веб-хокларны алу һәм бетерү өчен:

```ruby
# Веб-хокларны алу
begin
  webhooks = webhook_client.get_webhooks
  puts "Webhooks: #{webhooks}"
rescue => e
  puts "Error fetching webhooks: #{e.message}"
end

# Веб-хокны бетерү
webhook_id = 'webhook_id_to_delete'
begin
  response = webhook_client.delete(webhook_id)
  puts "Webhook deleted: #{response}"
rescue => e
  puts "Error deleting webhook: #{e.message}"
end
```

## Субъектлар

### OrderData

Заказ мәгълүматларын тәкъдим итә.

Атрибутлар:

- `type` (Integer, мәҗбүри): Заказ төре.
- `number` (String, мәҗбүри): Заказ номеры.
- `tariff_code` (Integer, мәҗбүри): Тариф коды.
- `comment` (String): Заказ өчен комментарий.
- `recipient` (Recipient, мәҗбүри): Кабул итүченең мәгълүматлары.
- `sender` (Sender, мәҗбүри): Җибәрүченең мәгълүматлары.
- `from_location` (Hash, мәҗбүри): Заказ җибәрелгән урынның мәгълүматлары.
- `to_location` (Hash, мәҗбүри): Заказ җибәрелгән урынның мәгълүматлары.
- `services` (Array): Өстәмә хезмәтләр.
- `packages` (Array, мәҗбүри): Упаковкалар исемлеге.

### Recipient

Кабул итүченең мәгълүматларын тәкъдим итә.

Атрибутлар:

- `name` (String, мәҗбүри): Кабул итүченең исеме.
- `phones` (Array, мәҗбүри): Телефон номерлары исемлеге.
- `email` (String, мәҗбүри): Кабул итүченең электрон почтасы.

### Sender

Җибәрүченең мәгълүматларын тәкъдим итә.

Атрибутлар:

- `name` (String, мәҗбүри): Җибәрүченең исеме.
- `phones` (Array, мәҗбүри): Телефон номерлары исемлеге.
- `email` (String, мәҗбүри): Җибәрүченең электрон почтасы.

### Package

Упаковка турында мәгълүматны тәкъдим итә.

Атрибутлар:

- `number` (String, мәҗбүри): Упаковка номеры.
- `weight` (Integer, мәҗбүри): Упаковка авырлыгы.
- `length` (Integer, мәҗбүри): Упаковка озынлыгы.
- `width` (Integer, мәҗбүри): Упаковка киңлеге.
- `height` (Integer, мәҗбүри): Упаковка биеклеге.
- `comment` (String): Упаковка өчен комментарий.
- `items` (Array, мәҗбүри): Упаковкадагы товарлар исемлеге.

### Item

Товар турында мәгълүматны тәкъдим итә.

Атрибутлар:

- `name` (String, мәҗбүри): Товар исеме.
- `ware_key` (String, мәҗбүри): Товар коды.
- `payment` (Integer, мәҗбүри): Товарның бәясе.
- `cost` (Integer, мәҗбүри): Товарның кыйммәте.
- `weight` (Integer, мәҗбүри): Товарның авырлыгы.
- `amount` (Integer, мәҗбүри): Товар саны.

## TODO Лист

- [x] Код базасын яхшырак оештыру өчен реструктуризацияләү.
- [x] CDEK эчке кодлары өчен маппинглар өстәү.
- [ ] Күбрәк API нокталары һәм мәгълүмат субъектлары өстәү.
- [ ] Бөтен атрибутларны мәҗбүри һәм өстәмә кырлар өчен тикшерү.
- [ ] Барлык класслар һәм методлар өчен документация өстәү.

## Үзгәрешләр

### v0.2.0

- **Өстәлде**: Клиентта хаталар белән эш итү һәм җавапларны парсинглау яхшыртылды.
- **Яңартылды**: Код структурасы яхшырак оештыру өчен үзгәртелде.
- **Яңартылды**: Клиент һәм API класслары өчен спецификацияләр.
- **Яңартылды**: Тулырак куллану мисаллары белән README.md.

## Ярдәм итү

Баг исемлегеләрен һәм pull request'ларны GitHub'да кирәк. Бу gem күп проектларда кулланылырга һәм уларны талапларын тиешләргә кулланылырга. Әгәр сездә күтүләр һәм яхшыртмалар булса, исемлек яки pull request ачырга кирәк.

## Лицензия

Бу gem [MIT Лицензиясе](https://opensource.org/licenses/MIT) шартларында ачык кодлы буларак урнаштырылган.
