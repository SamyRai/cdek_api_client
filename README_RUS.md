### Клиент CDEK API

[![Версия Gem](https://badge.fury.io/rb/cdek_api_client.svg)](https://badge.fury.io/rb/cdek_api_client)

### Другие языки

- [English](README.md)
- [Татарча](README_TAT.md)

> [!WARNING] >**Важно:** Этот gem находится на ранней стадии разработки и распространяется как есть. Любая поддержка разработки или обратная связь приветствуется; пожалуйста, ознакомьтесь с разделом [Contributing](#contributing) для получения дополнительной информации.

## Обзор

СДЭК ([CDEK](https://www.cdek.ru/)) - крупная логистическая компания в России, предоставляющая широкий спектр услуг доставки для бизнеса и частных лиц. [API СДЭК](https://www.cdek.ru/ru/integration/api) позволяет разработчикам интегрировать услуги СДЭК в свои приложения, обеспечивая такие функции, как создание заказов, отслеживание, расчет тарифов, получение данных о местоположении и управление вебхуками.

Gem `cdek_api_client` предлагает чистый и надежный интерфейс для взаимодействия с API СДЭК, обеспечивая поддерживаемый код с правильной валидацией. Этот gem поддерживает следующие функции:

- Создание и отслеживание заказов
- Расчет тарифов
- Получение данных о местоположении (города, регионы, почтовые коды и офисы)
- Управление вебхуками

## Содержание

- [Установка](#установка)
- [Использование](#использование)
  - [Инициализация](#инициализация)
  - [Создание заказа](#создание-заказа)
  - [Отслеживание заказа](#отслеживание-заказа)
  - [Расчет тарифа](#расчет-тарифа)
  - [Получение данных о местоположении](#получение-данных-о-местоположении)
  - [Настройка вебхуков](#настройка-вебхуков)
- [Сущности](#сущности)
  - [OrderData](#orderdata)
  - [Recipient](#recipient)
  - [Sender](#sender)
  - [Package](#package)
  - [Item](#item)
- [TODO List](#todo-list)
- [Изменения](#изменения)
- [Содействие](#содействие)
- [Лицензия](#лицензия)

## Установка

Добавьте эту строку в ваш Gemfile:

```ruby
gem 'cdek_api_client'
```

Затем выполните:

```sh
bundle install
```

Или установите gem самостоятельно:

```sh
gem install cdek_api_client
```

## Использование

### Инициализация

Чтобы использовать клиент CDEK API, необходимо инициализировать его с вашими учетными данными CDEK API (client ID и client secret):

```ruby
require 'cdek_api_client'

client_id = 'your_client_id'
client_secret = 'your_client_secret'

client = CDEKApiClient::Client.new(client_id, client_secret)
```

### Создание заказа

Для создания заказа нужно создать необходимые сущности (`OrderData`, `Recipient`, `Sender`, `Package` и `Item`) и передать их в метод `create_order` класса `Order`:

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

### Отслеживание заказа

Чтобы отслеживать заказ, используйте метод `track` класса `Order` с UUID заказа:

```ruby
order_uuid = 'order_uuid_from_created_order_response'

begin
  tracking_info = order_client.track(order_uuid)
  puts "Tracking info: #{tracking_info}"
rescue => e
  puts "Error tracking order: #{e.message}"
end
```

### Расчет тарифа

Для расчета тарифа используйте метод `calculate` класса `Tariff` с необходимыми данными тарифа:

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

### Получение данных о местоположении

Чтобы получить данные о местоположении, такие как города и регионы, поддерживаемые CDEK, используйте методы `cities` и `regions` класса `Location`:

```ruby
location_client = CDEKApiClient::Location.new(client)

# Получение городов
begin
  cities = location_client.cities
  puts "Cities: #{cities}"
rescue => e
  puts "Error fetching cities: #{e.message}"
end

# Получение регионов
begin
  regions = location_client.regions
  puts "Regions: #{regions}"
rescue => e
  puts "Error fetching regions: #{e.message}"
end
```

### Настройка вебхуков

Вебхуки позволяют вашему приложению получать уведомления в реальном времени о различных событиях, связанных с вашими отправлениями. Чтобы настроить вебхук, зарегистрируйте URL, на который CDEK будет отправлять HTTP POST запросы с данными о событиях:

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

Чтобы получить и удалить зарегистрированные вебхуки:

```ruby
# Получение вебхуков
begin
  webhooks = webhook_client.get_webhooks
  puts "Webhooks: #{webhooks}"
rescue => e
  puts "Error fetching webhooks: #{e.message}"
end

# Удаление вебхука
webhook_id = 'webhook_id_to_delete'
begin
  response = webhook_client.delete(webhook_id)
  puts "Webhook deleted: #{response}"
rescue => e
  puts "Error deleting webhook: #{e.message}"
end
```

### Сущности

### OrderData

Представляет данные заказа.

Атрибуты:

- `type` (Integer, обязательный): Тип заказа.
- `number` (String, обязательный): Номер заказа.
- `tariff_code` (Integer, обязательный): Код тарифа.
- `comment` (String): Комментарий к заказу.
- `recipient` (Recipient, обязательный): Детали получателя.
- `sender` (Sender, обязательный): Детали отправителя.
- `from_location` (Hash, обязательный): Детали места отправления заказа.
- `to_location` (Hash, обязательный): Детали места назначения заказа.
- `services` (Array): Дополнительные услуги.
- `packages` (Array, обязательный): Список упаковок.

### Recipient

Представляет данные получателя.

Атрибуты:

- `name` (String, обязательный): Имя получателя.
- `phones` (Array, обязательный): Список телефонных номеров.
- `email` (String, обязательный): Электронная почта получателя.

### Sender

Представляет данные отправителя.

Атрибуты:

- `name` (String, обязательный): Имя отправителя.
- `phones` (Array, обязательный): Список телефонных номеров.
- `email` (String, обязательный): Электронная почта отправителя.

### Package

Представляет данные об упаковке.

Атрибуты:

- `number` (String, обязательный): Номер упаковки.
- `weight` (Integer, обязательный): Вес упаковки.
- `length` (Integer, обязательный): Длина упаковки.
- `width` (Integer, обязательный): Ширина упаковки.
- `height` (Integer, обязательный): Высота упаковки.
- `comment` (String): Комментарий к упаковке.
- `items` (Array, обязательный): Список товаров в упаковке.

### Item

Представляет данные о товаре.

Атрибуты:

- `name` (String, обязательный): Наименование товара.
- `ware_key` (String, обязательный): Код товара.
- `payment` (Integer, обязательный): Сумма оплаты за товар.
- `cost` (Integer, обязательный): Стоимость товара.
- `weight` (Integer, обязательный): Вес товара.
- `amount` (Integer, обязательный): Количество товара.

## TODO List

- [x] Реструктурировать код для лучшей организации.
- [x] Добавить сопоставления внутренних кодов CDEK.
- [ ] Добавить больше точек API и сущностей данных.
- [ ] Проверить все атрибуты на обязательные и необязательные поля.
- [ ] Добавить документацию для всех классов и методов.

## Изменения

(Смотрите [CHANGELOG](CHANGELOG.md))

## Хотите помочь?

Этот gem используется в реальных проектах и на данный момент находится в стадии активной разработки. Если у вас есть идеи, предложения или проблемы, пожалуйста, создайте issue или pull request.

## Лицензия

Этот gem доступен как открытый исходный код под условиями MIT License.
