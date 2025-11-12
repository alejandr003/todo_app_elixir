# TodoApp

To start this backend application:

- Run `mix setup` to install and setup dependencies
- Implement your database in a new file `.env` and run `source .env`
- Start Phoenix endpoint with:
  ```
  mix phx.server
  ```
  or inside IEx:
  ```
  iex -S mix phx.server
  ```

Now you can visit Postman or any API client.
---

# 📋 API REST Endpoints — TodoApp

## ✅ 1️⃣ REGISTRO DE USUARIO

**Endpoint:** `POST /api/register`  
**URL:** `http://localhost:4000/api/register`

### Headers
```
Content-Type: application/json
```

### Request Body
```json
{
  "user": {
    "name": "Juan",
    "last_name": "Pérez",
    "email": "juan.perez@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

### ✅ Response — `201 Created`
```json
{
  "data": {
    "id": 1,
    "name": "Juan",
    "last_name": "Pérez",
    "email": "juan.perez@example.com",
    "token": "SFMyNTY.g3QAAAABbQAAAAVwY...",
    "inserted_at": "2025-11-09T12:30:45Z",
    "updated_at": "2025-11-09T12:30:45Z"
  }
}
```

### ❌ Response — `422 Unprocessable Entity`
```json
{
  "errors": {
    "name": ["can't be blank"],
    "email": ["has already been taken"]
  }
}
```

---

## ✅ 2️⃣ LOGIN DE USUARIO

**Endpoint:** `POST /api/login`  
**URL:** `http://localhost:4000/api/login`

### Headers
```
Content-Type: application/json
```

### Request Body
```json
{
  "email": "juan.perez@example.com",
  "password": "password123"
}
```

### ✅ Response — `200 OK`
```json
{
  "data": {
    "id": 1,
    "name": "Juan",
    "last_name": "Pérez",
    "email": "juan.perez@example.com",
    "token": "SFMyNTY.g3QAAAABbQAAAAVwY..."
  }
}
```

### ❌ Response — `401 Unauthorized`
```json
{
  "error": "Contraseña inválida"
}
```

### ❌ Response — `404 Not Found`
```json
{
  "error": "Usuario no encontrado"
}
```

---

## Tabla de Validaciones

| Campo                 | Validación                                | Error ejemplo                                          |
|----------------------|--------------------------------------------|--------------------------------------------------------|
| name                 | Requerido, 2–50 caracteres                 | "can't be blank", "should be 2-50 character(s)"        |
| last_name            | Requerido, 2–50 caracteres                 | "can't be blank", "should be 2-50 character(s)"        |
| email                | Requerido, formato válido, único           | "can't be blank", "has invalid format", "has already been taken" |
| password             | Requerido, 8–100 caracteres                | "can't be blank", "should be 8-100 character(s)"       |
| password_confirmation | Debe coincidir con password               | "does not match confirmation"                          |
