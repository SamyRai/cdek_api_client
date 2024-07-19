# CDEK API Client

[![Gem Version](https://badge.fury.io/rb/cdek_api_client.svg)](https://badge.fury.io/rb/cdek_api_client)

Ruby клиент для взаимодействия с API CDEK, предоставляющий функции для создания заказов, отслеживания, расчета тарифа, получения данных о местоположении и управления вебхуками. Этот гем обеспечивает чистый, надежный и поддерживаемый код с правильной валидацией.

Этот README также доступен на [английском языке](README.md).
Этот README также доступен на [татарском языке](README_TAT.md).

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
- [Содействие](#содействие)
- [Лицензия](#лицензия)

## Установка

Добавьте эту строку в ваш Gemfile:

```ruby
gem 'cdek_api_client'
```

````

Затем выполните:

```sh
bundle install
```

Или установите самостоятельно:

```sh
gem install cdek_api_client
```

## Использование

### Инициализация

Для использования CDEK API Client, необходимо инициализировать его с вашими учетными данными API CDEK (client ID и client secret):

```ruby
require 'cdek_api_client'

client_id = 'your_client_id'
client_secret = 'your_client_secret'

client = CDEKApiClient::Client.new(client_id, client_secret)
```

### Создание заказа

Чтобы создать заказ, необходимо создать необходимые сущности (`OrderData`, `Recipient`, `Sender`, `Package` и `Item`) и передать их методу `create_order` класса `Client`:

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

### Отслеживание заказа

Для отслеживания заказа используйте метод `track_order` с UUID заказа:

```ruby
order_uuid = 'uuid_заказа_из_ответа_на_создание_заказа'

begin
  tracking_info = client.track_order(order_uuid)
  puts "Информация об отслеживании: #{tracking_info}"
rescue => e
  puts "Ошибка при отслеживании заказа: #{e.message}"
end
```

### Расчет тарифа

Для расчета тарифа используйте метод `calculate_tariff` с необходимыми данными тарифа:

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

### Получение данных о местоположении

Для получения данных о местоположении, таких как города и регионы, поддерживаемые CDEK, используйте методы `cities` и `regions`:

```ruby
# Получение списка городов
begin
  cities = client.cities
  puts "Города: #{cities}"
rescue => e
  puts "Ошибка при получении списка городов: #{e.message}"
end

# Получение списка регионов
begin
  regions = client.regions
  puts "Регионы: #{regions}"
rescue => e
  puts "Ошибка при получении списка регионов: #{e.message}"
end
```

### Настройка вебхуков

Вебхуки позволяют вашему приложению получать уведомления в реальном времени о различных событиях, связанных с вашими отправлениями. Чтобы настроить вебхук, зарегистрируйте URL, на который CDEK будет отправлять HTTP POST запросы с данными о событиях:

```ruby
webhook_url = 'https://yourapp.com/webhooks/cdek'
begin
  response = client.register_webhook(webhook_url, event_types: ['ORDER_STATUS', 'DELIVERY_STATUS'])
  puts "Вебхук зарегистрирован: #{response}"
rescue => e
  puts "Ошибка при регистрации вебхука: #{e.message}"
end
```

Для получения и удаления зарегистрированных вебхуков:

```ruby
# Получение вебхуков
begin
  webhooks = client.get_webhooks
  puts "Вебхуки: #{webhooks}"
rescue => e
  puts "Ошибка при получении вебхуков: #{e.message}"
end

# Удаление вебхука
webhook_id = 'id_вебхука_для_удаления'
begin
  response = client.delete_webhook(webhook_id)
  puts "Вебхук удален: #{response}"
rescue => e
  puts "Ошибка при удалении вебхука: #{e.message}"
end
```

## Сущности

### OrderData

Представляет данные заказа.

Атрибуты:

- `type` (Integer, обязательный): Тип заказа.
- `number` (String, обязательный): Номер заказа.
- `tariff_code` (Integer, обязательный): Код тарифа.
- `comment` (String): Комментарий к заказу.
- `recipient` (Recipient, обязательный): Данные получателя.
- `sender` (Sender, обязательный): Данные отправителя.
- `from_location` (Hash, обязательный): Данные о местоположении, откуда отправляется заказ.
- `to_location` (Hash, обязательный): Данные о местоположении, куда отправляется заказ.
- `services` (Array): Дополнительные услуги.
- `packages` (Array, обязательный): Список упаковок.

### Recipient

Представляет данные получателя.

Атрибуты:

- `name` (String, обязательный): Имя получателя.
- `phones` (Array, обязательный): Список номеров телефонов.
- `email` (String, обязательный): Адрес электронной почты получателя.

### Sender

Представляет данные отправителя.

Атрибуты:

- `name` (String, обязательный): Имя отправителя.
- `phones` (Array, обязательный): Список номеров телефонов.
- `email` (String, обязательный): Адрес электронной почты отправителя.

### Package

Представляет данные упаковки.

Атрибуты:

- `number` (String, обязательный): Номер упаковки.
- `weight` (Integer, обязательный): Вес упаковки.
- `length` (Integer, обязательный): Длина упаковки.
- `width` (Integer, обязательный): Ширина упаковки.
- `height` (Integer, обязательный): Высота упаковки.
- `comment` (String): Комментарий к упаковке.
- `items` (Array, обязательный): Список товаров в упаковке.

### Item

Представляет данные товара.

Атрибуты:

- `name` (String, обязательный): Название товара.
- `ware_key` (String, обязательный): Ключ товара.
- `payment` (Integer, обязательный): Значение оплаты за товар.
- `cost` (Integer, обязательный): Стоимость товара.
- `weight` (Integer, обязательный): Вес товара.
- `amount` (Integer, обязательный): Количество товара.

## TODO List

- [ ] Реструктурировать кодовую базу для лучшей организации.
- [ ] Добавить маппинг для внутренних кодов CDEK.
- [ ] Добавить больше API конечных точек и сущностей данных.
- [ ] Проверить все атрибуты на обязательные и необязательные поля.
- [ ] Добавить документацию для всех классов и методов.

## Contributing

Сообщения об ошибках и запросы на внесение изменений приветствуются на GitHub по адресу [https://github.com/your-username/cdek_api_client](https://github.com/your-username/cdek_api_client).

## License

Библиотека доступна как open-source на условиях [MIT License](https://opensource.org/licenses/MIT).
````
