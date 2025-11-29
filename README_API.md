# API Documentation

Base URL: `https://home-ease-six.vercel.app/api`

## Authentication

### Login
- **URL**: `/auth/login` (Note: File is at `/api/login/route.js`, so path is `/api/login`)
- **Method**: `POST`
- **Body**:
  ```json
  {
    "email": "user@example.com",
    "password": "password123"
  }
  ```
- **Response**: Returns user object and sets `session_token` cookie.

### Logout
- **URL**: `/logout`
- **Method**: `POST`
- **Response**: Clears `session_token` cookie.

### Register
- **URL**: `/register`
- **Method**: `POST`
- **Body**:
  ```json
  {
    "username": "johndoe",
    "email": "user@example.com",
    "password": "password123" // Must be at least 6 chars
  }
  ```

### Get Current User
- **URL**: `/auth/me`
- **Method**: `GET`
- **Headers**: Requires `session_token` cookie.
- **Response**: Returns current user details.

### Update Current User
- **URL**: `/auth/me`
- **Method**: `PUT`
- **Body**:
  ```json
  {
    "email": "user@example.com", // Used to find user
    "username": "newname",
    "photoURL": "http://..."
  }
  ```

---

## Bookings

### Get All Bookings
- **URL**: `/bookings`
- **Method**: `GET`
- **Response**: List of all bookings.

### Create Booking
- **URL**: `/bookings`
- **Method**: `POST`
- **Body**: JSON object with booking details.

### Get Bookings by Email
- **URL**: `/bookings/:email`
- **Method**: `GET`
- **Note**: The parameter is named `id` in the route file but treated as an email.

### Update Booking Status
- **URL**: `/bookings/:id`
- **Method**: `PUT`
- **Body**:
  ```json
  {
    "status": "confirmed"
  }
  ```

---

## Products
**Note**: Most product routes require authentication (`withAuth` middleware).

### Get All Products
- **URL**: `/product`
- **Method**: `GET`
- **Auth**: Required.

### Create Product
- **URL**: `/product`
- **Method**: `POST`
- **Auth**: Required (Admin or Vendor role).
- **Body**: Product details JSON.

### Get Single Product
- **URL**: `/product/:id`
- **Method**: `GET`
- **Auth**: Required.

### Update Product
- **URL**: `/product/:id`
- **Method**: `PUT`
- **Auth**: Required (Admin or Owner).
- **Body**: Product update data.

### Delete Product
- **URL**: `/product/:id`
- **Method**: `DELETE`
- **Auth**: Required (Admin or Owner).

---

## Services (Categories)

### Get All Services
- **URL**: `/services`
- **Method**: `GET`

### Create Service
- **URL**: `/services`
- **Method**: `POST`
- **Body**: Service category details.

### Update Service
- **URL**: `/services/:id`
- **Method**: `PUT`
- **Body**: Service category update data.

### Delete Service
- **URL**: `/services/:id`
- **Method**: `DELETE`

---

## Data Models

### User
- **username**: String (Required, Unique)
- **email**: String (Required, Unique)
- **password**: String (Required)
- **role**: String (Enum: 'admin', 'user', 'vendor', Default: 'user')
- **photoURL**: String
- **createdAt**: Date
- **updatedAt**: Date

### BookedService
- **service**: Object (Required)
    - **id**: String
    - **title**: String
    - **description**: String
    - **image**: String
- **name**: String (Required)
- **email**: String (Required)
- **location**: String
- **contact**: String
- **comment**: String
- **status**: String (Enum: 'Pending', 'Approved', 'Rejected', Default: 'Pending')

### Product
- **name**: String (Required)
- **nameBn**: String (Required)
- **description**: String
- **descriptionBn**: String
- **price**: Number (Required)
- **originalPrice**: Number
- **category**: String (Enum: 'fertilizers', 'seeds', 'tools', 'pesticides', 'soil', 'organic', 'equipment')
- **categoryBn**: String (Required)
- **subcategory**: String
- **subcategoryBn**: String
- **images**: Array of Objects ({ url, alt })
- **stock**: Number (Default: 0)
- **weight**: Object ({ value, unit })
- **brand**: String
- **sku**: String (Unique)
- **tags**: Array of Strings
- **tagsBn**: Array of Strings
- **specifications**: Array of Objects ({ name, value, nameBn, valueBn })
- **isActive**: Boolean (Default: true)
- **isFeatured**: Boolean (Default: false)
- **rating**: Object ({ average, count })
- **discount**: Object ({ type, value, startDate, endDate })
- **vendor**: ObjectId (Ref: User, Required)

### ServiceCategory
- **id**: String (Required, Unique)
- **title**: String (Required)
- **featured**: Array of Objects
    - **id**: Number
    - **title**: String
    - **description**: String
    - **image**: String
- **all**: Array of Strings
