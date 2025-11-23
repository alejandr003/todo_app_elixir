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
## 4️⃣ 🔑 Recuperar y cambiar contraseña

### Solicitar recuperación de contraseña
**POST** `/api/password/forgot`

**Body:**
```json
{
  "email": "test@test.com"
}
```
**Respuesta exitosa:**
```json
{
  "message": "Si el correo existe, se ha enviado un email con instrucciones"
}
```

### Cambiar contraseña con token
**POST** `/api/password/reset`

**Body:**
```json
{
  "token": "<TOKEN_DEL_EMAIL>",
  "password": "nueva_password"
}
```
**Respuesta exitosa:**
```json
{
  "message": "Contraseña actualizada exitosamente"
}
```

---

## 🚪 Logout (Cerrar sesión)

**POST** `/api/logout`

**Headers:**
`Authorization: Bearer <JWT_TOKEN>`

**Respuesta exitosa:**
```json
{
  "message": "Sesión cerrada correctamente"
}
```
---

### 5️⃣ CRUD de Notas (requiere autenticación)
---

#### a) Listar notas
**GET** `/api/notes`
**Headers:** `Authorization: Bearer <JWT_TOKEN>`

**Respuesta:**
```json
[
  {
    "id": 1,
    "title": "Nota 1",
    "content": "Contenido de la nota",
    "inserted_at": "2025-11-23T00:00:00Z"
  }
]
```

#### b) Crear nota
**POST** `/api/notes`
**Headers:** `Authorization: Bearer <JWT_TOKEN>`
**Body:**
```json
{
  "title": "Nota nueva",
  "content": "Texto de la nota"
}
```
**Respuesta:**
```json
{
  "id": 2,
  "title": "Nota nueva",
  "content": "Texto de la nota",
  "inserted_at": "2025-11-23T00:00:00Z"
}
```

#### c) Ver nota
**GET** `/api/notes/:id`
**Headers:** `Authorization: Bearer <JWT_TOKEN>`

#### d) Actualizar nota
**PUT** `/api/notes/:id`
**Headers:** `Authorization: Bearer <JWT_TOKEN>`
**Body:**
```json
{
  "title": "Nuevo título",
  "content": "Nuevo contenido"
}
```

#### e) Eliminar nota
**DELETE** `/api/notes/:id`
**Headers:** `Authorization: Bearer <JWT_TOKEN>`

---

## Ejemplo de flujo completo (usando test@test.com)

1. Registrar usuario con `/api/register`.
2. Iniciar sesión con `/api/login` y guardar el `token`.
3. Usar el `token` en el header `Authorization` para acceder a `/api/notes` (CRUD).
4. Para recuperar contraseña, usar `/api/password/forgot` y seguir el link del email.
5. Para cerrar sesión, llamar a `/api/logout` con el token.

---

## Notas
- Todos los endpoints devuelven JSON.
- El token se debe enviar en el header `Authorization` como `Bearer <token>` para endpoints protegidos.
- El sistema está listo para integración con frontend web/mobile.
- Emails de bienvenida y recuperación se envían usando Swoosh (en dev, revisa consola/logs).

---

## Tabla de Validaciones

| Campo                 | Validación                                | Error ejemplo                                          |
|----------------------|--------------------------------------------|--------------------------------------------------------|
| name                 | Requerido, 2–50 caracteres                 | "can't be blank", "should be 2-50 character(s)"        |
| last_name            | Requerido, 2–50 caracteres                 | "can't be blank", "should be 2-50 character(s)"        |
| email                | Requerido, formato válido, único           | "can't be blank", "has invalid format", "has already been taken" |
| password             | Requerido, 8–100 caracteres                | "can't be blank", "should be 8-100 character(s)"       |
| password_confirmation | Debe coincidir con password               | "does not match confirmation"                          |
