# CDEK API Client

[![Gem Version](https://badge.fury.io/rb/cdek_api_client.svg)](https://badge.fury.io/rb/cdek_api_client)

### Other Languages

- [Русский](README_RUS.md)
- [Татарча](README_TAT.md)
- [English](README.md)

> [!WARNING] >**Important:** This gem is in the early stages of development and it is shared as it is. Any support for development or feedback is welcome; please check the [Contributing](#contributing) section for more information.

## Overview

CDEK ([СДЭК](https://www.cdek.ru/)) is a big logistics company in Russia, that provides a wide range of delivery services for businesses and individuals. The [CDEK API](https://www.cdek.ru/ru/integration/api) allows developers to integrate CDEK's services into their applications, enabling functionalities such as order creation, tracking, tariff calculation, location data retrieval, and webhook management.

The `cdek_api_client` gem offers a clean and robust interface to interact with the CDEK API, ensuring maintainable code with proper validations. This gem supports the following features:

- Creating and tracking orders
- Calculating tariffs
- Retrieving location data (cities, regions, postal codes, and offices)
- Managing webhooks

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
  - [Initialization](#initialization)
  - [Creating an Order](#creating-an-order)
  - [Tracking an Order](#tracking-an-order)
  - [Calculating Tariff](#calculating-tariff)
  - [Getting Location Data](#getting-location-data)
  - [Setting Up Webhooks](#setting-up-webhooks)
  - [Fetching and Saving Location Data](#fetching-and-saving-location-data)
- [Entities](#entities)
  - [OrderData](#orderdata)
  - [Recipient](#recipient)
  - [Sender](#sender)
  - [Package](#package)
  - [Item](#item)
- [TODO List](#todo-list)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [License](#license)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cdek_api_client'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install cdek_api_client
```

## Usage

### Initialization

To use the CDEK API Client, you need to initialize it with your CDEK API credentials (client ID and client secret):

```ruby
require 'cdek_api_client'

client_id = 'your_client_id'
client_secret = 'your_client_secret'

client = CDEKApiClient::Client.new(client_id, client_secret)
```

### Creating an Order

To create an order, you need to create the necessary entities (`OrderData`, `Recipient`, `Sender`, `Package`, and `Item`) and then pass them to the `create_order` method of the `Order` class:

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

### Tracking an Order

To track an order, use the `track` method of the `Order` class with the order UUID:

```ruby
order_uuid = 'order_uuid_from_created_order_response'

begin
  tracking_info = order_client.track(order_uuid)
  puts "Tracking info: #{tracking_info}"
rescue => e
  puts "Error tracking order: #{e.message}"
end
```

### Calculating Tariff

To calculate the tariff, use the `calculate` method of the `Tariff` class with the necessary tariff data:

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

### Getting Location Data

To retrieve location data such as cities and regions supported by CDEK, use the `cities` and `regions` methods of the `Location` class:

```ruby
location_client = CDEKApiClient::Location.new(client)

# Fetching cities
begin
  cities = location_client.cities
  puts "Cities: #{cities}"
rescue => e
  puts "Error fetching cities: #{e.message}"
end

# Fetching regions
begin
  regions = location_client.regions
  puts "Regions: #{regions}"
rescue => e
  puts "Error fetching regions: #{e.message}"
end
```

### Setting Up Webhooks

Webhooks allow your application to receive real-time notifications about various events related to your shipments. To set up a webhook, register a URL where CDEK will send HTTP POST requests with event data:

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

To retrieve and delete registered webhooks:

```ruby
# Fetching webhooks
begin
  webhooks = webhook_client.get_webhooks
  puts "Webhooks: #{webhooks}"
rescue => e
  puts "Error fetching webhooks: #{e.message}"
end

# Deleting a webhook
webhook_id = 'webhook_id_to_delete'
begin
  response = webhook_client.delete(webhook_id)
  puts "Webhook deleted: #{response}"
rescue => e
  puts "Error deleting webhook: #{e.message}"
end
```

### Fetching Location Data

The gem has pre-cached values and uses them by default. Users can override this behavior by fetching live data.

You can fetch cities, regions, offices, and postal code data directly from CDEK API.

```ruby

# Fetching cities
begin
  cities = location_client.cities(use_live_data: true)
rescue => e
  puts "Error fetching cities: #{e.message}"
end

# Fetching regions
begin
  regions = location_client.regions(use_live_data: true)
rescue => e
  puts "Error fetching regions: #{e.message}"
end

# Fetching  offices
begin
  offices = location_client.offices(use_live_data: true)
rescue => e
  puts "Error fetching offices: #{e.message}"
end

# Fetching postal codes for each city
begin
  cities = location_client.cities(use_live_data: true)
rescue => e
  puts "Error fetching postal codes: #{e.message}"
end
```

### Entities

### OrderData

Represents the order data.

Attributes:

- `type` (Integer, required): The type of the order.
- `number` (String, required): The order number.
- `tariff_code` (Integer, required): The tariff code.
- `comment` (String): The comment for the order.
- `recipient` (Recipient, required): The recipient details.
- `sender` (Sender, required): The sender details.
- `from_location` (Hash, required): The location details from where the order is shipped.
- `to_location` (Hash, required): The location details of where the order is shipped.
- `services` (Array): Additional services.
- `packages` (Array, required): List of packages.

### Recipient

Represents the recipient details.

Attributes:

- `name` (String, required): The recipient's name.
- `phones` (Array, required): List of phone numbers.
- `email` (String, required): The recipient's email address.

### Sender

Represents the sender's details.

Attributes:

- `name` (String, required): The sender's name.
- `phones` (Array, required): List of phone numbers.
- `email` (String, required): The sender's email address.

### Package

Represents the package details.

Attributes:

- `number` (String, required): The package number.
- `weight` (Integer, required): The weight of the package.
- `length` (Integer, required): The length of the package.
- `width` (Integer, required): The width of the package.
- `height` (Integer, required): The height of the package.
- `comment` (String): The comment for the package.
- `items` (Array, required): List of items in the package.

### Item

Represents the item details.

Attributes:

- `name` (String, required): The name of the item.
- `ware_key` (String, required): The ware key of the item.
- `payment` (Integer, required): The payment value of the item.
- `cost` (Integer, required): The cost of the item.
- `weight` (Integer, required): The weight of the item.
- `amount` (Integer, required): The amount of the item.

## TODO List

- [x] Restructure the codebase for better organization.
- [x] Add mappings for CDEK internal codes.
- [ ] Add more API endpoints and data entities.
- [ ] Check all attributes for required and optional fields.
- [ ] Add documentation for all classes and methods.

## Changelog

(See [CHANGELOG.md](CHANGELOG.md))

## Contributing

Bug reports and pull requests are welcome on GitHub. This gem is used in a couple of projects and fulfills the requirements of those projects. If you have any suggestions or improvements, feel free to open an issue or a pull request.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
